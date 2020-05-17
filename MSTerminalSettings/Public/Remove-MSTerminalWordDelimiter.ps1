function Remove-MSTerminalWordDelimiter {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "Changed")]
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        $Delimiter
    )
    if ($PSEdition -eq 'Desktop') {throw [NotImplementedException]'Word Delimiter commands do not work on Powershell 5.1 due to a Newtonsoft.Json issue. Please try again in Powershell 7+'}
    $Settings = Get-MSTerminalConfig
    $Changed = $false
    $Delimiter.ToCharArray() | ForEach-Object {
        if($Settings.WordDelimiters -and $Settings.wordDelimiters.Contains($_) -and $PSCmdlet.ShouldProcess("Remove delimiter $_")) {
            $Settings.wordDelimiters = $Settings.WordDelimiters.Replace([String]$_, "")
            $Changed = $true
        }
    }
    if ($Changed) {
        Set-MSTerminalConfig -WordDelimiters $Settings.wordDelimiters
    }
}