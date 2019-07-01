function Find-MSTerminalFolder {
    if($PSVersionTable["platform"] -eq "Unix") {
        $SystemDrive = cmd.exe /c "echo %SystemDrive%" 2>> /dev/null
        $MntPath = "/mnt/$($SystemDrive.Trim(":").ToLower())"
        $LocalAppData = cmd.exe /c "echo %LOCALAPPDATA%" 2>> /dev/null
        $LocalAppData = $LocalAppData.Replace("\","/").Replace($SystemDrive, $MntPath)
        $AppData = cmd.exe /c "echo %APPDATA%" 2>> /dev/null
        $AppData = $AppData.Replace("\","/").Replace($SystemDrive, $MntPath)
    } else {
        $LocalAppData = $env:LOCALAPPDATA
        $AppData = $env:APPDATA
    }
    $Paths = @(
        (Join-Path $LocalAppData "packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/RoamingState"),
        (Join-Path $AppData "Microsoft/Windows Terminal"),
        (Join-Path $LocalAppData "packages/WindowsTerminalDev_8wekyb3d8bbwe/RoamingState")
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
