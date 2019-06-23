function Get-MSTerminalColorScheme {
    param(
        $Name
    )
    $Path = Find-MSTerminalFolder
    $SettingsPath = Join-Path $Path "profiles.json"
    $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json

    $Settings.Schemes | Where-Object {
        if($Name) {
            $_.Name -like $Name
        } else {
            $true
        }
    }
}