function Find-MSTerminalFolder {
    if($Script:TERMINAL_FOLDER) {
        $Script:TERMINAL_FOLDER
    } else {
        $WellKnownPaths = ResolveWellKnownPaths
        $Paths = @(
            (Join-Path $WellKnownPaths.LocalAppData $Script:RELEASE_PATH),
            (Join-Path $WellKnownPaths.LocalAppData $Script:RELEASE_PATH_ALT),
            (Join-Path $WellKnownPaths.AppData $Script:STANDALONE_PATH),
            (Join-Path $WellKnownPaths.LocalAppData $Script:DEV_PATH),
            (Join-Path $WellKnownPaths.LocalAppData $Script:DEV_PATH_ALT)
        )
        $FoundPath = $null
        foreach($Path in $Paths) {
            if(Test-Path $Path) {
                $FoundPath = $Path
                break
            }
        }
        if($FoundPath) {
            $FoundPath
        } else {
            Write-Error "Unable to locate Terminal profiles.json file." -ErrorAction Stop
        }
    }
}
