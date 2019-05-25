$ProfileCompleter = {
    param(
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $ParentBoundParameters
    )
    Get-MSTerminalProfile -Name "${wordToComplete}*" | ForEach-Object {
        $Value = $_.Name
        if($Value.Contains(" ")) {
            $Value = "`"$Value`""
        }
        New-Object System.Management.Automation.CompletionResult (
            $Value,
            $Value,
            'ParameterValue',
            $Value
        )
    }
}
Register-ArgumentCompleter -ParameterName Name -CommandName "Get-MSTerminalProfile","Remove-MSTerminalProfile","Set-MSTerminalProfile" -ScriptBlock $ProfileCompleter