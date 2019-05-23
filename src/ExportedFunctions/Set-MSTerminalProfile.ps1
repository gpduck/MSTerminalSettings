function Set-MSTerminalProfile {
    [CmdletBinding(DefaultParameterSetName="Name",SupportsShouldProcess=$true)]
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

        [ValidateCount(4,4)]
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

        if($PSCmdlet.ShouldProcess($InputObject.Name, "Update MS Terminal profile")) {
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
}