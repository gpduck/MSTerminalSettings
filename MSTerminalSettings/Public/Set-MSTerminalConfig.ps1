using namespace WindowsTerminal
function Set-MSTerminalConfig {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position=0,ValueFromPipeline)][ValidateNotNullOrEmpty()][WindowsTerminal.TerminalSettings]$TerminalConfig = (Get-MSTerminalConfig)
    )
    DynamicParam {
        $dynamicParams = Get-ObjectDynamicParameters 'WindowsTerminal.TerminalSettings'
        Add-TerminalSettingsParams $dynamicParams 'WindowsTerminal.TerminalSettings'
        $dynamicParams
    }
    process {
        $settings = [HashTable]$PSBoundParameters
        foreach ($settingItem in $PSBoundParameters.keys) {
            #Skip any custom parameters we may have added in the param block
            if ($settingItem -notin [TerminalSettings].DeclaredProperties.Name) { continue }

            if ($PSCmdlet.ShouldProcess($TerminalConfig.Path,"Setting $settingItem to $($settings[$settingItem])")) {
                $TerminalConfig.$settingItem = $settings[$SettingItem]
            }
        }
    }
    end {
        if ($PSCmdlet.ShouldProcess($TerminalConfig.Path,"Saving Configuration")) {
            Save-MSTerminalConfig -TerminalConfig $TerminalConfig
        }
    }
}