[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $false
. $PSScriptRoot\Shared.ps1

Describe "DetectCurrentTerminalProfile" {
    $GLOBAL:pesterPSScriptRoot = $PSSCriptROot

    InModuleScope MSTerminalSettings {
        $env:WT_SESSION = 'pester'

        Mock Get-MSTerminalProfile {
            $profiles = Import-Clixml $GLOBAL:pesterPSScriptRoot/Profiles/GetMSTerminalDefaultProfile.clixml

            if ($Name) {
                return $profiles | where name -eq $Name
            }
            if ($GUID) {
                return $profiles | where guid -eq $GUID
            }
            return $profiles
        }

        It "Detects powershell" {
            $env:WT_PROFILE = $null
            Mock Get-Process {@{
                Path = 'C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe'
                ProcessName = 'powershell'
            }}
            (DetectCurrentTerminalProfile).Name | Should -Be 'Windows Powershell'
        }
        It "Detects pwsh" {
            $env:WT_PROFILE = $null
            Mock Get-Process {@{
                ProcessName = 'pwsh'
            }}
            (DetectCurrentTerminalProfile).Name | Should -Be 'Powershell Core'
        }
        It "Detects `$env:WT_PROFILE by Name" {
            $env:WT_PROFILE = 'Windows Powershell'
            (DetectCurrentTerminalProfile)[0].Name | Should -Be 'Windows Powershell'
        }
        It "Detects `$env:WT_PROFILE by GUID" {
            $env:WT_PROFILE = '{61c54bbd-c2c6-5271-96e7-009a87ff44bf}'
            (DetectCurrentTerminalProfile)[0].Name | Should -Be 'Windows Powershell'
        }
    }
}