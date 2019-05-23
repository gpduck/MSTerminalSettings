function New-MSTerminalProfile {
    [CmdletBinding(SupportsShouldProcess=$true)]
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidDefaultValueSwitchParameter", "")]
    param(
        [Parameter(Mandatory=$true)]
        $Name,

        [Parameter(Mandatory=$true)]
        $CommandLine,

        [switch]$MakeDefault,

        [Int]$HistorySize = 9001,

        [switch]$SnapOnInput = $true,

        $ColorScheme = "Campbell",

        $CursorColor = "#ffffff",

        [ValidateSet("bar","vintage")]
        $CursorShape = "bar",

        $FontFace = "Consolas",

        $StartingDirectory = "%USERPROFILE%",

        [ValidateRange(1,[Int]::MaxValue)]
        [int]$FontSize = 12,

        [ValidateRange(0,1)]
        [float]$AcrylicOpacity = 0.5,

        [switch]$UseAcrylic,

        [switch]$CloseOnExit = $true,

        $Icon,

        [ValidateCount(4,4)]
        [int[]]$Padding = @(0,0,0,0)
    )
    $Path = Find-MSTerminalFolder
    $SettingsPath = Join-Path $Path "RoamingState/profiles.json"
    $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json
    foreach($p in $Settings.Profiles) {
        if($P.Name -eq $Name) {
            Write-Error "Profile $Name already exists" -ErrorAction Stop
            return
        }
    }

    $Profile = @{
        name = $Name
        guid = "{$([Guid]::NewGuid().Guid)}"
        commandline = $CommandLine
    }
    if($ColorScheme) {
        $Profile["colorscheme"] = $ColorScheme
    }
    if($CursorColor) {
        $Profile["cursorColor"] = $CursorColor
    }
    if($CursorShape) {
        $Profile["cursorShape"] = $cursorShape
    }
    if($HistorySize) {
        $Profile["historySize"] = $HistorySize
    }
    if($FontFace) {
        $Profile["fontFace"] = $FontFace
    }
    if($FontSize) {
        $Profile["fontSize"] = $FontSize
    }
    if($AcrylicOpacity) {
        $Profile["acrylicOpacity"] = $AcrylicOpacity
    }
    $Profile["useAcrylic"] = $UseAcrylic.IsPresent
    $Profile["closeOnExit"] = $CloseOnExit.IsPresent
    $Profile["snapOnInput"] = $SnapOnInput.IsPresent
    if($StartingDirectory) {
        $Profile["startingDirectory"] = $StartingDirectory
    }
    if($Icon) {
        $Profile["icon"] = $Icon
    }
    if($Padding.Count -gt 0) {
        $Profile["padding"] = $padding -Join ", "
    }
    if($MakeDefault) {
        $Settings.defaultProfile = $Profile["guid"]
    }

    if($PSCmdlet.ShouldProcess($Name, "Add MS Terminal profile")) {
        $Settings.Profiles += $Profile
        ConvertTo-Json $Settings -Depth 10 | Set-Content -Path $SettingsPath
    }
}