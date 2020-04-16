. $PSScriptRoot\Shared.ps1

Describe "Set-MSTerminalConfig" {
    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }
    BeforeEach {
        Copy-Item $Mocks/DefaultUserSettings.json $TestDrive/settings.json
    }
    It "Sets alwaysShowTabs" {
        Set-MSTerminalConfig -AlwaysShowTabs:$false
        $Settings = Get-Content -Raw $TestDrive/settings.json | ConvertFrom-Json
        $Settings.alwaysShowTabs | Should -Be $false
    }
    It "Sets defaultProfile" {
        $testGuid = (New-Guid).ToString('B')
        Set-MSTerminalConfig -defaultProfile $testGuid
        $Settings = Get-Content -Raw $TestDrive/settings.json | ConvertFrom-Json
        $Settings.defaultProfile | Should -Be $testGuid
    }
    It "Sets disabledProfileSources" {
        Set-ItResult -Skipped -Because 'This is a hidden feature not part of the json schema and unsupported at the moment https://github.com/microsoft/terminal/issues/5410'
        Set-MSTerminalConfig -disabledProfileSources @("Windows.Terminal.Azure")
        $Settings = Get-Content -Raw $TestDrive/settings.json | ConvertFrom-Json
        $Settings.disabledProfileSources -contains "Windows.Terminal.Azure" | Should -Be $true
    }
    It "Sets showTabsInTitlebar" {
        Set-MSTerminalConfig -showTabsInTitlebar:$false
        $Settings = Get-Content -Raw $TestDrive/settings.json | ConvertFrom-Json
        $Settings.showTabsInTitlebar | Should -Be $false
    }
    It "Sets initialCols" {
        Set-MSTerminalConfig -initialCols 24
        $Settings = Get-Content -Raw $TestDrive/settings.json | ConvertFrom-Json
        $Settings.initialCols | Should -Be 24
    }
    It "Sets initialRows" {
        Set-MSTerminalConfig -initialRows 24
        $Settings = Get-Content -Raw $TestDrive/settings.json | ConvertFrom-Json
        $Settings.initialRows | Should -Be 24
    }
    It "Sets Theme" {
        Set-MSTerminalConfig -Theme dark
        $Settings = Get-Content -Raw $TestDrive/settings.json | ConvertFrom-Json
        $Settings.Theme | Should -Be dark
    }
    It "Sets showTerminalTitleInTitlebar" {
        Set-MSTerminalConfig -showTerminalTitleInTitlebar:$false
        $Settings = Get-Content -Raw $TestDrive/settings.json | ConvertFrom-Json
        $Settings.showTerminalTitleInTitlebar | Should -Be $false
    }
    context 'Pipeline Integrations' {
        It "Get-MSTerminalConfig" {
            Get-MSTerminalConfig | Set-MSTerminalConfig -InitialRows 50
            (Get-MSTerminalConfig).InitialRows | Should -Be 50
        }
    }
}