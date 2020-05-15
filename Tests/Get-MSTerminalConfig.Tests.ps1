Describe "Get-MSTerminalConfig" {
    BeforeAll {
        . $PSScriptRoot\Shared.ps1
    }
    BeforeEach {
        Copy-Item $Mocks/DefaultSettings.json $TestDrive/settings.json
    }
    It "Reads alwaysShowTabs" {
        $Value = (Get-MSTerminalConfig).alwaysShowTabs
        $Value | Should -Be $true
    }
    It "Reads defaultProfile" {
        $Value = (Get-MSTerminalConfig).defaultProfile
        $Value | Should -Be "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}"
    }
    It "Reads showTabsInTitlebar" {
        $Value = (Get-MSTerminalConfig).showTabsInTitlebar
        $Value | Should -Be $true
    }
    It "Reads initialCols" {
        $Value = (Get-MSTerminalConfig).initialCols
        $Value | Should -Be 120
    }
    It "Reads initialRows" {
        $Value = (Get-MSTerminalConfig).initialRows
        $Value | Should -Be 30
    }
    It "Reads Theme" {
        $Value = (Get-MSTerminalConfig).Theme
        $Value | Should -Be 'System'
    }
    It "Reads showTerminalTitleInTitlebar" {
        $Value = (Get-MSTerminalConfig).showTerminalTitleInTitlebar
        $Value | Should -Be $true
    }
}
