
function Invoke-MSTerminalGif {
    <#
.SYNOPSIS
    Plays a gif from a URI to the terminal. Useful when used as part of programs or build scripts to show "reaction gifs" to the terminal to events.
.DESCRIPTION
    This command plays animated GIFs on the Windows Terminal. It performs the operation in a background runspace and only allows one playback at a time. It also remembers your previous windows terminal settings and puts them back after it is done
.EXAMPLE
    PS C:\> Invoke-TerminalGif https://media.giphy.com/media/g9582DNuQppxC/giphy.gif
    Triggers a gif in the current Windows Terminal
#>
    [CmdletBinding()]
    param (
        #The URI of the GIF you want to display
        [Parameter(Mandatory)][uri]$Uri,
        #The name or GUID of the Windows Terminal Profile in which to play the Gif.
        [String][Alias('GUID')]$Name,
        #How to resize the background image in the window. Options are None, Fill, Uniform, and UniformToFill
        [ValidateSet('none', 'fill', 'uniform', 'uniformToFill')][String]$StretchMode = 'uniformToFill',
        #How transparent to make the background image. Default is 60% (.6)
        [float]$BackgroundImageOpacity = 0.6,
        #Specify this to use the Acrylic visual effect (semi-transparency)
        [switch]$Acrylic,
        #Maximum duration of the gif invocation in seconds
        [int]$MaxDuration = 5
    )

    #Sanity Checks
    if (-not $env:WT_SESSION) { throw "This only works in Windows Terminal currently. Please try running this command again inside a Windows Terminal powershell session." }
    if ($PSEdition -eq 'Desktop' -and -not (Get-Command start-threadjob -erroraction silentlycontinue)) {
        throw "This command requires the ThreadJob module on Windows Powershell 5.1. You can install it with the command Install-Module Threadjob -Scope CurrentUser"
        return
    }

    #Pseudo Singleton to ensure only one prompt job is running at a time.
    $InvokeTerminalGifJobName = 'InvokeTerminalGif'
    $InvokeTerminalGifJob = Get-Job $InvokeTerminalGifJobName -Erroraction SilentlyContinue
    if ($invokeTerminalGifJob) {
        if ($invokeTerminalGifJob.state -notmatch 'Completed|Failed') {
            Write-Warning "Terminal Gif Already Running"
            return
        } else {
            Remove-Job $InvokeTerminalGifJob
        }
    }

    $TerminalProfile = if ($Name -as [Guid]) {
        Get-MSTerminalProfile -Guid $Name -ErrorAction stop
    } else {
        Get-MSTerminalProfile -Name $Name -ErrorAction stop
    }

    #Prepare arguments for the threadjob
    $TerminalGifJobParams = @{ }
    ('terminalprofile','uri', 'maxduration', 'stretchmode','acrylic','backgroundimageopacity').foreach{
        $TerminalGifJobParams.$PSItem = (Get-Variable $PSItem).value
    }

    $TerminalGifJobParams.modulePath = (Get-Module msterminalsettings).path -replace 'psm1$','psd1'

    if (-not $TerminalGifJobParams.terminalprofile) { throw "Could not find the terminal profile $Name." }
    if (-not $InvokeTerminalGifJob -or ($InvokeTerminalGifJob.state -eq 'Completed')) {
        $null = Start-ThreadJob -Name $InvokeTerminalGifJobName -argumentlist $TerminalGifJobParams {
            Import-Module $args.modulepath
            $uri = $args.uri
            $terminalProfile = $args.terminalprofile

            if (-not $terminalProfile) { throw "Could not find the terminal profile $($terminalProfile.Name)." }

            Write-Output "Playing $uri"
            $erroractionpreference = 'stop'
            try {
                Set-MSTerminalProfile -InputObject $terminalProfile -BackgroundImage $uri -UseAcrylic:$args.acrylic -BackgroundImageOpacity $args.backgroundimageopacity -BackgroundImageStretchMode $args.StretchMode
                Start-Sleep $args.maxduration
            } catch { Write-Error $PSItem } finally {
                #Reset to a blank if for some reason the gif was the background previously.
                if ($terminalProfile.BackgroundImage -eq $uri) {
                    Write-Warning "Picture was same as previous picture, setting blank background"
                    $terminalProfile.BackgroundImage = $null
                }

                $backGroundImageStretchMode = if ($terminalProfile.backgroundImageStretchMode) {
                    $terminalProfile.backgroundImageStretchMode
                } else {
                    'none'
                }
                Set-MSTerminalProfile -InputObject $terminalProfile -BackgroundImage $TerminalProfile.BackgroundImage -BackgroundImageStretchMode $backGroundImageStretchMode -UseAcrylic:$TerminalProfile.UseAcrylic -BackgroundImageOpacity $TerminalProfile.BackgroundImageOpacity
            }
        }
    } else {
        Write-Warning "Invoke Terminal Already Running"
    }
}