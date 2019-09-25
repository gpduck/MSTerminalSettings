[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $false
. $PSScriptRoot\Shared.ps1

Describe "Set-MSTerminalSetting" {
    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }
    BeforeEach {
        Copy-Item $PSScriptRoot/Profiles/MainSettings.json $TestDrive/profiles.json
    }
    It "Sets alwaysShowTabs" {
        Set-MSTerminalSetting -AlwaysShowTabs:$false
        $Settings = (Get-Content $TestDrive/profiles.json | ConvertFrom-Json).Globals
        $Settings.alwaysShowTabs | Should -Be $false
    }
    It "Sets defaultProfile" {
        Set-MSTerminalSetting -defaultProfile 24
        $Settings = (Get-Content $TestDrive/profiles.json | ConvertFrom-Json).Globals
        $Settings.defaultProfile | Should -Be 24
    }
    It "Sets disabledProfileSources" {
        Set-MSTerminalSetting -disabledProfileSources @("Windows.Terminal.Azure")
        $Settings = (Get-Content $TestDrive/profiles.json | ConvertFrom-Json).Globals
        $Settings.disabledProfileSources -contains "Windows.Terminal.Azure" | Should -Be $true
    }
    It "Sets showTabsInTitlebar" {
        Set-MSTerminalSetting -showTabsInTitlebar:$false
        $Settings = (Get-Content $TestDrive/profiles.json | ConvertFrom-Json).Globals
        $Settings.showTabsInTitlebar | Should -Be $false
    }
    It "Sets initialCols" {
        Set-MSTerminalSetting -initialCols 24
        $Settings = (Get-Content $TestDrive/profiles.json | ConvertFrom-Json).Globals
        $Settings.initialCols | Should -Be 24
    }
    It "Sets initialRows" {
        Set-MSTerminalSetting -initialRows 24
        $Settings = (Get-Content $TestDrive/profiles.json | ConvertFrom-Json).Globals
        $Settings.initialRows | Should -Be 24
    }
    It "Sets requestedTheme" {
        Set-MSTerminalSetting -requestedTheme dark
        $Settings = (Get-Content $TestDrive/profiles.json | ConvertFrom-Json).Globals
        $Settings.requestedTheme | Should -Be dark
    }
    It "Sets showTerminalTitleInTitlebar" {
        Set-MSTerminalSetting -showTerminalTitleInTitlebar:$false
        $Settings = (Get-Content $TestDrive/profiles.json | ConvertFrom-Json).Globals
        $Settings.showTerminalTitleInTitlebar | Should -Be $false
    }
    It "Preserves the property order in the json file" {
        $OrderBefore = (Get-Content $TestDrive/profiles.json -Raw | ConvertFrom-Json).Globals.PSObject.Properties.Name -Join ""
        Set-MSTerminalSetting -initialCols (Get-MSTerminalSetting).initialCols
        $OrderAfter = (Get-Content $TestDrive/profiles.json -Raw | ConvertFrom-Json).Globals.PSObject.Properties.Name -Join ""
        $OrderAfter | Should -Be $OrderBefore
    }
}
