
function Find-MSTerminalFolder {
    $PackageNames = @(
        "Microsoft.WindowsTerminal_8wekyb3d8bbwe",
        "WindowsTerminalDev_8wekyb3d8bbwe"
    )
    foreach($Name in $PackageNames) {
        $Path = Join-Path $env:LOCALAPPDATA "packages/$Name"
        if(Test-Path $Path) {
            break
        }
    }
    $Path
}

function Get-MSTerminalProfile {
    param(
        $Name
    )

    $Path = Find-MSTerminalFolder
    if(!$Path) {
        Write-Error "Cannot locate MS Terminal package" -ErrorAction Stop
        return
    }

    $ProfilesJson = Join-Path $Path "RoamingState/profiles.json"
    Get-Content -Path $ProfilesJson -Raw | ConvertFrom-Json | ForEach-Object {
        $_.Profiles
    } | Where-Object {
        if($Name) {
            $_.Name -like $Name
        } else {
            $true
        }
    }
}

function New-MSTerminalProfile {
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

        [ValidateCount(4)]
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

    $Settings.Profiles += $Profile
    ConvertTo-Json $Settings -Depth 10 | Set-Content -Path $SettingsPath
}

function Set-MSTerminalProfile {
    [CmdletBinding(DefaultParameterSetName="Name")]
    param(
        [Parameter(Mandatory=$true,ParameterSetname="Name")]
        $Name,

        [Parameter(Mandatory=$true,ParameterSetName="InputObject",ValueFromPipeline=$true)]
        $InputObject,

        $CommandLine,

        [switch]$MakeDefault,

        [Int]$HistorySize,

        [switch]$SnapOnInput,

        $ColorScheme,

        $CursorColor,

        [ValidateSet("bar","vintage")]
        $CursorShape,

        $FontFace,

        $StartingDirectory,

        [ValidateRange(1,[Int]::MaxValue)]
        [int]$FontSize,

        [ValidateRange(0,1)]
        [float]$AcrylicOpacity,

        [switch]$UseAcrylic,

        [switch]$CloseOnExit,

        $Icon,

        [ValidateCount(4)]
        [int[]]$Padding
    )
    process {
        if($PSCmdlet.ParametersetName -eq "Name") {
            $InputObject = Get-MSTerminalProfile -name $Name
        }

        $Path = Find-MSTerminalFolder
        $SettingsPath = Join-Path $Path "RoamingState/profiles.json"
        $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json

        if($CommandLine) {
            $InputObject.commandline = $CommandLine
        }
        if($ColorScheme) {
            $InputObject.colorscheme = $ColorScheme
        }
        if($CursorColor) {
            $InputObject.cursorColor = $CursorColor
        }
        if($CursorShape) {
            $InputObject.cursorShape = $cursorShape
        }
        if($HistorySize) {
            $InputObject.historySize = $HistorySize
        }
        if($FontFace) {
            $InputObject.fontFace = $FontFace
        }
        if($FontSize) {
            $InputObject.fontSize = $FontSize
        }
        if($AcrylicOpacity) {
            $InputObject.acrylicOpacity = $AcrylicOpacity
        }
        if($PSBoundParameters.ContainsKey("UseAcrylic")) {
            $InputObject.UseAcrylic = $UseAcrylic.IsPresent
        }
        if($PSBoundParameters.ContainsKey("UseAcrylic")) {
            $InputObject.closeOnExit = $CloseOnExit.IsPresent
        }
        if($PSBoundParameters.ContainsKey("UseAcrylic")) {
            $InputObject.snapOnInput = $SnapOnInput.IsPresent
        }
        if($StartingDirectory) {
            $InputObject.startingDirectory = $StartingDirectory
        }
        if($Icon) {
            $InputObject.icon = $Icon
        }
        if($Padding.Count -gt 0) {
            $InputObject.padding = $padding -Join ", "
        }

        $NewProfiles = $Settings.Profiles | ForEach-Object {
            if($_.Guid -eq $InputObject.Guid) {
                $InputObject
            } else {
                $_
            }
        }
        $Settings.Profiles = $NewProfiles
        ConvertTo-Json $Settings -Depth 10 | Set-Content -Path $SettingsPath
    }
}

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
        $Settings | Select-Object -ExcludeProperty Profiles,Schemes
    }
}

