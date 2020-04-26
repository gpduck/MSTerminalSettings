#A simple wrapper for 5.1 compatibility with Json that has comments embedded
function Import-JsonWithComments ($Path) {
    if ($PSEdition -eq 'Desktop') {
        Get-Content $Path | Where-Object {$_ -notmatch '//'} | Out-String | ConvertFrom-Json
    } else {
        #More performant method in newer PS versions
        Get-Content -Raw $Path | ConvertFrom-Json
    }
}