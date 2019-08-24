function Get-MSTerminalProfile {
    [CmdletBinding(DefaultParameterSetName="ByName")]
    param(
        [Parameter(ParameterSetName="ByName",Position=0)]
        $Name,

        [Parameter(Mandatory=$true,ParameterSetName="ByGuid",Position=0)]
        $Guid
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
        $Profile = $_
        switch($PSCmdlet.ParameterSetName) {
            "ByName" {
                if($Name) {
                    $Profile.Name -like $Name
                } else {
                    $true
                }
            }
            "ByGuid" {
                if(!$Guid.StartsWith("{")) {
                    $Guid = "{$Guid"
                }
                if(!$Guid.EndsWith("}")) {
                    $Guid = "$Guid}"
                }
                $Profile.Guid -eq $Guid
            }
        }
    }
}