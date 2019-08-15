[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $false
. $PSScriptRoot\Shared.ps1

Describe "Set-MSTerminalProfile" {
    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }
    BeforeEach {
        Copy-Item $PSScriptRoot/Profiles/OneProfile.json $TestDrive/profiles.json
    }
    Context "Profile by pipeline" {
        It "Updates commandLine" {
            $P = Get-MSTerminalProfile
            $ExpectedValue = [Guid]::NewGuid().Guid
            $P | Set-MSTerminalProfile -CommandLine $ExpectedValue
            (Get-MSTerminalProfile).CommandLine | Should -Be $ExpectedValue
        }
    }

    Context "Arbitrary Setting" {
        It "Adds an arbitrary setting correctly" {
            $P = Get-MSTerminalProfile
            $ExpectedValue = [Guid]::NewGuid().Guid
            $P | Set-MSTerminalProfile -ExtraSettings @{MyAdditionalArbitrarySetting=$ExpectedValue}
            (Get-MSTerminalProfile).MyAdditionalArbitrarySetting | Should -Be $ExpectedValue
        }
    }

    Context "Wrong Case" {
        BeforeEach {
            Copy-Item $PSScriptRoot/Profiles/WrongCase.json $TestDrive/profiles.json
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

    It "Preserves the property order in the json file" {
        $OrderBefore = (Get-Content $TestDrive/profiles.json -Raw | ConvertFrom-Json).Profiles[0].PSObject.Properties.Name -Join ""
        Set-MSTerminalProfile -Name pester -background (Get-MSTerminalProfile -Name pester).background
        $OrderAfter = (Get-Content $TestDrive/profiles.json -Raw | ConvertFrom-Json).Profiles[0].PSObject.Properties.Name -Join ""
        $OrderAfter | Should -Be $OrderBefore
    }
}
