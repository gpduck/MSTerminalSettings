function Set-MSTerminalProfile {
    [CmdletBinding(DefaultParameterSetName="Name",SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true,ParameterSetname="Name")]
        [string]$Name,

        [Parameter(Mandatory=$true,ParameterSetName="InputObject",ValueFromPipeline=$true)]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [string]$CommandLine,

        [switch]$MakeDefault,

        [ValidateRange(-1,32767)]
        [Int]$HistorySize,

        [switch]$SnapOnInput,

        [string]$ColorScheme,

        [ValidateCount(16,16)]
        [string[]]$ColorTable,

        [string]$CursorColor,

        [ValidateSet("bar","emptyBox","filledBox","underscore","vintage")]
        [string]$CursorShape,

        [ValidateRange(25,100)]
        [int]$CursorHeight,

        [string]$FontFace,

        [string]$StartingDirectory,

        [ValidateRange(1,[Int]::MaxValue)]
        [int]$FontSize,

        [string]$Background,

        [string]$Foreground,

        [ValidateRange(0,1)]
        [float]$AcrylicOpacity,

        [switch]$UseAcrylic,

        [String]$BackgroundImage,

        [ValidateSet("center","left","top","right","bottom","topLeft","topRight","bottomLeft","bottomRight")]
        [AllowNull()]
        [string]$BackgroundImageAlignment,

        [ValidateRange(0,1)]
        [double]$BackgroundImageOpacity,

        [ValidateSet("none","fill","uniform","uniformToFill")]
        [AllowNull()]
        [String]$BackgroundImageStretchMode,

        [switch]$Hidden,

        [ValidateSet("visible","hidden")]
        [string]$ScrollbarState,

        [ValidateSet("Windows.Terminal.Azure","Windows.Terminal.PowershellCore","Windows.Terminal.Wsl","")]
        [string]$Source,

        [guid]$NewGuid,

        [string]$TabTitle,

        [switch]$CloseOnExit,

        [string]$Icon,

        [ValidateCount(4,4)]
        [int[]]$Padding,

        [string[]]$Clear,

        [hashtable]$ExtraSettings
    )
    begin {
        $Path = Find-MSTerminalFolder
        $SettingsPath = Join-Path $Path "profiles.json"
        # Don't use -AsHashtable for 5.1 support
        $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json | ConvertPSObjectToHashtable
        if($Settings.Globals) {
            $Global = $Settings["globals"]
        } else {
            $Global = $Settings
        }
        $ProfileReplaced = $false
    }
    process {
        if($PSCmdlet.ParametersetName -eq "Name") {
            $InputObject = Get-MSTerminalProfile -name $Name
        }
        $InputObject = ConvertPSObjectToHashtable $InputObject

        $InputObject | ForEach-Object {
            $TerminalProfile = $_
            Write-Debug "Editing profile $($TerminalProfile['name']) $($TerminalProfile['guid'])"

            $Properties = @(
                "backgroundImage",
                "backgroundImageAlignment",
                "backgroundImageOpacity",
                "backgroundImageStretchMode",
                "closeOnExit",
                "commandline",
                "colorScheme",
                "colorTable",
                "cursorColor",
                "cursorShape",
                "cursorHeight",
                "hidden",
                "historySize",
                "fontFace",
                "fontSize",
                "background",
                "foreground"
                "scrollbarState",
                "tabTitle",
                "acrylicOpacity",
                "snapOnInput",
                "source",
                "startingDirectory",
                "useAcrylic",
                "icon"
            )
            CopyHashtable -Source $PSBoundParameters -Destination $TerminalProfile -Keys $Properties
            if($Padding.Count -gt 0) {
                $TerminalProfile["padding"] = $padding -Join ", "
            }
            if($ExtraSettings.Count -gt 0) {
                CopyHashtable -Source $ExtraSettings -Destination $TerminalProfile
            }

            if($Clear) {
                $Clear | ForEach-Object {
                    $ClearKey = $_
                    $Keys = $TerminalProfile.Keys | ForEach-Object {$_}
                    $Keys | ForEach-Object {
                        if($_ -eq $ClearKey) {
                            $TerminalProfile.Remove($_)
                        }
                    }
                }
            }

            if($MakeDefault -and $PSCmdlet.ShouldProcess($TerminalProfile['name'], "Set default profile")) {
                $Global.defaultProfile = $TerminalProfile['guid']
                [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignment", "ProfileReplaced")]
                $ProfileReplaced = $true
            }

            $OldGuid = $TerminalProfile['guid']
            if($NewGuid) {
                $TerminalProfile['guid'] = "{$NewGuid}"
            }

            $Settings["profiles"] = @($Settings["profiles"] | ForEach-Object {
                if($_.guid -eq $OldGuid) {
                    if($PSCmdlet.ShouldProcess("$($_.name) $($_.guid)", "Replace profile")) {
                        $TerminalProfile
                        Write-Debug (ConvertTo-Json $TerminalProfile)
                        [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignment", "ProfileReplaced")]
                        $ProfileReplaced = $true
                    }
                } else {
                    $_
                }
            })
        }
    }
    end {
        if($ProfileReplaced) {
            ConvertTo-Json $Settings -Depth 10 | Set-Content -Path $SettingsPath
        }
    }
}