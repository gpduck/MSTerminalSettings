function ReadMSTerminalProfileJson ([String]$Path) {

    $ProfilePath = Get-Item $Path -ErrorAction Stop
    $JSonCommentsRegex = '(?<!".+)//.+(?!.+")'
    $ProfilesJsonContent = Get-Content -Path $ProfilesPath -Raw
    #Powershell 5 ConvertFrom-Json can't handle single-line comments and they must be stripped
    if ($PSEdition -eq 'Desktop') {
        #Match lines with // that aren't surrounded by quotes
        $StripJsonCommentsRegex = '(?<!".+)//.+(?!.+")'
        #Match lines with //
        $ProfilesJsonContent = $ProfilesJsonContent -replace $StripJsonCommentsRegex
    }
    $ProfilesJsonContent | ConvertFrom-Json
}