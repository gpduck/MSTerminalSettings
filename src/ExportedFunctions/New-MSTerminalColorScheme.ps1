function New-MSTerminalColorScheme {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)]
        $Name,

        [Parameter(Mandatory=$true)]
        $Foreground,

        [Parameter(Mandatory=$true)]
        $Background,

        [Parameter(Mandatory=$true)]
        [ValidateCount(16,16)]
        [string[]]$Colors
    )
    $Path = Find-MSTerminalFolder
    $SettingsPath = Join-Path $Path "RoamingState/profiles.json"
    $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json -AsHashtable

    if(!$Settings.ContainsKey("schemes")) {
        $Settings["schemes"] = @()
    }
    foreach($s in $Settings["schemes"]) {
        if($s["name"] -eq $Name) {
            Write-Error "Color scheme $Name already exists" -ErrorAction Stop
            return
        }
    }

    if($PSCmdlet.ShouldProcess($Name, "Add MS Terminal color scheme")) {
        $Settings["schemes"] += [PSCustomObject]@{
            name = $Name
            foreground = $Foreground
            background = $Background
            colors = $Colors
        }
        ConvertTo-Json $Settings -Depth 10 | Set-Content -Path $SettingsPath
    }
}