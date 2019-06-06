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

        [ValidateRange(0,1)]
        [float]$AcrylicOpacity,

        [switch]$UseAcrylic,

        [String]$BackgroundImage,

        [ValidateRange(0,1)]
        [double]$BackgroundImageOpacity,

        [ValidateSet("none","fill","uniform","uniformToFill")]
        [AllowNull()]
        [String]$BackgroundImageStretchMode,

        [switch]$CloseOnExit,

        [string]$Icon,

        [ValidateCount(4,4)]
        [int[]]$Padding,

        [string[]]$Clear
    )
    begin {
        $Path = Find-MSTerminalFolder
        $SettingsPath = Join-Path $Path "RoamingState/profiles.json"
        if(Get-Command ConvertFrom-Json -ParameterName AsHashtable -ErrorAction SilentlyContinue) {
            $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json -AsHashtable
        } else {
            $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json | ConvertPSObjectToHashtable
        }
        $ProfileReplaced = $false
    }
    process {
        if($PSCmdlet.ParametersetName -eq "Name") {
            $InputObject = Get-MSTerminalProfile -name $Name
        }
        if(Get-Command ConvertFrom-Json -ParameterName AsHashtable -ErrorAction SilentlyContinue) {
            $InputObject = ConvertTo-Json $InputObject -Depth 10 | ConvertFrom-Json -AsHashtable | ForEach-Object { $_ }
        } else {
            $InputObject = ConvertPSObjectToHashtable $InputObject
        }

        $InputObject | ForEach-Object {
            $TerminalProfile = $_
            Write-Debug "Editing profile $($TerminalProfile['name']) $($TerminalProfile['guid'])"

            $ValueProperties = @(
                "backgroundImage",
                "backgroundImageOpacity",
                "backgroundImageStretchMode",
                "commandline",
                "colorScheme",
                "cursorColor",
                "cursorShape",
                "cursorHeight",
                "historySize",
                "fontFace",
                "fontSize",
                "background",
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
                                $TerminalProfile.Remove($Key)
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

            if($Clear) {
                $Clear | ForEach-Object {
                    $TerminalProfile.Remove($_)
                }
            }

            $Settings["profiles"] = @($Settings["profiles"] | ForEach-Object {
                if($_.guid -eq $TerminalProfile['guid']) {
                    if($PSCmdlet.ShouldProcess("$($_.name) $($_.guid)", "Replace profile")) {
                        $TerminalProfile
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