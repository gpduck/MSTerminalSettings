using namespace WindowsTerminal
function Add-MSTerminalProfile {
    param(
        [Parameter(ValueFromPipeline)][ValidateNotNullOrEmpty()][WindowsTerminal.TerminalSettings]$InputObject = (Get-MSTerminalConfig),
        [Switch]$MakeDefault,
        [Switch]$Force
    )
    DynamicParam {
        $dynamicParams = Get-ObjectDynamicParameters 'WindowsTerminal.ProfileList' -MandatoryParameters 'Name' -ParameterOrder 'Name'
        Add-TerminalSettingsParams $dynamicParams 'WindowsTerminal.ProfileList'
        $dynamicParams
    }
    process {
        $settings = [HashTable]$PSBoundParameters
        foreach ($settingItem in $PSBoundParameters.keys) {
            #Skip any custom parameters we may have added in the param block
            if ($settingItem -notin [ProfileList].DeclaredProperties.Name) { [void]$settings.remove($settingItem) }
        }

        $newprofile = [ProfileList]$settings

        if (-not $newprofile.Guid) {
            #Generate a Guid if one wasn't specified
            $newprofile.Guid = [Guid]::newGuid().tostring('B')
        } else {
            $existingProfile = $InputObject.profiles.list | Where-Object guid -eq $newProfile.guid
        }

        if ($existingProfile -and -not $force) {
            throw "A profile with guid $($newProfile.Guid) already exists. If you wish to overwrite it please add the -Force parameter"
        }

        if ($existingProfile) {
            [void]$InputObject.Profiles.list.Remove($existingProfile)
        }

        $InputObject.Profiles.list.Add($NewProfile) > $null

        Save-MSTerminalConfig -TerminalConfig $InputObject

        if ($MakeDefault) {
            Set-MSTerminalConfig $InputObject -DefaultProfile $NewProfile.Guid
        }
    }
}