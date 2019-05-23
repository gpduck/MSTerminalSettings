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