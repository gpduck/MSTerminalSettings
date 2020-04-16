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
    [CmdletBinding(DefaultParameterSetName='Uri')]
    param (
        #The URI of the GIF you want to display
        [Parameter(ParameterSetName='Uri',Position=0,Mandatory)][uri]$Uri,
        #The name or GUID of the Windows Terminal Profile in which to play the Gif.
        [Parameter(ParameterSetName='Uri',ValueFromPipelineByPropertyName)][String][Alias('Guid')]$Name,
        #How to resize the background image in the window. Options are None, Fill, Uniform, and UniformToFill
        [Parameter(ParameterSetName='Uri')][BackgroundImageStretchMode]$StretchMode = 'uniformToFill',
        #How transparent to make the background image. Default is 60% (.6)
        [Parameter(ParameterSetName='Uri')][float]$BackgroundImageOpacity = 0.6,
        #Specify this to use the Acrylic visual effect (semi-transparency)
        [Parameter(ParameterSetName='Uri')][switch]$Acrylic,
        #Maximum duration of the gif invocation in seconds
        [Parameter(ParameterSetName='Uri')][int]$MaxDuration = 5,
        #Occasionally, Invoke-TerminalGif may fail and leave your profile in an inconsistent state, run this command to restore the backed up profile
        [Parameter(ParameterSetName='Restore',Mandatory)][Switch]$Restore,
        #By default the backup is deleted after restoration, specify this to preserve it.
        [Parameter(ParameterSetName='Restore')][Switch]$NoClean
    )

    #Sanity Checks
    if ($PSEdition -eq 'Desktop' -and -not (Get-Command start-threadjob -erroraction silentlycontinue)) {
        throw "This command requires the ThreadJob module on Windows Powershell 5.1. You can install it with the command Install-Module Threadjob -Scope CurrentUser"
        return
    }

    $TerminalProfile = if ($Name -as [Guid]) {
        Get-MSTerminalProfile -Guid $Name -ErrorAction stop
    } else {
        Get-MSTerminalProfile -Name $Name -ErrorAction stop
    }
    if (-not $Name) {$TerminalProfile = Find-CurrentTerminalProfile}

    $profileBackupPath = Join-Path ([io.path]::GetTempPath()) "WTBackup-$($terminalprofile.Guid).clixml"
    $ProfileBackupPathExists = Test-Path $ProfileBackupPath

    if ($Restore -or $ProfileBackupPathExists) {
        if (-not $Restore) {
            throwUser "A profile backup was found at $ProfileBackupPath. This usually means Invoke-MSTerminalGif was run incorrectly. Please run Invoke-MSTerminalGif -Restore to restore the profile or delete the file to continue."
        }
        if (-not $ProfileBackupPathExists) {
            throwUser "Restore was requested but no backup file was found at $ProfileBackupPath. This usually means it was already restored and you can continue normally."
        }
        Write-Verbose "Restoring $profilebackupPath Profile"
        $existingProfileSettings = Import-Clixml $profileBackupPath
        $wtProfile = $TerminalProfile
        $existingProfileSettings.keys.foreach{
            $wtProfile.$PSItem = $existingProfileSettings[$PSItem]
        }
        Save-MSTerminalConfig -TerminalConfig $wtProfile.TerminalConfig -ErrorAction Stop

        if (-not $NoClean) {
            Remove-Item $profileBackupPath
        }
        #Exit function at the point after restore completes
        return
    }

    #Pseudo Singleton to ensure only one prompt job is running at a time
    $InvokeTerminalGifJobName = 'InvokeTerminalGif'
    $InvokeTerminalGifJob = Get-Job $InvokeTerminalGifJobName -Erroraction SilentlyContinue
    if ($invokeTerminalGifJob) {
        if ($invokeTerminalGifJob.state -notmatch 'Completed|Failed') {
            Write-Warning "Last Terminal Gif Is Still Running"
            return
        } elseif ($invokeTerminalGifJob.state -eq 'Failed') {
            #TODO: Replace this with an event hook on job completion maybe: https://stackoverflow.com/a/38912216/12927399
            write-warning "Previous InvokeTerminalGif job failed! Output is below..."
            Receive-Job $InvokeTerminalGifJob -ErrorAction Continue
            Remove-Job $InvokeTerminalGifJob
        } else {
            Remove-Job $InvokeTerminalGifJob
        }
    }
    $TerminalProfile = if ($Name -as [Guid]) {
        Get-MSTerminalProfile -Guid $Name -ErrorAction stop
    } else {
        Get-MSTerminalProfile -Name $Name -ErrorAction stop
    }
    if (-not $Name) {$TerminalProfile = Find-CurrentTerminalProfile}

    #Prepare arguments for the threadjob
    $TerminalGifJobParams = @{ }
    ('terminalprofile','uri', 'maxduration', 'stretchmode','acrylic','backgroundimageopacity','profileBackupPath').foreach{
        $TerminalGifJobParams.$PSItem = (Get-Variable $PSItem).value
    }
    $TerminalGifJobParams.ModulePath = Join-Path $ModuleRoot 'MSTerminalSettings.psd1'

    if (-not $TerminalGifJobParams.terminalprofile) { throw "Could not find the terminal profile $Name." }

    if (-not $InvokeTerminalGifJob -or ($InvokeTerminalGifJob.state -eq 'Completed')) {
        $null = Start-ThreadJob -Name $InvokeTerminalGifJobName -argumentlist $TerminalGifJobParams {
            #TODO: Maybe abstract this into params and ValueFromRemainingArguments?
            Import-Module $args.modulepath
            $uri = $args.uri
            $terminalProfile = $args.terminalprofile
            $profileBackupPath = $args.profileBackupPath

            #Back up the relevant existing settings
            $existingProfileSettings = @{}
            ('BackgroundImage','UseAcrylic','BackgroundImageOpacity','BackgroundImageStretchMode').foreach{
                $existingProfileSettings[$PSItem] = $terminalprofile.$PSItem
            }

            Export-Clixml -InputObject $existingProfileSettings -Path $profileBackupPath

            if (-not $terminalProfile) { throw "Could not find the terminal profile $($terminalProfile.Name)." }

            Write-Output "Playing $uri in $($terminalProfile.Name) for $($args.maxduration) seconds"
            $erroractionpreference = 'stop'
            try {
                Set-MSTerminalProfile -InputObject $terminalProfile -BackgroundImage $uri -UseAcrylic:$args.acrylic -BackgroundImageOpacity $args.backgroundimageopacity -BackgroundImageStretchMode $args.StretchMode
                Start-Sleep $args.maxduration
            } catch { Write-Error $PSItem }
            finally {
                Write-Output "Reverting to the previous settings"
                $ExistingProfileSettings | Out-String
                #Revert the previous settings
                $wtProfile = Get-MSTerminalProfile -Guid $terminalProfile.Guid.ToString('B')
                $existingProfileSettings.keys.foreach{
                    $wtProfile.$PSItem = $existingProfileSettings[$PSItem]
                }
                Save-MSTerminalConfig -TerminalConfig $wtProfile.TerminalConfig -ErrorAction Stop
                Remove-Item $profileBackupPath
            }
        }
    } else {
        Write-Warning "Invoke Terminal Already Running"
    }
}