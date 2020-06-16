using namespace WindowsTerminal
function Invoke-MSTerminalGif {
    <#
.SYNOPSIS
    Plays a gif from a URI to the terminal. Useful when used as part of programs or build scripts to show "reaction gifs" to the terminal to events.
.DESCRIPTION
    This command plays animated GIFs on the Windows Terminal. It performs the operation in a background runspace and only allows one playback at a time. It also remembers your previous windows terminal settings and puts them back after it is done
.EXAMPLE
    PS C:\> Invoke-MSTerminalGif https://media.giphy.com/media/g9582DNuQppxC/giphy.gif
    Triggers a gif in the current Windows Terminal
#>
    [CmdletBinding(DefaultParameterSetName='Uri',SupportsShouldProcess)]
    param (
        #The URI of the GIF you want to display
        [Parameter(ParameterSetName='Uri',Position=0,Mandatory)][uri]$Uri,
        #The name or GUID of the Windows Terminal Profile in which to play the Gif.
        [Parameter(ValueFromPipeline)][Alias('Name','Guid')]$InputObject = (Get-MSTerminalProfile -Current),
        #How to resize the background image in the window. Options are None, Fill, Uniform, and UniformToFill
        [Parameter(ParameterSetName='Uri')][WindowsTerminal.BackgroundImageStretchMode]$BackgroundImageStretchMode = 'uniformToFill',
        #How transparent to make the background image. Default is 60% (.6)
        [Parameter(ParameterSetName='Uri')][float]$BackgroundImageOpacity = 0.6,
        #Specify this to use the Acrylic visual effect (semi-transparency)
        [Parameter(ParameterSetName='Uri')][switch]$UseAcrylic,
        #Maximum duration of the gif invocation in seconds
        [Parameter(ParameterSetName='Uri')][int]$MaxDuration = 5,
        #Occasionally, Invoke-TerminalGif may fail and leave your profile in an inconsistent state, run this command to restore the backed up profile
        [Parameter(ParameterSetName='Restore',Mandatory)][Switch]$Restore,
        #By default the backup is deleted after restoration, specify this to preserve it.
        [Parameter(ParameterSetName='Restore')][Switch]$NoClean,
        #Perform the task in the main process, rather than a separate runspace. Useful for troubleshooting or waiting for the gif to complete
        [Switch]$NoAsync
    )
    $ErrorActionPreference = 'Stop'
    #Sanity Checks
    if ($PSEdition -eq 'Desktop' -and -not (Get-Command start-threadjob -erroraction silentlycontinue)) {
        throw "This command requires the ThreadJob module on Windows Powershell 5.1. You can install it with the command Install-Module Threadjob -Scope CurrentUser"
        return
    }

    $wtProfile = Resolve-MSTerminalProfile $InputObject
    if (-not $wtProfile) { throw "Could not find the terminal profile $InputObject." }

    $profileBackupPath = Join-Path ([io.path]::GetTempPath()) "WTBackup-$($wtProfile.Guid).clixml"
    $profileBackupPathExists = Test-Path $profileBackupPath

    if ($Restore -or $profileBackupPathExists) {
        if (-not $Restore) {
            throwUser "A profile backup was found at $profileBackupPath. This usually means Invoke-MSTerminalGif was run incorrectly or terminated unexpectedly. Please run Invoke-MSTerminalGif -Restore to restore the profile or delete the file to continue."
        }
        if (-not $profileBackupPathExists) {
            throwUser "Restore was requested but no backup file was found at $profileBackupPath. This usually means it was already restored and you can continue normally."
        }
        if ($PSCmdlet.ShouldProcess($profileBackupPath, "Restoring $profileBackupPath Profile")) {
            $existingProfileSettings = Import-Clixml $profileBackupPath
            Set-MSTerminalProfile -InputObject $wtProfile @existingProfileSettings
            if (-not $NoClean) {
                Remove-Item $profileBackupPath
            }
        }
        #Exit after restoring the backup profile
        return
    }

    #Pseudo Singleton to ensure only one prompt job is running at a time
    $InvokeTerminalGifJobName = "InvokeTerminalGif-$($InputObject.Guid)"
    $InvokeTerminalGifJob = Get-Job $InvokeTerminalGifJobName -Erroraction SilentlyContinue
    if ($invokeTerminalGifJob) {
        if ($invokeTerminalGifJob.state -notmatch 'Completed|Failed') {
            Write-Warning "Last Terminal Gif Is Still Running"
            return
        } elseif ($invokeTerminalGifJob.state -eq 'Failed') {
            #TODO: Replace this with an event hook on job completion maybe: https://stackoverflow.com/a/38912216/12927399
            Write-Warning "Previous InvokeTerminalGif job failed! Output is below..."
            Receive-Job $InvokeTerminalGifJob -ErrorAction Continue
            Remove-Job $InvokeTerminalGifJob
        } else {
            Remove-Job $InvokeTerminalGifJob
        }
    }

    #Prepare arguments for the threadjob
    $terminalProfile = $wtProfile
    $ModulePath = Join-Path $ModuleRoot 'MSTerminalSettings.psd1'
    $BackgroundImage = $Uri

    $InvokeTerminalGifArgs = @(
        'TerminalProfile',
        'Uri',
        'ProfileBackupPath',
        'ModulePath',
        'BackgroundImage',
        'BackgroundImageOpacity',
        'BackgroundImageStretchMode',
        'MaxDuration',
        'UseAcrylic'
    ).foreach{
        Get-Variable -Name $PSItem -ValueOnly -ErrorAction Stop
    }

    if ($InvokeTerminalGifJob -and $InvokeTerminalGifJob.state -notmatch 'Completed|Failed') {
        Write-Warning "Invoke Terminal Already Running"
        return
    }

    $InvokeTerminalGifScriptBlock = {
        param(
            [Parameter(Mandatory)]$TerminalProfile,
            [Parameter(Mandatory)][Uri]$Uri,
            [Parameter(Mandatory)][String]$ProfileBackupPath,
            [Parameter(Mandatory)]$ModulePath,
            $BackgroundImage,
            $BackgroundImageOpacity,
            $BackgroundImageStretchMode,
            $MaxDuration,
            $UseAcrylic
        )
        $ErrorActionPreference = 'stop'
        try {
            #Back up the relevant existing settings
            $existingProfileSettings = @{}
            ('BackgroundImage','UseAcrylic','BackgroundImageOpacity','BackgroundImageStretchMode').foreach{
                $existingProfileSettings[$PSItem] = $terminalprofile.$PSItem
            }

            Export-Clixml -InputObject $existingProfileSettings -Path $profileBackupPath
            Import-Module $ModulePath

            if (-not $terminalProfile) { throw "Could not find the terminal profile $($terminalProfile.Name)." }

            Write-Verbose "Playing $uri in $($terminalProfile.Name) for $($MaxDuration) seconds"

            $SetMSTerminalParams = @{
                InputObject = $TerminalProfile
                BackgroundImage = $Uri
                UseAcrylic = $UseAcrylic
                BackgroundImageOpacity = $BackgroundImageOpacity
                BackgroundImageStretchMode = $BackgroundImageStretchMode
            }
            Set-MSTerminalProfile @SetMSTerminalParams
            Start-Sleep $Maxduration
        } catch {
            Invoke-MSTerminalGif -Restore
            Write-Error "Error Encountered: $PSItem. Restored existing backup $profileBackupPath"
        } finally {
            Write-Debug "===Settings to Revert==="
            $ExistingProfileSettings | Out-String | Write-Debug
            #Revert the previous settings
            $wtProfile = Get-MSTerminalProfile -Guid ([Guid]$TerminalProfile.Guid).ToString('B')
            $existingProfileSettings.keys.foreach{
                $wtProfile.$PSItem = $existingProfileSettings[$PSItem]
            }
            Write-Debug "===Expected Result==="
            $wtProfile | Format-List | Out-String | Write-Debug
            Write-Debug "Action: Saving to File"
            Save-MSTerminalConfig -TerminalConfig $wtProfile.TerminalConfig -ErrorAction Stop
            Remove-Item $profileBackupPath
        }
    }

    $startJobParams = @{
        ScriptBlock = $InvokeTerminalGifScriptBlock
        ArgumentList = $InvokeTerminalGifArgs
    }

    $invokeTerminalGifPostRunHandler = {
        $ErrorActionPreference = 'Stop'
        try {
            switch ($eventArgs.JobStateInfo) {
                'Completed' {
                    Write-Verbose "Invoke-MSTerminalGif Job Completed"
                    Remove-Job $Sender -Force
                    Remove-Job -Id $Event.EventIdentifier -Force
                }
                'Failed' {
                    Write-Host -fore Cyan (Receive-Job $Sender -ErrorAction SilentlyContinue -WarningAction silentlycontinue -ErrorVariable jobError -WarningVariable jobWarn)
                    if ($jobError) {Write-Host -fore Red "Invoke-MSTerminalGifJob ERROR: $jobError"}
                    if ($jobWarn) {Write-Host -fore Orange "Invoke-MSTerminalGifJob WARNING: $jobWarn"}
                    # $profileGuid = $sender.Name -replace 'InvokeTerminalGif-',''
                    # $profileBackupPath = Join-Path ([io.path]::GetTempPath()) "WTBackup-$profileGuid.clixml"
                    # write-host -fore yellow $profileBackupPath
                    # write-host -fore yellow (Test-Path $profileBackupPath)
                    Remove-Job $Sender -Force
                    Remove-Job -Id $Event.EventIdentifier -Force
                }
                default {return}
            }
        } catch {
            #Exceptions don't emit from event handlers
            Write-Host -fore red "InvokeTerminalGifPostRunHandler ERROR: $PSItem"
        }
    }

    if ($NoAsync) {
        Invoke-Command @startJobParams
    } else {
        $invokeTerminalGifJob = Start-ThreadJob @startJobParams -Name $InvokeTerminalGifJobName
        $invokeTerminalGifPostRunHandlerParams = @{
            InputObject = $invokeTerminalGifJob
            EventName = 'StateChanged'
            Action = $invokeTerminalGifPostRunHandler
            MaxTriggerCount = 2
        }
        Register-ObjectEvent @invokeTerminalGifPostRunHandlerParams > $null
    }
}