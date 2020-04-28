<#
.SYNOPSIS
This command will use a variety of probing methods to determine what the current powershell profile is.
.NOTES
THis is an imperfect process, a better method would be to correlate the WT_SESSION to the profile, if an API ever exists for this.
#>
function Find-CurrentTerminalProfile {
    $ErrorActionPreference = 'Stop'
    if (-not $env:WT_SESSION) { throwUser "This only works in Windows Terminal currently. Please try running this command again inside a Windows Terminal powershell session." }
    #Detection Method 1: Profile Environment Variable
    if ($env:WT_PROFILE_ID) {
        $profileName = $env:WT_PROFILE_ID
        write-debug "Terminal Detection: Detected WT_PROFILE_ID is set to $profileName, fetching if profile exists"
        if ($profileName -as [Guid]) {
            return Get-MSTerminalProfile -Guid $profileName
        } else {
            return Get-MSTerminalProfile -Name $profileName
        }
    }

    #Detection Method 2: Check the powershell executable type and if only one profile that doesn't have WT_PROFILE_ID already defined matches, return that.
    $psExe = Get-Process -PID $pid
    $psExePath = $psExe.Path
    $psExeName = $psExe.ProcessName
    $WTProfile = Get-MSTerminalProfile

    if ($psExeName -eq 'pwsh') {
        $candidateProfiles = $WTProfile.where{
            $PSItem.source -eq 'Windows.Terminal.PowershellCore' -or $PSItem.commandline -match [regex]::Escape($psExeName)
        }
    } else {
        $candidateProfiles = $WTProfile.where{$PSItem.commandline -match [regex]::Escape($psExeName)}
    }

    #The PSCustomObject array cast is to enable count to work properly in PS5.1 (it returns nothing on a non-array). Unnecessary in PS6+
    [PSCustomObject[]]$candidateProfiles = $candidateProfiles | Where-Object commandline -notmatch 'WT_PROFILE_ID'

    #If there were no matches, bail out gracefully
    if (-not $candidateprofiles) {
        write-debug "Terminal Detection: No profiles found that match $psExeName"
        throwUser "Unable to detect your currently running profile. Please specify the -Name parameter, or set the WT_PROFILE_ID environment variable"
    }

    #If there was only one result, return it
    if ($candidateProfiles.count -eq 1) {
        write-debug ("Terminal Detection: Found single profile that matches $psExeName, returning {0} {1}." -f $candidateProfiles[0].Name,$candidateProfiles[0].Guid)
        return $candidateProfiles[0]
    }

    #If there were multiple results, try matching by absolute path, otherwise fail with ambiguous
    if ($candidateProfiles.count -gt 1) {
        $absolutePathProfile = $candidateProfiles | Where-Object commandline -eq $PSExePath
        if ($absolutePathProfile.count -eq 1) {return $absolutePathProfile}

        #Fail if multiple profiles were found but could not be determined which was ours
        throwUser "Multiple ambiguous profiles for $psExe were found: {0}. Please specify a profile with the -Name parameter or set the WT_PROFILE_ID environment variable within your session" -f $candidateProfiles.Name -join ', '
    }

    #Failsafe code path
    throwUser "A profile could not be located. This is a bug, this exception shouldn't be reached"
}