function Find-MSTerminalFolder {
    $Paths = @(
        (Join-Path $env:LOCALAPPDATA "packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/RoamingState"),
        (Join-Path $env:APPDATA "Microsoft/Windows Terminal"),
        (Join-Path $env:LOCALAPPDATA "packages/WindowsTerminalDev_8wekyb3d8bbwe/RoamingState")
    )
    foreach($Path in $Paths) {
        if(Test-Path $Path) {
            break
        }
    }
    $Path
}