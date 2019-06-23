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
        $SettingsPath = Join-Path $Path "profiles.json"
        if(Get-Command ConvertFrom-Json -ParameterName AsHashtable -ErrorAction SilentlyContinue) {
            $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json -AsHashtable
        } else {
            $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json | ConvertPSObjectToHashtable
        }
        $ProfileRemoved = $false
    }
    process {
        if($PSCmdlet.ParametersetName -eq "Name") {
            $InputObject = Get-MSTerminalProfile -name $Name
        }
        if(Get-Command ConvertFrom-Json -ParameterName AsHashtable -ErrorAction SilentlyContinue) {
            $InputObject = ConvertTo-Json $InputObject -Depth 10 | ConvertFrom-Json -AsHashtable | ForEach-Object { $_ }
        } else {
            $InputObject = ConvertPSObjectToHashtable $InputObject
        }

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