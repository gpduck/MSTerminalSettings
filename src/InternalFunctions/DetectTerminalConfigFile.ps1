<#
.SYNOPSIS
This command will return the path to the right configuration file for Windows Terminal.
.NOTES
In version 0.11.1121.0 the configuration file for Windows Terminal (`profiles.json`) has been renamed to `settings.json`.
#>
function DetectTerminalConfigFile {
    try {
        $TerminalApp = Get-AppxPackage -Name Microsoft.WindowsTerminal
    } catch {
        throw "This only works if Windows Terminal is installed on this computer."
    }
    $Path = Find-MSTerminalFolder
    if ($TerminalApp.Version -ge 0.11.1121.0) {
        $SettingsPath = Join-Path $Path "settings.json"
    } else {
        $SettingsPath = Join-Path $Path "profiles.json"
    }

    return $SettingsPath
}