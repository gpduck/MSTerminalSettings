[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $false
. $PSScriptRoot\Shared.ps1

Describe "Remove-MSTerminalProfile" {
    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }

    context "One profile exists" {
        BeforeEach {
            Copy-Item $PSScriptRoot/Profiles/OneProfile.json $TestDrive/profiles.json
        }

        It "Preserves the property order in the json file" {
            #Testing the root object properties as we don't have a way to modify color schemes currently
            $OrderBefore = (Get-Content $TestDrive/profiles.json -Raw | ConvertFrom-Json).PSObject.Properties.Name -Join ""
            Get-MSTerminalProfile | Remove-MSTerminalProfile -Confirm:$False
            $OrderAfter = (Get-Content $TestDrive/profiles.json -Raw | ConvertFrom-Json).PSObject.Properties.Name -Join ""
            $OrderAfter | Should -Be $OrderBefore
        }

        It "Removes a profile via pipeline" {
            Get-MSTerminalProfile -Name pester | Remove-MSTerminalProfile -Confirm:$False
            (Get-Content $TestDrive/profiles.json -Raw | ConvertFrom-Json).Profiles.count | Should -Be 0
        }
    }

    context "Multiple profiles exist" {
        BeforeEach {
            Copy-Item $PSScriptRoot/Profiles/MultipleProfiles.json $TestDrive/profiles.json
        }

        It "Removes only one profile via pipeline" {
            Get-MSTerminalProfile -Name pester | Remove-MSTerminalProfile -Confirm:$False
            (Get-Content $TestDrive/profiles.json -Raw | ConvertFrom-Json).Profiles.count | Should -Be 1
        }
    }
}
