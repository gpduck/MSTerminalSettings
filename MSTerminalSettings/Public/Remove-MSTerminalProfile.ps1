using namespace WindowsTerminal
function Remove-MSTerminalProfile {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][Alias('Name','Guid')]$InputObject
    )
    process {
        $ProfileToRemove = Resolve-MSTerminalProfile $InputObject

        if (-not $ProfileToRemove) {throw "Could not find matching profile to remove"}
        $TerminalConfig = $ProfileToRemove.TerminalConfig
        if ($PSCmdlet.ShouldProcess(
            $TerminalConfig.Path,
            "Removing Profile $($ProfileToRemove.Name) $($ProfileToRemove.Guid)"
        )) {
            [void]$TerminalConfig.Profiles.List.Remove($ProfileToRemove[0])
            Save-MSTerminalConfig -TerminalConfig $TerminalConfig
        }
    }
}