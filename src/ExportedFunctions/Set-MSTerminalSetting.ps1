function Set-MSTerminalSetting {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [string]$DefaultProfile,

        [ValidateRange(1,[int]::MaxValue)]
        [int]$InitialRows,

        [ValidateRange(1,[int]::MaxValue)]
        [int]$InitialCols,

        [Switch]$AlwaysShowTabs,

        [ValidateSet("light","dark","system")]
        [string]$RequestedTheme,

        [Switch]$ShowTerminalTitleInTitlebar,

        [Switch]$ShowTabsInTitlebar,

        [Hashtable]$ExtraSettings
    )
    $Path = Find-MSTerminalFolder
    $SettingsPath = Join-Path $Path "profiles.json"
    # Don't use -AsHashtable for 5.1 support
    $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json | ConvertPSObjectToHashtable

    if($DefaultProfile) {
        $Settings["globals"]["defaultProfile"] = $DefaultProfile
    }
    if($InitialRows) {
        $Settings["globals"]["initialRows"] = $InitialRows
    }
    if($InitialCols) {
        $Settings["globals"]["initialCols"] = $InitialCols
    }
    if($RequestedTheme) {
        $Settings["globals"]["requestedTheme"] = $RequestedTheme
    }
    if($PSBoundParameters.ContainsKey("AlwaysShowTabs")) {
        $Settings["globals"]["alwaysShowTabs"] = $AlwaysShowTabs.IsPresent
    }
    if($PSBoundParameters.ContainsKey("ShowTerminalTitleInTitlebar")) {
        $Settings["globals"]["showTerminalTitleInTitlebar"] = $ShowTerminalTitleInTitlebar.IsPresent
    }
    if($PSBoundParameters.ContainsKey("ShowTabsInTitlebar")) {
        $Settings["globals"]["showTabsInTitlebar"] = $ShowTabsInTitlebar.IsPresent
    }
    if($PSCmdlet.ShouldProcess("update MS Terminal settings")) {
        ConvertTo-Json $Settings -Depth 10 | Set-Content -Path $SettingsPath
    }
}