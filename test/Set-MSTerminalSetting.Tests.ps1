[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $false
. $PSScriptRoot\Shared.ps1

Describe "Set-MSTerminalSetting" {
    New-Item -Path $TestDrive/RoamingState -ItemType Directory

    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }
    BeforeEach {
        Copy-Item $PSScriptRoot/Profiles/MainSettings.json $TestDrive/RoamingState/profiles.json
    }
    It "Reads alwaysShowTabs" {
        Set-MSTerminalSetting -AlwaysShowTabs:$false
        $Settings = Get-Content $TestDrive/RoamingState/profiles.json | ConvertFrom-Json
        $Settings.alwaysShowTabs | Should -Be $false
    }
    It "Reads defaultProfile" {
        Set-MSTerminalSetting -defaultProfile 24
        $Settings = Get-Content $TestDrive/RoamingState/profiles.json | ConvertFrom-Json
        $Settings.defaultProfile | Should -Be 24
    }
    It "Reads showTabsInTitlebar" {
        Set-MSTerminalSetting -showTabsInTitlebar:$false
        $Settings = Get-Content $TestDrive/RoamingState/profiles.json | ConvertFrom-Json
        $Settings.showTabsInTitlebar | Should -Be $false
    }
    It "Reads initialCols" {
        Set-MSTerminalSetting -initialCols 24
        $Settings = Get-Content $TestDrive/RoamingState/profiles.json | ConvertFrom-Json
        $Settings.initialCols | Should -Be 24
    }
    It "Reads initialRows" {
        Set-MSTerminalSetting -initialRows 24
        $Settings = Get-Content $TestDrive/RoamingState/profiles.json | ConvertFrom-Json
        $Settings.initialRows | Should -Be 24
    }
    It "Reads requestedTheme" {
        Set-MSTerminalSetting -requestedTheme dark
        $Settings = Get-Content $TestDrive/RoamingState/profiles.json | ConvertFrom-Json
        $Settings.requestedTheme | Should -Be dark
    }
    It "Reads showTerminalTitleInTitlebar" {
        Set-MSTerminalSetting -showTerminalTitleInTitlebar:$false
        $Settings = Get-Content $TestDrive/RoamingState/profiles.json | ConvertFrom-Json
        $Settings.showTerminalTitleInTitlebar | Should -Be $false
    }
}
