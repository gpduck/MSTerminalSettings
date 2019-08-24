function Remove-MSTerminalWordDelimiter {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "Changed")]
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        $Delimiter
    )
    $Settings = Get-MSTerminalSetting
    $Changed = $false
    $Delimiter.ToCharArray() | ForEach-Object {
        if($Settings.WordDelimiters -and $Settings.wordDelimiters.Contains($_) -and $PSCmdlet.ShouldProcess("Remove delimiter $_")) {
            $Settings.wordDelimiters = $Settings.WordDelimiters.Replace([String]$_, "")
            $Changed = $true
        }
    }
    if($Changed) {
        Set-MSTerminalSetting -WordDelimiters $Settings.wordDelimiters
    }
}