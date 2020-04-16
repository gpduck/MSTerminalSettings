function Update-WTQuickType {
    param (
        $Path = 'https://aka.ms/terminal-profiles-schema',
        $JsonOutPath = "$PSSCRIPTROOT\..\src\TerminalSettingsSchema.json",
        $Destination = "$PSSCRIPTROOT\..\src\TerminalSettings.cs"
    )

    if (-not (Get-Command 'quicktype' -ErrorAction SilentlyContinue)) {
        throw 'This command requires quicktype. Install NodeJS and run npm install quicktype -g'
    }

    #Fix a bug where oneOf goes the wrong way
    $jsonContent = [String](iwr -useb $Path) | ConvertFrom-Json -AsHashtable

    $profileKey = $jsoncontent['allOf'].properties.profiles['oneOf']
    $jsonContent['allOf'].properties.profiles['oneOf'] = @($profileKey | Where-Object '$ref' -match 'ProfilesObject')
    $jsonContent | ConvertTo-Json -Depth 10 | Out-File -FilePath $jsonOutPath

    & quicktype -s schema --namespace WindowsTerminal --number-type decimal --density normal --array-type list -o $Destination $jsonOutPath

    #Inject some cleaner formatting options
    $settingsRegex = [regex]::new('(public static readonly JsonSerializerSettings Settings .+?{)','SingleLine')
    $formattingCode = @'

            Formatting = Formatting.Indented,
            NullValueHandling = NullValueHandling.Ignore,
'@

    $settingsRegex.Replace((Get-Content -raw $Destination), "`$1$formattingCode") | Out-File $Destination
}