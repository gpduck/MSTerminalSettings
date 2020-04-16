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
        [List[TerminalSettings]]$terminalConfig = @()
        [int]$profileCount = 0
    }
    process {
        $profilecount++
        #Resolve the input object
        switch ($true) {
            ($InputObject -is [Profile]) {break}
            ($InputObject -is [ProfileList]) {break}
            ($null -ne ($InputObject -as [Guid])) {$InputObject=Get-MSTerminalProfile -Guid $InputObject;break}
            ($null -ne ($InputObject -as [String])) {$InputObject=Get-MSTerminalProfile -Name $InputObject;break}
        }
        #If no profile was specified, operate on the "defaults" profile
        if (-not $InputObject) { $InputObject = Get-MSTerminalProfile -Default }
        if ($makeDefault -and $InputObject -is [Profile]) {
            throwUser 'You cannot set the defaultsettings as the default profile'
        }

        foreach ($ProfileItem in $InputObject) {
            $settings = [HashTable]$PSBoundParameters

            #Translate 'New' parameters back to settings parameters
            $PSBoundParameters.keys.where{$PSItem -match '^New(\w+)$'}.foreach{
                $settings.($matches[1]) = $Settings.$PSItem
            }

            if ($settings.NewGuid) {$settings.Guid = $settings.NewGuid}
            if ($settings.NewName) {$settings.Name = $settings.NewName}

            foreach ($settingItem in $settings.keys) {
                #Skip any custom parameters we may have added in the param block
                if ($settingItem -notin [ProfileList].DeclaredProperties.Name) { continue }

                #Better message for the profile defaults
                $ProfileMessageName = if ($InputObject -is [WindowsTerminal.Profile]) {'[Default Settings]'} else {$ProfileItem.Name}

                #Prevent a blank space in the message
                $settingMessageValue = if ($null -eq $settings[$settingItem]) {'[null]'} else {$settings[$settingItem]}

                if ($PSCmdlet.ShouldProcess("Profile $ProfileMessageName","Set $settingItem to $settingMessageValue")) {
                    $ProfileItem.$settingItem = $settings[$settingItem]
                }
            }
            $TerminalConfig.Add($InputObject.TerminalConfig)
        }
    }
    end {
        $terminalConfig = $terminalConfig | Sort-Object path -unique

        #Sanity Checks
        if ($terminalConfig.count -gt 1) {
            throwUser 'You cannot operate on multiple windows terminal configurations at the same time'
        }
        if ($makeDefault -and $profileCount -gt 1) {
            throwUser 'You cannot specify -MakeDefault with more than one profile'
        }
        if ($MakeDefault -and $PSCmdlet.ShouldProcess($ProfileItem.Name, 'Setting as Default Profile')) {
            $terminalConfig[0].DefaultProfile = $InputObject.Guid
        }

        if ($PSCmdlet.ShouldProcess($terminalConfig.path,'Saving Configuration')) {
            $terminalConfig | Foreach-Object {
                Save-MSTerminalConfig $PSItem
            }
        }
    }
}