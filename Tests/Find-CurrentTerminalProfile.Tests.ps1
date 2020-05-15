Describe "Find-CurrentTerminalProfile" {
    BeforeAll {
        . $PSScriptRoot\Shared.ps1
        $env:WT_SESSION = 'pester'
        if (-not $TestDrive) {throw 'TestDrive Could not be detected, this should not happen!'}
        Copy-Item $Mocks/DefaultUserSettings.json $TestDrive/settings.json
    }
    It "Detects powershell" {
        $env:WT_PROFILE_ID = $null

        InModuleScope MSTerminalSettings {
            Mock Get-Process {@{
                Path = 'C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe'
                ProcessName = 'powershell'
            }}
            (Find-CurrentTerminalProfile).Name | Should -Be 'Windows Powershell'
        }
    }
    It "Detects pwsh" {
        $env:WT_PROFILE_ID = $null
        Mock Get-Process {@{
            ProcessName = 'pwsh'
        }}
        InModuleScope MSTerminalSettings {
            (Find-CurrentTerminalProfile).Name | Should -Be 'Powershell'
        }
    }
    It "Detects `$env:WT_PROFILE_ID by Name" {
        $env:WT_PROFILE_ID = 'Windows Powershell'
        InModuleScope MSTerminalSettings {
            (Find-CurrentTerminalProfile).Name | Should -Be 'Windows Powershell'
        }
    }
    It "Detects `$env:WT_PROFILE_ID by GUID" {
        $env:WT_PROFILE_ID = '{61c54bbd-c2c6-5271-96e7-009a87ff44bf}'
        InModuleScope MSTerminalSettings {
            (Find-CurrentTerminalProfile).Name | Should -Be 'Windows Powershell'
        }
    }
    AfterAll {
        $env:WT_SESSION = $null
    }
}