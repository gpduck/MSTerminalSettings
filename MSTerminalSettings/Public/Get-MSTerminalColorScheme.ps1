using namespace WindowsTerminal
using namespace System.Collections.Generic
function Get-MSTerminalColorScheme {
<#
.SYNOPSIS
Retrieves an MS Terminal Color Scheme
#>
    [CmdletBinding()]
    [OutputType([List[SchemeList]])]
    param(
        [Parameter(ValueFromPipeline)][ValidateNotNullOrEmpty()][TerminalSettings]$InputObject = (Get-MSTerminalConfig),
        #Exclude the default color schemes
        [Switch]$ExcludeDefault
    )
    dynamicParam {
        Get-ObjectDynamicParameters 'WindowsTerminal.SchemeList' -ParameterOrder Name
    }
    begin {
        if (-not $ExcludeDefault) {
            if (Get-Command 'get-appxpackage' -erroraction silentlyContinue) {
                $defaultSettingsPath = Join-Path (get-appxpackage 'Microsoft.WindowsTerminal').installLocation 'defaults.json'
            } else {
                #Its not possible to resolve the path to the defaults.json due to WindowsApps being access denied.
                #This should only happen in areas where windowsterminal isn't installed, for instance Appveyor CI
                $defaultSettingsPath = Resolve-Path $moduleroot/src/TerminalSettingsDefaults.json
            }
            if (-not (Test-Path $defaultSettingsPath)) {
                #Don't issue warning for appveyor as this is expected
                if (-not $env:APPVEYOR) {
                    write-warning "Unable to detect default settings file, skipping the include of the default themes"
                }
            } else {
                #Powershell 5.1 doesn't support comments in Json
                #TODO: Remove Replace statement after deprecating 5.1 support
                #FIXME: Replace this with Get-MSTerminalConfig when this is fixed:  https://github.com/microsoft/terminal/issues/5276
                [List[SchemeList]]$ColorScheme = (Import-JsonWithComments $DefaultSettingsPath).schemes
            }
        } else {
            [List[SchemeList]]$ColorScheme = @()
        }
    }
    process {
        foreach ($schemeItem in $InputObject.Schemes) {$ColorScheme.Add($schemeItem)}
        $filters = [HashTable]$PSBoundParameters
        $PSBoundParameters.keys.foreach{
            if ($PSItem -notin [SchemeList].DeclaredProperties.Name) { [void]$filters.Remove($PSItem) }
        }
        foreach ($filterItem in $filters.keys) {
            $ColorScheme = [SchemeList[]]$ColorScheme.where{$PSItem.$FilterItem -like $Filters.$FilterItem}
        }
        return [List[SchemeList]]$ColorScheme
    }
}