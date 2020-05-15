Describe "Remove-MSTerminalWordDelimiter" {
    BeforeAll {
        . $PSScriptRoot\Shared.ps1
    }

    Context "Default values" {
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
