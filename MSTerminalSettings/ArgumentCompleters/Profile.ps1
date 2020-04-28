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
Register-ArgumentCompleter -CommandName 'Get-MSTerminalProfile','Add-MSTerminalProfile' -ParameterName Name -ScriptBlock $ProfileCompleter
Register-ArgumentCompleter -CommandName 'Set-MSTerminalProfile','Remove-MSTerminalProfile' -ParameterName InputObject -ScriptBlock $ProfileCompleter