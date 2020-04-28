using namespace WindowsTerminal
function Get-MSTerminalConfig {
    [CmdletBinding()]
    param (
        #Path to the profile.json settings file you want to work with. Defaults to the default location
        [String]$Path = (Join-Path (Find-MSTerminalFolder) 'settings.json')
    )
    try {
        [String]$jsonContent = if ($Path -match '^http') {
            Invoke-WebRequest -UseBasicParsing -ContentType 'application/json' -Uri $Path
        } else {
            Get-Content -raw $Path
        }
        $terminalSetting = [TerminalSettings]::FromJson(
            (
                $JsonContent
            )
        )

        #Append the path, this won't affect reserialization
        $terminalSetting | Add-Member -NotePropertyName 'Path' -NotePropertyValue $Path -Force
        return $terminalSetting

    } catch [Newtonsoft.Json.JsonSerializationException] {
        if ($PSItem -match "cannot deserialize.+ProfilesObject.+requires a json object") {
            throwuser "Error while parsing $Path`: This module only supports the newer 'Defaults and List' method of defining Windows Terminal profiles. Please edit your profile accordingly. See https://github.com/microsoft/terminal/blob/master/doc/user-docs/UsingJsonSettings.md#default-settings for details. The default profile.json file conforms to this format, so you can delete or move your profile and restart Windows Terminal to have it automatically created."
        } else {
            throw $PSItem
        }
    }
}