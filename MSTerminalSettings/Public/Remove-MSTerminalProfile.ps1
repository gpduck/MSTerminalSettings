using namespace WindowsTerminal
function Remove-MSTerminalProfile {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(ValueFromPipelineByPropertyName)][Guid]$Guid,
        [ValidateNotNullOrEmpty()][TerminalSettings]$TerminalSettings = (Get-MSTerminalConfig)
    )
    process {
        $ProfileList = $TerminalSettings.Profiles.List
        $ProfileToRemove = $ProfileList.Where{[guid]$_.Guid -eq $Guid}
        if (-not $ProfileToRemove) {throw "Could not find profile with guid $Guid"}
        if ($ProfileToRemove.count -gt 1) {throw "Multiple profiles found with guid $Guid. Please check your configuration and remove the duplicate"}
        if ($PSCmdlet.ShouldProcess(
            $TerminalSettings.Path,
            "Removing Profile $($ProfileToRemove.Name) $($ProfileToRemove.Guid)"
        )) {
            [void]$ProfileList.Remove($ProfileToRemove[0])
            Save-MSTerminalConfig -TerminalConfig $TerminalSettings
        }
    }
}