function Set-MSTerminalSetting {
    param(
        $DefaultProfile,

        [ValidateRange(1,[int]::MaxValue)]
        $InitialRows,

        [ValidateRange(1,[int]::MaxValue)]
        [int]$InitialCols,

        [Switch]$AlwaysShowTabs,

        [Switch]$ShowTerminalTitleInTitlebar,

        [Switch]$Experimental_ShowTabsInTitlebar,

        [Hashtable]$ExtraSettings
    )
    $Path = Find-MSTerminalFolder
    $SettingsPath = Join-Path $Path "RoamingState/profiles.json"
    $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json -AsHashtable

    if($DefaultProfile) {
        $Settings["defaultProfile"] = $DefaultProfile
    }
    if($InitialRows) {
        $Settings["initialRows"] = $InitialRows
    }
    if($InitialCols) {
        $Settings["initialCols"] = $InitialCols
    }
    if($PSBoundParameters.ContainsKey("AlwaysShowTabs")) {
        $Settings["alwaysShowTabs"] = $AlwaysShowTabs.IsPresent
    }
    if($PSBoundParameters.ContainsKey("ShowTerminalTitleInTitlebar")) {
        $Settings["showTerminalTitleInTitlebar"] = $ShowTerminalTitleInTitlebar.IsPresent
    }
    if($PSBoundParameters.ContainsKey("Experimental_ShowTabsInTitlebar")) {
        $Settings["experimental_ShowTabsInTitlebar"] = $Experimental_ShowTabsInTitlebar.IsPresent
    }
    ConvertTo-Json $Settings -Depth 10 | Set-Content -Path $SettingsPath
}

function Get-MSTerminalColorScheme {
    param(
        $Name
    )
    $Path = Find-MSTerminalFolder
    $SettingsPath = Join-Path $Path "RoamingState/profiles.json"
    $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json

    $Settings.Schemes | Where-Object {
        if($Name) {
            $_.Name -like $Name
        } else {
            $true
        }
    }
}

function New-MSTerminalColorScheme {
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
        Write-Host "Adding empty schemes element"
        $Settings["schemes"] = @()
    }
    foreach($s in $Settings["schemes"]) {
        if($s["name"] -eq $Name) {
            Write-Error "Color scheme $Name already exists" -ErrorAction Stop
            return
        }
    }

    $Settings["schemes"] += [PSCustomObject]@{
        name = $Name
        foreground = $Foreground
        background = $Background
        colors = $Colors
    }
    ConvertTo-Json $Settings -Depth 10 | Set-Content -Path $SettingsPath
}

function Remove-MSTerminalColorScheme {
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="High")]
    param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [string[]]$Name
    )
    begin {
        $Path = Find-MSTerminalFolder
        $SettingsPath = Join-Path $Path "RoamingState/profiles.json"
        $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json
        $SchemesToRemove = @()
    }
    process {
        $Name | ForEach-Object {
            $SchemesToRemove += $_
        }
    }
    end {
        $RemainingSchemes = $Settings.Schemes | Where-Object {
            $_.Name -notin $SchemesToRemove
        }
        if($PSCmdlet.ShouldProcess($SchemesToRemove, "Remove MS Terminal color schemes")) {
            $Settings.Schemes = $RemainingSchemes
            ConvertTo-Json $Settings -Depth 10 | Set-Content -Path $SettingsPath
        }
    }
}

function Import-Iterm2ColorScheme {
    param(
        [Parameter(Mandatory=$true)]
        $Path,

        [Parameter(Mandatory=$true)]
        $Name
    )
    function HandleDict {
        param(
            $Dict
        )
        $Hashtable = @{}
        while($Dict.HasChildNodes) {
            $Key = $Dict.RemoveChild($Dict.FirstChild).InnerText
            $Value = HandleValue $Dict.RemoveChild($Dict.FirstChild)
            $Hashtable[$Key] = $Value
        }
        $Hashtable
    }
    function HandleValue {
        param(
            $Value
        )
        switch($Value.Name) {
            "dict" {
                HandleDict $Value
            }
            "real" {
                [float]$Value.InnerText
            }
            default {
                $Value.Value
            }
        }
    }
    function ToRGB {
        param(
            $ColorTable
        )
        [int]$R = $ColorTable["Red Component"] * 255
        [int]$G = $ColorTable["Green Component"] * 255
        [int]$B = $ColorTable["Blue Component"] * 255
        "#{0:X2}{1:X2}{2:X2}" -f $R, $G, $B
    }
    $Xml = New-Object System.Xml.XmlDocument
    $Xml.Load( (Resolve-Path $Path).Path )
    $ItermHT = HandleDict $Xml.DocumentElement.FirstChild
    $Colors = 0..15 | ForEach-Object {
        ToRGB $ItermHT["Ansi $_ Color"]
    }
    $Foreground = ToRGB $ITermHT["Foreground Color"]
    $Background = ToRGB $ITermHT["Background Color"]
    New-MSTerminalColorScheme -Name $Name -Foreground $Foreground -Background $Background -Colors $Colors
}