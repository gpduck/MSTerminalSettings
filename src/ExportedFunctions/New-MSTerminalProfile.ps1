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

        [ValidateSet("center","left","top","right","bottom","topLeft","topRight","bottomLeft","bottomRight")]
        [AllowNull()]
        [string]$BackgroundImageAlignment,

        [ValidateRange(0,1)]
        [double]$BackgroundImageOpacity,

        [ValidateSet("none","fill","uniform","uniformToFill")]
        [String]$BackgroundImageStretchMode,

        [switch]$Hidden,

        [ValidateSet("visible","hidden")]
        [string]$ScrollbarState,

        [ValidateSet("Windows.Terminal.Azure","Windows.Terminal.PowershellCore","Windows.Terminal.Wsl")]
        [string]$Source,

        [GUID]$Guid,

        [string]$TabTitle,

        [switch]$CloseOnExit = $true,

        [String]$Icon,

        [ValidateCount(4,4)]
        [int[]]$Padding = @(0,0,0,0),

        #Arbitrary properties, no validation occurs here so use at your own risk!
        [HashTable]$ExtraSettings
    )
    $Path = Find-MSTerminalFolder
    $SettingsPath = Join-Path $Path "profiles.json"
    $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json | ConvertPSObjectToHashtable
    if($Settings.Globals) {
        $Global = $Settings["globals"]
    } else {
        $Global = $Settings
    }

    foreach($p in $Settings.Profiles) {
        if($P.Name -eq $Name) {
            Write-Error "Profile $Name already exists" -ErrorAction Stop
            return
        }
    }

    if(!$Guid) {
        $Guid = [Guid]::NewGuid()
    }
    $GuidString = "{$Guid}"

    $Profile = @{
        name = $Name
        guid = $GuidString
        commandline = $CommandLine
    }
    $Properties = @(
        "acrylicOpacity",
        "background",
        "backgroundImage",
        "backgroundImageAlignment",
        "backgroundImageOpacity",
        "backgroundImageStretchMode",
        "closeOnExit",
        "colorScheme",
        "colorTable",
        "cursorColor",
        "cursorHeight",
        "cursorShape",
        "fontFace",
        "fontSize",
        "foreground",
        "hidden",
        "historySize",
        "icon",
        "scrollbarState",
        "snapOnInput",
        "source",
        "startingDirectory",
        "tabTitle",
        "useAcrylic"
    )
    CopyHashtable -Source $PSBoundParameters -Destination $Profile -Keys $Properties

    if($Padding.Count -gt 0) {
        $Profile["padding"] = $padding -Join ", "
    }
    if($MakeDefault) {
        $Global["defaultProfile"] = $Profile["guid"]
    }

    #Process arbitrary at-your-own-risk properties at the end
    $ExtraSettings.keys.foreach{
        $Profile["$_"] = $ExtraSettings["$_"]
    }

    if($PSCmdlet.ShouldProcess($Name, "Add MS Terminal profile")) {
        $Settings.Profiles += $Profile
        ConvertTo-Json $Settings -Depth 10 | Set-Content -Path $SettingsPath
    }
}