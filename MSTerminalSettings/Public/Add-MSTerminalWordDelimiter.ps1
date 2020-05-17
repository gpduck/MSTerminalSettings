function Add-MSTerminalWordDelimiter {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        $Delimiter
    )
    if ($PSEdition -eq 'Desktop') {throw [NotImplementedException]'Word Delimiter commands do not work on Powershell 5.1 due to a Newtonsoft.Json issue. Please try again in Powershell 7+'}
    $Settings = Get-MSTerminalConfig
    $Delimiter.ToCharArray() | ForEach-Object {
        if($Settings.wordDelimiters -and !$Settings.wordDelimiters.Contains($_) -and $PSCmdlet.ShouldProcess("Add delimiters $Delimiter")) {
            $Settings.WordDelimiters += $_
            Set-MSTerminalConfig -WordDelimiters $Settings.WordDelimiters
        }
    }
}