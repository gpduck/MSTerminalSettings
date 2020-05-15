Describe "Set-MSTerminalConfig" {
    BeforeAll {
        . $PSScriptRoot\Shared.ps1
    }
    BeforeEach {
        Copy-Item $Mocks/DefaultUserSettings.json $TestDrive/settings.json
    }
    It "Sets alwaysShowTabs" {
        Set-MSTerminalConfig -AlwaysShowTabs:$false
        $Settings = Import-JsonWithComments $TestDrive/settings.json
        $Settings.alwaysShowTabs | Should -Be $false
    }
    It "Sets defaultProfile" {
        $testGuid = (New-Guid).ToString('B')
        Set-MSTerminalConfig -defaultProfile $testGuid
        $Settings = Import-JsonWithComments $TestDrive/settings.json
        $Settings.defaultProfile | Should -Be $testGuid
    }
    It "Sets disabledProfileSources" {
        Set-MSTerminalConfig -disabledProfileSources @("WindowsTerminalAzure")
        $Settings = Import-JsonWithComments $TestDrive/settings.json
        $Settings.disabledProfileSources -contains "Windows.Terminal.Azure" | Should -Be $true
    }
    It "Sets showTabsInTitlebar" {
        Set-MSTerminalConfig -showTabsInTitlebar:$false
        $Settings = Import-JsonWithComments $TestDrive/settings.json
        $Settings.showTabsInTitlebar | Should -Be $false
    }
    It "Sets initialCols" {
        Set-MSTerminalConfig -initialCols 24
        $Settings = Import-JsonWithComments $TestDrive/settings.json
        $Settings.initialCols | Should -Be 24
    }
    It "Sets initialRows" {
        Set-MSTerminalConfig -initialRows 24
        $Settings = Import-JsonWithComments $TestDrive/settings.json
        $Settings.initialRows | Should -Be 24
    }
    It "Sets Theme" {
        Set-MSTerminalConfig -Theme dark
        $Settings = Import-JsonWithComments $TestDrive/settings.json
        $Settings.Theme | Should -Be dark
    }
    It "Sets showTerminalTitleInTitlebar" {
        Set-MSTerminalConfig -showTerminalTitleInTitlebar:$false
        $Settings = Import-JsonWithComments $TestDrive/settings.json
        $Settings.showTerminalTitleInTitlebar | Should -Be $false
    }
    context 'Pipeline Integrations' {
        It "Get-MSTerminalConfig" {
            Get-MSTerminalConfig | Set-MSTerminalConfig -InitialRows 50
            (Get-MSTerminalConfig).InitialRows | Should -Be 50
        }
    }
}