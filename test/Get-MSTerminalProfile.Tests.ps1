[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $false
. $PSScriptRoot\Shared.ps1

Describe "Get-MSTerminalProfile" {
    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }

    context "Single Profile" {
        BeforeEach {
            Copy-Item $PSScriptRoot/Profiles/OneProfile.json $TestDrive/profiles.json
        }

        @(
            @("name", "pester"),
            @("guid", "{pester-guid}"),
            @("useAcrylic", $false),
            @("fontFace", "pester-font-face"),
            @("cursorColor", "#pester"),
            @("padding", "42, 42, 42, 42"),
            @("commandLine", "pester.exe"),
            @("icon", "ms-appx:///ProfileIcons/pester.png"),
            @("background", "#pester"),
            @("fontSize", 42),
            @("closeOnExit", $true),
            @("snapOnInput", $true),
            @("colorScheme", "pester"),
            @("historySize", 42),
            @("acrylicOpacity", 0.42),
            @("cursorShape", "pester"),
            @("startingDirectory", "pester")
        ) | ForEach-Object {
            $Name = $_[0]
            $ExpectedValue = $_[1]
            It "Reads $Name" {
                $Value = (Get-MSTerminalprofile)."$Name"
                $Value | Should -Be $ExpectedValue
            }
        }
    }
}
