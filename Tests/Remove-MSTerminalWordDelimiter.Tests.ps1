. $PSScriptRoot\Shared.ps1

Describe "Remove-MSTerminalWordDelimiter" {
    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }

    context "Default values" {
        BeforeEach {
            Copy-Item $Mocks/CustomSettings.json $TestDrive/settings.json
        }

        It "Removes a single delimiter" {
            $ExpectedDelimiters = (Get-MSTerminalConfig).WordDelimiters.Replace("?", "")
            Remove-MSTerminalWordDelimiter -Delimiter "?"
            (Get-MSTerminalConfig).WordDelimiters | Should -Be $ExpectedDelimiters
        }

        It "Removes multiple delimiters" {
            $ExpectedDelimiters = (Get-MSTerminalConfig).WordDelimiters.Replace("?","").Replace("*","").Replace("+", "")
            Remove-MSTerminalWordDelimiter -Delimiter "?*+"
            (Get-MSTerminalConfig).WordDelimiters | Should -Be $ExpectedDelimiters
        }
    }
}
