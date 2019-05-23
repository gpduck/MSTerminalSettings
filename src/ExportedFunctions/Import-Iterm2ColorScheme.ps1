function Import-Iterm2ColorScheme {
    param(
        [Parameter(Mandatory=$true)]
        $Path,

        [Parameter(Mandatory=$true)]
        $Name
    )
    function HandleDict {
        param(
            $Dict
        )
        $Hashtable = @{}
        while($Dict.HasChildNodes) {
            $Key = $Dict.RemoveChild($Dict.FirstChild).InnerText
            $Value = HandleValue $Dict.RemoveChild($Dict.FirstChild)
            $Hashtable[$Key] = $Value
        }
        $Hashtable
    }
    function HandleValue {
        param(
            $Value
        )
        switch($Value.Name) {
            "dict" {
                HandleDict $Value
            }
            "real" {
                [float]$Value.InnerText
            }
            default {
                $Value.Value
            }
        }
    }
    function ToRGB {
        param(
            $ColorTable
        )
        [int]$R = $ColorTable["Red Component"] * 255
        [int]$G = $ColorTable["Green Component"] * 255
        [int]$B = $ColorTable["Blue Component"] * 255
        "#{0:X2}{1:X2}{2:X2}" -f $R, $G, $B
    }
    $Xml = New-Object System.Xml.XmlDocument
    $Xml.Load( (Resolve-Path $Path).Path )
    $ItermHT = HandleDict $Xml.DocumentElement.FirstChild
    $AnsiColorMap = @{
        0 = "black"
        1 = "red"
        2 = "green"
        3 = "yellow"
        4 = "blue"
        5 = "purple"
        6 = "cyan"
        7 = "white"
        8 = "brightBlack"
        9 = "brightRed"
        10 = "brightGreen"
        11 = "brightYellow"
        12 = "brightBlue"
        13 = "brightPurple"
        14 = "brightCyan"
        15 = "brightWhite"
    }
    $Colors = @{}
    $AnsiColorMap.Keys | ForEach-Object {
        $ColorName = $AnsiColorMap[$_]
        $Colors[$ColorName] = ToRGB $ItermHT["Ansi $_ Color"]
    }

    $Foreground = ToRGB $ITermHT["Foreground Color"]
    $Background = ToRGB $ITermHT["Background Color"]
    New-MSTerminalColorScheme -Name $Name -Foreground $Foreground -Background $Background @Colors
}