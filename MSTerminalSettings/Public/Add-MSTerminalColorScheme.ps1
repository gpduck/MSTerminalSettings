using namespace WindowsTerminal
function Add-MSTerminalColorScheme {
    param(
        [Parameter(ValueFromPipeline)][ValidateNotNullOrEmpty()][TerminalSettings]$TerminalSettings = (Get-MSTerminalConfig)
    )
    DynamicParam {
        Get-ObjectDynamicParameters 'WindowsTerminal.SchemeList' -MandatoryParameters 'Name' -ParameterOrder 'Name'
    }
    process {
        $settings = [HashTable]$PSBoundParameters
        foreach ($settingItem in $PSBoundParameters.keys) {
            #Skip any custom parameters we may have added in the param block
            if ($settingItem -notin [SchemeList].DeclaredProperties.Name) { $settings.remove($settingItem) }
        }

        $newScheme = [SchemeList]$settings
        $TerminalSettings.Schemes.add($newScheme) > $null
        Save-MSTerminalConfig -TerminalConfig $TerminalSettings
    }
}