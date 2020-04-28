using namespace WindowsTerminal
using namespace System.Collections.Generic
function Set-MSTerminalProfile {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipeline)][Alias('Name','Guid')]$InputObject = (Get-MSTerminalProfile -DefaultSettings),
        #Set the profile as the default profile used for new tabs and on startup
        [Switch]$MakeDefault
    )
    DynamicParam {
        Get-ObjectDynamicParameters 'WindowsTerminal.ProfileList' -Rename @{
            Name = 'NewName'
            Guid = 'NewGuid'
        }
    }
    begin {
        $terminalConfig = @{}
        [int]$profileCount = 0
    }
    process { foreach ($ProfileItem in $InputObject) {
        $profileCount++
        #Resolve the input object
        $ProfileItem = Resolve-MSTerminalProfile $ProfileItem

        if ($makeDefault -and $ProfileItem -is [Profile]) {
            throwUser 'You cannot set the defaultsettings as the default profile'
        }

        $settings = [HashTable]$PSBoundParameters

        #Translate 'New' parameters back to settings parameters
        $PSBoundParameters.keys.where{$PSItem -match '^New(\w+)$'}.foreach{
            $settings.($matches[1]) = $Settings.$PSItem
        }

        if ($settings.NewGuid) {$settings.Guid = $settings.NewGuid}
        if ($settings.NewName) {$settings.Name = $settings.NewName}

        $TerminalConfig[$ProfileItem.TerminalConfig.Path] = $ProfileItem.TerminalConfig
        #Operate on the TerminalConfig-Bound Object because foreach created a clone.
        if ($ProfileItem -is [Profile]) {
            $ProfileItem = $ProfileItem.TerminalConfig.profiles.defaults
        } else {
            $ProfileItem = $ProfileItem.TerminalConfig.profiles.list.where{$PSItem.Guid -eq $ProfileItem.Guid}[0]
        }

        foreach ($settingItem in $settings.keys) {
            #Skip any custom parameters we may have added in the param block
            if ($settingItem -notin [ProfileList].DeclaredProperties.Name) { continue }

            #Better message for the profile defaults
            $ProfileMessageName = if ($ProfileItem -is [WindowsTerminal.Profile]) {'[Default Settings]'} else {$ProfileItem.Name}

            #Prevent a blank space in the message
            $settingMessageValue = if ($null -eq $settings[$settingItem]) {'[null]'} else {$settings[$settingItem]}

            if ($PSCmdlet.ShouldProcess("Profile $ProfileMessageName","Set $settingItem to $settingMessageValue")) {
                $ProfileItem.$settingItem = $settings[$settingItem]
            }
        }
    }}
    end {
        #Sanity Checks
        if ($makeDefault -and $profileCount -gt 1) {
            throwUser 'You cannot specify -MakeDefault with more than one profile'
        }

        $terminalConfig.keys.foreach{
            if ($MakeDefault -and $PSCmdlet.ShouldProcess($ProfileItem.Name, 'Setting as Default Profile')) {
                $terminalConfig[$PSItem].DefaultProfile = $InputObject.Guid
            }
            if ($PSCmdlet.ShouldProcess($PSItem,'Saving Configuration')) {
                Save-MSTerminalConfig $terminalConfig[$PSItem]
            }
        }
    }
}