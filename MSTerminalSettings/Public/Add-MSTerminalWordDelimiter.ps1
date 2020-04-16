function Add-MSTerminalWordDelimiter {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        $Delimiter
    )

    $Settings = Get-MSTerminalConfig
    $Delimiter.ToCharArray() | ForEach-Object {
        if($Settings.wordDelimiters -and !$Settings.wordDelimiters.Contains($_) -and $PSCmdlet.ShouldProcess("Add delimiters $Delimiter")) {
            $Settings.WordDelimiters += $_
            Set-MSTerminalConfig -WordDelimiters $Settings.WordDelimiters
        }
    }
}