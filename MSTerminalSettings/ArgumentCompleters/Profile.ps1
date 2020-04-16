using namespace System.Management.Automation
$ProfileCompleter = {
    param(
        $CommandName,
        $ParameterName,
        $WordToComplete,
        $CommandAst,
        $ParentBoundParameters
    )
    #Override the completion information
    $PSBoundParameters.CommandName = 'Get-MSTerminalProfile'
    $PSBoundParameters.ParameterName = 'Name'
    Get-ArgumentCompleter @PSBoundParameters
}
Register-ArgumentCompleter -CommandName 'Get-MSTerminalProfile','Set-MSTerminalProfile' -ParameterName Name -ScriptBlock $ProfileCompleter
# Register-ArgumentCompleter -CommandName 'Set-MSTermianlProfile'