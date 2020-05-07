function Get-MSTerminalColorScheme {
    param(
        $Name
    )
    $SettingsPath = DetectTerminalConfigFile
    $Settings = ReadMSTerminalProfileJson $SettingsPath

    $Settings.Schemes | Where-Object {
        if($Name) {
            $_.Name -like $Name
        } else {
            $true
        }
    }
}