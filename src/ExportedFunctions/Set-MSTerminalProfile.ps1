function Set-MSTerminalProfile {
    [CmdletBinding(DefaultParameterSetName="Name",SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true,ParameterSetname="Name")]
        [string]$Name,

        [Parameter(Mandatory=$true,ParameterSetName="InputObject",ValueFromPipeline=$true)]
        $InputObject,

        [string]$CommandLine,

        [switch]$MakeDefault,

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

        [switch]$CloseOnExit,

        [string]$Icon,

        [ValidateCount(4,4)]
        [int[]]$Padding
    )
    begin {
        $Path = Find-MSTerminalFolder
        $SettingsPath = Join-Path $Path "RoamingState/profiles.json"
        $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json -AsHashtable
        $ProfileReplaced = $false
    }
    process {
        if($PSCmdlet.ParametersetName -eq "Name") {
            $InputObject = Get-MSTerminalProfile -name $Name
        }
        $InputObject = ConvertTo-Json $InputObject -Depth 10 | ConvertFrom-Json -AsHashtable | ForEach-Object { $_ }
        Write-Debug "Editing profile $($InputObject['name']) $($InputObject['guid'])"

        $ValueProperties = @(
            "commandline",
            "colorscheme",
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
                $InputObject[$_] = $PSBoundParameters[$_]
            }
        }
        $SwitchProperties = @(
            "useAcrylic",
            "closeOnExit",
            "snapOnInput"
        )
        $SwitchProperties | ForEach-Object {
            if($PSBoundParameters.ContainsKey($_)) {
                $InputObject[$_] = $PSBoundParameters[$_].IsPresent
            }
        }
        if($Padding.Count -gt 0) {
            $InputObject.padding = $padding -Join ", "
        }

        $Settings["profiles"] = @($Settings["profiles"] | ForEach-Object {
            if($_.guid -eq $InputObject['guid']) {
                if($PSCmdlet.ShouldProcess("$($_.name) $($_.guid)", "Replace profile")) {
                    $InputObject
                    $ProfileReplaced = $true
                }
            } else {
                $_
            }
        })
    }
    end {
        if($ProfileReplaced) {
            ConvertTo-Json $Settings -Depth 10 | Set-Content -Path $SettingsPath
        }
    }
}