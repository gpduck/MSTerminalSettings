<#
.SYNOPSIS
This command will use a variety of probing methods to determine what the current powershell profile is.
.NOTES
THis is an imperfect process, a better method would be to correlate the WT_SESSION to the profile, if an API ever exists for this.
#>
function DetectCurrentTerminalProfile {
    if (-not $env:WT_SESSION) { throw "This only works in Windows Terminal currently. Please try running this command again inside a Windows Terminal powershell session." }

    #Detection Method 1: Profile Environment Variable
    if ($env:WT_PROFILE) {
        $profileName = $env:WT_PROFILE
        write-verbose "Detected WT_PROFILE is set to $profileName, fetching if profile exists"
        if ($profileName -as [Guid]) {
            return Get-MSTerminalProfile -Guid $profileName -ErrorAction Stop
        } else {
            return Get-MSTerminalProfile -Name $profileName -ErrorAction Stop
        }
    }

    #Detection Method 2: Check the powershell executable type and if only one profile that doesn't have WT_PROFILE already defined matches, return that.
    $psExe = Get-Process -PID $pid
    $psExePath = $psExe.Path
    $psExeName = $psExe.ProcessName
    $profiles = Get-MSTerminalProfile

    if ($psExeName -eq 'pwsh') {
        $candidateProfiles = $profiles.where{
            $PSItem.source -eq 'Windows.Terminal.PowershellCore' -or $PSItem.commandline -match [regex]::Escape($psExeName)
        }
    } else {
        $candidateProfiles = $profiles.where{$PSItem.commandline -match [regex]::Escape($psExeName)}
    }

    #The PSCustomObject array cast is to enable count to work properly in PS5.1 (it returns nothing on a non-array). Unnecessary in PS6+
    [PSCustomObject[]]$candidateProfiles = $candidateProfiles | where commandline -notmatch 'WT_PROFILE'

    #If there were no matches, bail out gracefully
    if (-not $candidateprofiles) {
        write-debug "Terminal Detection: No profiles found that match $psExeName"
        throw "Unable to detect your currently running profile. Please specify the -Name parameter, or set the WT_PROFILE environment variable"
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
        throw "Multiple ambiguous profiles for $psExe were found: {0}. Please specify a profile with the -Name parameter or set the WT_PROFILE environment variable within your session" -f $candidateProfiles.Name -join ', '
    }

    #Failsafe code path
    throw "A profile could not be located. This is a bug, this exception shouldn't be reached"
}