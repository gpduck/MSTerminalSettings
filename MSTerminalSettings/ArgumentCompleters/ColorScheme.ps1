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
Register-ArgumentCompleter -CommandName "Get-MSTerminalColorScheme" -ParameterName Name -ScriptBlock $ColorSchemeCompleter
