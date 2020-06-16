using namespace WindowsTerminal
using namespace System.Collections.Generic
function Get-MSTerminalColorScheme {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)][ValidateNotNullOrEmpty()][WindowsTerminal.TerminalSettings]$InputObject = (Get-MSTerminalConfig),
        #Exclude the default color schemes
        [Switch]$ExcludeDefault
    )
    dynamicParam {
        Get-ObjectDynamicParameters 'WindowsTerminal.SchemeList' -ParameterOrder Name
    }
    begin {
        if (-not $ExcludeDefault) {
            if (Get-Command 'get-appxpackage' -erroraction silentlyContinue) {
                $appxLocation = (get-appxpackage -erroraction silentlyContinue 'Microsoft.WindowsTerminal').installLocation
                if ($appxLocation) {
                    $defaultSettingsPath = Join-Path $appxLocation 'defaults.json'
                }
            }
            #If we cant get the defaults.json from the current terminal for whatever reason, use the module one
            if (-not $defaultSettingsPath) {
                Write-Debug "Unable to detect Windows Terminal, it may not be installed. Falling back to module-included default settings"
                if (Test-Path $moduleroot/TerminalSettingsDefaults.json) {
                    $defaultSettingsPath = Resolve-Path $moduleroot/TerminalSettingsDefaults.json
                } else {
                    $defaultSettingsPath = Resolve-Path $moduleroot/src/TerminalSettingsDefaults.json
                }
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