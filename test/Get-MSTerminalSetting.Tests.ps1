[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $true
. $PSScriptRoot\Shared.ps1

Describe "Get-MSTerminalSetting" {
    New-Item -Path $TestDrive/RoamingState -ItemType Directory

    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }
    BeforeEach {
        Copy-Item $PSScriptRoot/Profiles/MainSettings.json $TestDrive/RoamingState/profiles.json
    }
    It "Reads alwaysShowTabs" {
        $Value = (Get-MSTerminalSetting).alwaysShowTabs
        $Value | Should -Be $true
    }
    It "Reads defaultProfile" {
        $Value = (Get-MSTerminalSetting).defaultProfile
        $Value | Should -Be "42"
    }
    It "Reads showTabsInTitlebar" {
        $Value = (Get-MSTerminalSetting).showTabsInTitlebar
        $Value | Should -Be $true
    }
    It "Reads initialCols" {
        $Value = (Get-MSTerminalSetting).initialCols
        $Value | Should -Be 42
    }
    It "Reads initialRows" {
        $Value = (Get-MSTerminalSetting).initialRows
        $Value | Should -Be 42
    }
    It "Reads requestedTheme" {
        $Value = (Get-MSTerminalSetting).requestedTheme
        $Value | Should -Be "42"
    }
    It "Reads showTerminalTitleInTitlebar" {
        $Value = (Get-MSTerminalSetting).showTerminalTitleInTitlebar
        $Value | Should -Be $true
    }
}
