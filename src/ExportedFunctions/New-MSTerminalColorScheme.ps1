function New-MSTerminalColorScheme {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name,

        [string]$Foreground = "#F2F2F2",

        [string]$Background = "#0C0C0C",

        [string]$black = "#0C0C0C",

        [string]$blue = "#0037DA",

        [string]$brightBlack = "#767676",

        [string]$brightBlue = "#3B78FF",

        [string]$brightCyan = "#61D6D6",

        [string]$brightGreen = "#16C60C",

        [string]$brightPurple = "#B4009E",

        [string]$brightRed = "#E74856",

        [string]$brightWhite = "#F2F2F2",

        [string]$brightYellow = "#F9F1A5",

        [string]$cyan = "#3A96DD",

        [string]$green = "#13A10E",

        [string]$purple = "#881798",

        [string]$red = "#C50F1F",

        [string]$white = "#CCCCCC",

        [string]$yellow = "#C19C00"
    )
    $SettingsPath = DetectTerminalConfigFile
    $Settings = ReadMSTerminalProfileJson $SettingsPath | ConvertPSObjectToHashtable

    if(!$Settings.Contains("schemes")) {
        $Settings["schemes"] = @()
    }
    foreach($s in $Settings["schemes"]) {
        if($s["name"] -eq $Name) {
            Write-Error "Color scheme $Name already exists" -ErrorAction Stop
            return
        }
    }
    if($PSCmdlet.ShouldProcess($Name, "Add MS Terminal color scheme")) {
        $Settings["schemes"] += [PSCustomObject] @{
            background = $background
            black = $black
            blue = $blue
            brightBlack = $brightBlack
            brightBlue = $brightBlue
            brightCyan = $brightCyan
            brightGreen = $brightGreen
            brightPurple = $brightPurple
            brightRed = $brightRed
            brightWhite = $brightWhite
            brightYellow = $brightYellow
            cyan = $cyan
            foreground = $foreground
            green = $green
            name = $name
            purple = $purple
            red = $red
            white = $white
            yellow = $yellow
        }
        ConvertTo-Json $Settings -Depth 10 | Set-Content -Path $SettingsPath
    }
}