using namespace WindowsTerminal
using namespace System.Collections.Generic
function Disable-MSTerminalProfile {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipeline)][Alias('Name','Guid')]$InputObject = (Get-MSTerminalProfile -DefaultSettings)
    )
    process {
        if ($PSCmdlet.ShouldProcess("$($InputObject.Name) $($InputObject.Guid)","Disable Profile")) {
            $InputObject | Set-MSTerminalProfile -Hidden
        }
    }
}