[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $false
. $PSScriptRoot\Shared.ps1

Describe "New-MSTerminalColorScheme" {
    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }
    BeforeEach {
        Copy-Item $PSScriptRoot/Profiles/OneProfile.json $TestDrive/profiles.json
    }

    It "Preserves the property order in the json file" {
        #Testing the root object properties as we don't have a way to modify color schemes currently
        $OrderBefore = (Get-Content $TestDrive/profiles.json -Raw | ConvertFrom-Json).PSObject.Properties.Name -Join ""
        New-MSTerminalColorScheme -Name pester -background "#ffffff"
        $OrderAfter = (Get-Content $TestDrive/profiles.json -Raw | ConvertFrom-Json).PSObject.Properties.Name -Join ""
        $OrderAfter | Should -Be $OrderBefore
    }
}
