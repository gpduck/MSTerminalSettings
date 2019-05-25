$ColorSchemeCompleter = {
    param(
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $ParentBoundParameters
    )
    Get-MSTerminalColorScheme -Name "${wordToComplete}*" | ForEach-Object {
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
Register-ArgumentCompleter -ParameterName Name -CommandName "Get-MSTerminalColorScheme","Remove-MSTerminalColorScheme" -ScriptBlock $ColorSchemeCompleter
Register-ArgumentCompleter -ParameterName ColorScheme -CommandName "New-MSTerminalProfile","Set-MSTerminalProfile" -ScriptBlock $ColorSchemeCompleter