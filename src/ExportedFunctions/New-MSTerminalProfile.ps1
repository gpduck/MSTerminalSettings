function New-MSTerminalProfile {
    [CmdletBinding(SupportsShouldProcess=$true)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidDefaultValueSwitchParameter", "")]
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name,

        [Parameter(Mandatory=$true)]
        [String]$CommandLine,

        [switch]$MakeDefault,

        [ValidateRange(-1,32767)]
        [Int]$HistorySize = 9001,

        [switch]$SnapOnInput = $true,

        [String]$ColorScheme = "Campbell",

        [ValidateCount(16,16)]
        [string[]]$ColorTable,

        [String]$CursorColor = "#ffffff",

        [ValidateSet("bar","emptyBox","filledBox","underscore","vintage")]
        [String]$CursorShape = "bar",

        [ValidateRange(25,100)]
        [int]$CursorHeight,

        [String]$FontFace = "Consolas",

        [String]$StartingDirectory = "%USERPROFILE%",

        [ValidateRange(1,[Int]::MaxValue)]
        [int]$FontSize = 10,

        [string]$Background,

        [string]$Foreground,

        [ValidateRange(0,1)]
        [float]$AcrylicOpacity = 0.5,

        [switch]$UseAcrylic,

        [String]$BackgroundImage,

        [ValidateRange(0,1)]
        [double]$BackgroundImageOpacity,

        [ValidateSet("none","fill","uniform","uniformToFill")]
        [String]$BackgroundImageStretchMode,

        [ValidateSet("visible","hidden")]
        [string]$ScrollbarState,

        [switch]$CloseOnExit = $true,

        [String]$Icon,

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
    $ValueProperties = @(
        "backgroundImage",
        "backgroundImageOpacity",
        "backgroundImageStretchMode",
        "colorTable",
        "foreground"
    )
    $ValueProperties | ForEach-Object {
        if($PSBoundParameters.ContainsKey($_)) {
            $Profile[$_] = $PSBoundParameters[$_]
        }
    }
    if($ColorScheme) {
        $Profile["colorScheme"] = $ColorScheme
    }
    if($CursorColor) {
        $Profile["cursorColor"] = $CursorColor
    }
    if($CursorShape) {
        $Profile["cursorShape"] = $cursorShape
    }
    if($CursorHeight) {
        $Profile["cursorHeight"] = $CursorHeight
    }
    if($HistorySize) {
        $Profile["historySize"] = $HistorySize
    }
    if($Background) {
        $Profile["background"] = $Background
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
    if($ScrollbarState) {
        $Profile["scrollbarState"] = $ScrollbarState
    }
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