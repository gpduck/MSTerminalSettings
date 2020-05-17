using namespace WindowsTerminal
function Add-MSTerminalColorScheme {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(ValueFromPipeline)][ValidateNotNullOrEmpty()][WindowsTerminal.TerminalSettings]$TerminalSettings = (Get-MSTerminalConfig),
        [Switch]$Force
    )
    DynamicParam {
        $dynamicParams = Get-ObjectDynamicParameters 'WindowsTerminal.SchemeList' -MandatoryParameters 'Name' -ParameterOrder 'Name'
        $dynamicParams | Add-TerminalSettingsParams
        $dynamicParams
    }
    process {
        $settings = [HashTable]$PSBoundParameters
        foreach ($settingItem in $PSBoundParameters.keys) {
            #Skip any custom parameters we may have added in the param block
            if ($settingItem -notin [SchemeList].DeclaredProperties.Name) { $settings.remove($settingItem) }
        }

        $newScheme = [SchemeList]$settings
        if ($PSCmdlet.ShouldProcess($TerminalSettings.Path, "Adding Color Scheme $nameToCompare")) {
            $nameToCompare = $newScheme.Name
            $ExistingSchema = $TerminalSettings.Schemes | Where-Object Name -eq $nameToCompare
            if ($ExistingSchema) {
                if (-not $Force) {
                    throwUser "$nameToCompare already exists as a color scheme, please specify -Force to overwrite."
                }
                [Void]$TerminalSettings.Schemes.Remove($ExistingSchema)
            }
            $TerminalSettings.Schemes.Add($newScheme) > $null
            Save-MSTerminalConfig -TerminalConfig $TerminalSettings
        }
    }
}