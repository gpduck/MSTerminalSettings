function New-MSTerminalColorTable {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param(
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
    @(
        $Black,
        $Red,
        $Green,
        $Yellow,
        $Blue,
        $Purple,
        $Cyan,
        $White,
        $brightBlack,
        $brightRed,
        $brightGreen,
        $brightYellow,
        $brightBlue,
        $brightPurple,
        $BrightCyan,
        $brightWhite
    )
}