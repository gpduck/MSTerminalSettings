[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $false
. $PSScriptRoot\Shared.ps1

Describe "Set-MSTerminalProfile" {
    New-Item -Path $TestDrive/RoamingState -ItemType Directory

    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }
    BeforeEach {
        Copy-Item $PSScriptRoot/Profiles/OneProfile.json $TestDrive/RoamingState/profiles.json
    }
    Context "Profile by pipeline" {
        It "Updates commandLine" {
            $P = Get-MSTerminalProfile
            $ExpectedValue = [Guid]::NewGuid().Guid
            $P | Set-MSTerminalProfile -CommandLine $ExpectedValue
            (Get-MSTerminalProfile).CommandLine | Should -Be $ExpectedValue
        }
    }

    Context "Wrong Case" {
        BeforeEach {
            Copy-Item $PSScriptRoot/Profiles/WrongCase.json $TestDrive/RoamingState/profiles.json
        }
        It "Clear works with wrong case" {
            $P = Get-MSTerminalProfile
            $P | Set-MSTerminalProfile -Clear colorscheme
            (Get-MSTerminalProfile).colorScheme | Should -Be $Null
        }

        It "Empty string parameter works with wrong case" {
            $P = Get-MSTerminalProfile
            $P | Set-MSTerminalProfile -ColorScheme ""
            (Get-MSTerminalProfile).colorScheme | Should -Be $Null
        }
    }
}
