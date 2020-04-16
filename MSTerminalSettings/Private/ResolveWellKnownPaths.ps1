function ResolveWellKnownPaths {
    $Paths = [PSCustomObject]@{
        LocalAppData = ""
        AppData = ""
    }
    if($PSVersionTable["platform"] -eq "Unix") {
        $SystemDrive = cmd.exe /c "echo %SystemDrive%" 2>> /dev/null
        $MntPath = "/mnt/$($SystemDrive.Trim(":").ToLower())"
        $LocalAppData = cmd.exe /c "echo %LOCALAPPDATA%" 2>> /dev/null
        $Paths.LocalAppData = $LocalAppData.Replace("\","/").Replace($SystemDrive, $MntPath)
        $AppData = cmd.exe /c "echo %APPDATA%" 2>> /dev/null
        $Paths.AppData = $AppData.Replace("\","/").Replace($SystemDrive, $MntPath)
    } else {
        $Paths.LocalAppData = $env:LOCALAPPDATA
        $Paths.AppData = $env:APPDATA
    }
    $Paths
}