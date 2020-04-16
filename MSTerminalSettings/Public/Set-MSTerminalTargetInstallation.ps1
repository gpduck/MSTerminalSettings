function Set-MSTerminalTargetInstallation {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param(
        [Parameter(Mandatory=$true,ParameterSetName="Builtin")]
        [ValidateSet("Dev","Release","Standalone","Clear")]
        $Type,

        [Parameter(Mandatory=$true,ParameterSetName="Custom")]
        $Path
    )
            #FIXME: Remove When Refactored
            throwuser $QuickTypeNotImplementedException
    $Paths = ResolveWellKnownPaths
    if($PSCmdlet.ParameterSetName -eq "Builtin") {
        Switch ($Type) {
            "Dev" {
                $Script:TERMINAL_FOLDER = Join-Path $Paths.LocalAppData $Script:DEV_PATH
            }
            "Release" {
                $Script:TERMINAL_FOLDER = Join-Path $Paths.LocalAppData $Script:RELEASE_PATH
            }
            "Standalone" {
                $Script:TERMINAL_FOLDER = Join-Path $Paths.AppData $Script:STANDALONE_PATH
            }
            "Clear" {
                $Script:TERMINAL_FOLDER = ""
            }
        }
    } else {
        $Script:TERMINAL_FOLDER = ""
    }
}