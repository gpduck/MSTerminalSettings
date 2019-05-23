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
    $Colors = 0..15 | ForEach-Object {
        ToRGB $ItermHT["Ansi $_ Color"]
    }
    $Foreground = ToRGB $ITermHT["Foreground Color"]
    $Background = ToRGB $ITermHT["Background Color"]
    New-MSTerminalColorScheme -Name $Name -Foreground $Foreground -Background $Background -Colors $Colors
}