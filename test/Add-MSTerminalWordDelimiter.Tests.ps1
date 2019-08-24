[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $false
. $PSScriptRoot\Shared.ps1

Describe "Add-MSTerminalWordDelimiter" {
    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }

    context "Default values" {
        BeforeEach {
            Copy-Item $PSScriptRoot/Profiles/OneProfile.json $TestDrive/profiles.json
        }

        It "Adds a single delimiter" {
            $ExpectedDelimiters = (Get-MSTerminalSetting).WordDelimiters + "x"
            Add-MSTerminalWordDelimiter -Delimiter "x"
            (Get-MSTerminalSetting).WordDelimiters | Should -Be $ExpectedDelimiters
        }

        It "Adds multiple delimiters" {
            $ExpectedDelimiters = (Get-MSTerminalSetting).WordDelimiters + "abc"
            Add-MSTerminalWordDelimiter -Delimiter "abc"
            (Get-MSTerminalSetting).WordDelimiters | Should -Be $ExpectedDelimiters
        }
    }
}
