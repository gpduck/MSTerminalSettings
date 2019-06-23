function Remove-MSTerminalColorScheme {
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="High")]
    param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [string[]]$Name
    )
    begin {
        $Path = Find-MSTerminalFolder
        $SettingsPath = Join-Path $Path "profiles.json"
        $Settings = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json
        $SchemesToRemove = @()
    }
    process {
        $Name | ForEach-Object {
            $SchemesToRemove += $_
        }
    }
    end {
        $RemainingSchemes = $Settings.Schemes | Where-Object {
            $_.Name -notin $SchemesToRemove
        }
        if($PSCmdlet.ShouldProcess($SchemesToRemove, "Remove MS Terminal color schemes")) {
            $Settings.Schemes = $RemainingSchemes
            ConvertTo-Json $Settings -Depth 10 | Set-Content -Path $SettingsPath
        }
    }
}