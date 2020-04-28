using namespace System.Management.Automation
$ColorSchemeCompleter = {
    param(
        $CommandName,
        $ParameterName,
        $WordToComplete,
        $CommandAst,
        $ParentBoundParameters
    )
    #Override the completion information
    $PSBoundParameters.CommandName = 'Get-MSTerminalColorScheme'
    $PSBoundParameters.ParameterName = 'Name'
    Get-ArgumentCompleter @PSBoundParameters
}
Register-ArgumentCompleter -CommandName "Get-MSTerminalColorScheme","Add-MSTerminalColorScheme","Remove-MSTerminalColorScheme" -ParameterName Name -ScriptBlock $ColorSchemeCompleter
Register-ArgumentCompleter -CommandName "Set-MSTerminalProfile","Add-MSTerminalProfile" -ParameterName ColorScheme -ScriptBlock $ColorSchemeCompleter
