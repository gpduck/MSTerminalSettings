function Get-ArgumentCompleter {
    param(
        $CommandName,
        $ParameterName,
        $WordToComplete,
        $CommandAst,
        $ParentBoundParameters
    )

    $params = @{}
    if ($WordToComplete) {$params.$ParameterName = "${WordToComplete}*"}
    (. $CommandName @params).$ParameterName.foreach{
        if ($PSItem -match ' ') {
            "'$PSItem'"
        } else {$PSItem}
    }
}