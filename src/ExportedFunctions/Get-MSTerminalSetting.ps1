function Get-MSTerminalSetting {
    param(
        [Switch]$Force
    )
    $Path = Find-MSTerminalFolder
    $SettingsPath = Join-Path $Path "RoamingState/profiles.json"
    $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json

    if($Force) {
        $Settings
    } else {
        $Settings | Select-Object -Property * -ExcludeProperty Profiles,Schemes
    }
}