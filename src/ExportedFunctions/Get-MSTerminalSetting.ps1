function Get-MSTerminalSetting {
    param(
        [Switch]$Force
    )
    $SettingsPath = DetectTerminalConfigFile
    $Settings = ReadMSTerminalProfileJson $SettingsPath

    if($Settings.Globals) {
        $Settings = $Settings.Globals
        $Settings
    } else {
        if($Force) {
            Write-Warning "The -Force switch is deprecated on Get-MSTerminalSetting as future versions of Terminal separate out the global settings."
            $Settings
        } else {
            $Settings | Select-Object -Property * -ExcludeProperty Profiles,Schemes
        }
    }
}