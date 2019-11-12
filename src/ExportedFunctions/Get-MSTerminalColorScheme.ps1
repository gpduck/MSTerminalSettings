function Get-MSTerminalColorScheme {
    param(
        $Name
    )
    $Path = Find-MSTerminalFolder
    $SettingsPath = Join-Path $Path "profiles.json"
    $Settings = ReadMSTerminalProfileJson $SettingsPath

    $Settings.Schemes | Where-Object {
        if($Name) {
            $_.Name -like $Name
        } else {
            $true
        }
    }
}