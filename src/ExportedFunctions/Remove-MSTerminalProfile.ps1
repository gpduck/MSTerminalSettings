function Remove-MSTerminalProfile {
     [CmdletBinding(DefaultParameterSetName="Name",SupportsShouldProcess=$true,ConfirmImpact="High")]
    param(
        [Parameter(Mandatory=$true,ParameterSetname="Name")]
        [string]$Name,

        [Parameter(Mandatory=$true,ParameterSetName="InputObject",ValueFromPipeline=$true)]
        $InputObject
    )
    begin {
        $SettingsPath = DetectTerminalConfigFile
        $Settings = ReadMSTerminalProfileJson $SettingsPath
        $ProfilesToRemove = @()
    }
    process {
        if($PSCmdlet.ParametersetName -eq "Name") {
            $InputObject = Get-MSTerminalProfile -name $Name
        }

        $InputObject | ForEach-Object {
            $TerminalProfile = $_
            $Settings.profiles | ForEach-Object {
                if($_.guid -eq $TerminalProfile.guid) {
                    $ProfilesToRemove += $_
                }
            }
        }
    }
    end {
        if($ProfilesToRemove.Count -gt 0 -and $PSCmdlet.ShouldProcess($ProfilesToRemove.Name, "Remove MS Terminal profiles")) {
            $RemoveGuids = @($ProfilesToRemove.Guid)
            $RemainingProfiles = @($Settings.Profiles | Where-Object {
                $_.Guid -notin $RemoveGuids
            })
            $Settings.Profiles = $RemainingProfiles
            ConvertTo-Json $Settings -Depth 10 | Set-Content -Path $SettingsPath
        }
    }
}