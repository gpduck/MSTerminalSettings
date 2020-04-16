function ConvertFrom-Iterm2ColorScheme {
    [cmdletbinding(DefaultParameterSetName = 'Path')]
    param(
        [parameter(
            Mandatory = $true,
            ParameterSetName  = 'Path',
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]]$Path,

        [parameter(
            Mandatory = $true,
            ParameterSetName = 'LiteralPath',
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('PSPath')]
        [string[]]$LiteralPath,
        [Switch]$AsHashtable
    )
    begin {
        function HandleDict {
            param(
                $Dict
            )
            $Hashtable = @{}
            while($Dict.HasChildNodes) {
                do {
                    $FirstChild = $Dict.RemoveChild($Dict.FirstChild)
                } while($FirstChild.Name -eq "#comment")
                $Key = $FirstChild.InnerText
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
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $ResolvedPaths = Resolve-Path -Path $Path
        } elseif ($PSCmdlet.ParameterSetName -eq 'LiteralPath') {
            $ResolvedPaths = Resolve-Path -LiteralPath $LiteralPath
        }

        $ResolvedPaths | ForEach-Object {
            $Xml = [xml](Get-Content -LiteralPath $_.Path) #New-Object System.Xml.XmlDocument
            #$Xml.Load( $_.Path )
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

            $Colors["foreground"] = ToRGB $ITermHT["Foreground Color"]
            $Colors["background"] = ToRGB $ITermHT["Background Color"]
            if($AsHashtable) {
                $Colors
            } else {
                [PSCustomobject]$Colors
            }
        }
    }
}