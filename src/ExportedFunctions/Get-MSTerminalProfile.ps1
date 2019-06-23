function Get-MSTerminalProfile {
    param(
        $Name
    )

    $Path = Find-MSTerminalFolder
    if(!$Path) {
        Write-Error "Cannot locate MS Terminal package" -ErrorAction Stop
        return
    }

    $ProfilesJson = Join-Path $Path "profiles.json"
    Get-Content -Path $ProfilesJson -Raw | ConvertFrom-Json | ForEach-Object {
        $_.Profiles
    } | Where-Object {
        if($Name) {
            $_.Name -like $Name
        } else {
            $true
        }
    }
}