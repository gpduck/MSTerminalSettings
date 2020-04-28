using namespace WindowsTerminal
function Save-MSTerminalConfig {
    [CmdletBinding(SupportsShouldProcess,DefaultParameterSetName='Path')]
    param (
        [Parameter(Position=0,ValueFromPipeline)][TerminalSettings]$TerminalConfig = (Get-MSTerminalConfig),
        [IO.FileInfo]$Path,
        [Switch]$PassThru
    )

    if ($TerminalConfig -and -not $Path -and -not $TerminalConfig.Path) {throw 'You specified a generated MSTerminalConfig object, and therefore must specify an output path with -Path to use this command'}
    if (-not $Path -and $TerminalConfig.Path) {$Path = $TerminalConfig.Path}
    if ($PSCmdlet.ShouldProcess($TerminalConfig.Path,'Saving Terminal Settings to File')) {
        [Serialize]::ToJson($TerminalConfig) > $Path
        #Slight pause to allow Windows Terminal to catch up
        #TODO: Some sort of event maybe?
        sleep 0.1
    }
    if ($PassThru) {$TerminalConfig}
    #TODO: Parse the error and find where the errors are
}