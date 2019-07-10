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

        [ValidateRange(0,1)]
        [double]$BackgroundImageOpacity,

        [ValidateSet("none","fill","uniform","uniformToFill")]
        [AllowNull()]
        [String]$BackgroundImageStretchMode,

        [ValidateSet("visible","hidden")]
        [string]$ScrollbarState,

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

            $ValueProperties = @(
                "backgroundImage",
                "backgroundImageOpacity",
                "backgroundImageStretchMode",
                "commandline",
                "colorScheme",
                "colorTable",
                "cursorColor",
                "cursorShape",
                "cursorHeight",
                "historySize",
                "fontFace",
                "fontSize",
                "background",
                "foreground"
                "scrollbarState",
                "tabTitle",
                "acrylicOpacity",
                "startingDirectory",
                "icon"
            )
            $ValueProperties | ForEach-Object {
                if($PSBoundParameters.ContainsKey($_)) {
                    $Key = $_
                    $NewValue = $PSBoundParameters[$_]
                    switch($NewValue.Gettype().Fullname) {
                        "System.String" {
                            if([String]::IsNullOrEmpty($NewValue)) {
                                $Keys = $TerminalProfile.Keys | ForEach-Object {$_}
                                $Keys | ForEach-Object {
                                    if($_ -eq $Key) {
                                        $TerminalProfile.Remove($_)
                                    }
                                }
                                #$TerminalProfile.Remove($Key)
                            } else {
                                $TerminalProfile[$Key] = $NewValue
                            }
                        }
                        default {
                            $TerminalProfile[$Key] = $NewValue
                        }
                    }
                }
            }
            $SwitchProperties = @(
                "useAcrylic",
                "closeOnExit",
                "snapOnInput"
            )
            $SwitchProperties | ForEach-Object {
                if($PSBoundParameters.ContainsKey($_)) {
                    $TerminalProfile[$_] = $PSBoundParameters[$_].IsPresent
                }
            }
            if($Padding.Count -gt 0) {
                $TerminalProfile["padding"] = $padding -Join ", "
            }

            $ExtraSettings.keys.foreach{
                $TerminalProfile["$_"] = $ExtraSettings["$_"]
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

            $Settings["profiles"] = @($Settings["profiles"] | ForEach-Object {
                if($_.guid -eq $TerminalProfile['guid']) {
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