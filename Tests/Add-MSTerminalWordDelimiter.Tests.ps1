Describe "Add-MSTerminalWordDelimiter" -Skip:$($PSEdition -eq 'Desktop') {
    BeforeAll {
        . $PSScriptRoot/Shared.ps1
    }

    context "Default values" {
        BeforeEach {
            Copy-Item $MSTerminalDefaultSettingsPath $TestDrive/settings.json
        }

        It "Adds a single delimiter" {
            $ExpectedDelimiters = (Get-MSTerminalConfig).WordDelimiters + "x"
            Add-MSTerminalWordDelimiter -Delimiter "x"
            (Get-MSTerminalConfig).WordDelimiters | Should -Be $ExpectedDelimiters
        }

        It "Adds multiple delimiters" {
            $ExpectedDelimiters = (Get-MSTerminalConfig).WordDelimiters + "abc"
            Add-MSTerminalWordDelimiter -Delimiter "abc"
            (Get-MSTerminalConfig).WordDelimiters | Should -Be $ExpectedDelimiters
        }
    }
}
