using namespace WindowsTerminal
function Remove-MSTerminalColorScheme {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(ValueFromPipelineByPropertyName)][String]$Name,
        [ValidateNotNullOrEmpty()][TerminalSettings]$TerminalSettings = (Get-MSTerminalConfig)
    )
    process {
        $SchemeList = $TerminalSettings.Schemes
        $SchemeToRemove = $SchemeList.Where{[String]$_.Name -eq $Name}
        if (-not $SchemeToRemove) {throw "Could not find Scheme with Name $Name"}
        if ($SchemeToRemove.count -gt 1) {throw "Multiple Schemes found with Name $Name. Please check your configuration and remove the duplicate"}
        if ($PSCmdlet.ShouldProcess(
            $TerminalSettings.Path,
            "Removing Scheme $($SchemeToRemove.Name) $($SchemeToRemove.Name)"
        )) {
            [void]$SchemeList.Remove($SchemeToRemove[0])
            Save-MSTerminalConfig -TerminalConfig $TerminalSettings
        }
    }
}