function Remove-MSTerminalProfile {
     [CmdletBinding(DefaultParameterSetName="Name",SupportsShouldProcess=$true,ConfirmImpact="High")]
    param(
        [Parameter(Mandatory=$true,ParameterSetname="Name")]
        [string]$Name,

        [Parameter(Mandatory=$true,ParameterSetName="InputObject",ValueFromPipeline=$true)]
        $InputObject
    )
    begin {
        $Path = Find-MSTerminalFolder
        $SettingsPath = Join-Path $Path "RoamingState/profiles.json"
        $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json -AsHashtable
        $ProfileRemoved = $false
    }
    process {
        if($PSCmdlet.ParametersetName -eq "Name") {
            $InputObject = Get-MSTerminalProfile -name $Name
        }
        $InputObject = ConvertTo-Json $InputObject -Depth 10 | ConvertFrom-Json -AsHashtable | ForEach-Object { $_ }

        $InputObject | ForEach-Object {
            $TerminalProfile = $_
            $Settings["profiles"] = @($Settings["profiles"] | ForEach-Object {
                if($_.guid -eq $TerminalProfile['guid'] -and $PSCmdlet.ShouldProcess("$($_.name) $($_.guid)", "Remove profile")) {
                    Write-Debug "Removing profile $($TerminalProfile['name']) $($TerminalProfile['guid'])"
                    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignment", "ProfileRemoved")]
                    $ProfileRemoved = $true
                } else {
                    $_
                }
            })
        }
    }
    end {
        if($ProfileRemoved) {
            ConvertTo-Json $Settings -Depth 10 | Set-Content -Path $SettingsPath
        }
    }
}