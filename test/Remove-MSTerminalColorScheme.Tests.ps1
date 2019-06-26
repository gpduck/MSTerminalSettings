[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $false
. $PSScriptRoot\Shared.ps1

Describe "Remove-MSTerminalColorScheme" {
    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }
    BeforeEach {
        Copy-Item $PSScriptRoot/Profiles/OneScheme.json $TestDrive/profiles.json
    }

    It "Preserves the property order in the json file" {
        #Testing the root object properties as we don't have a way to modify color schemes currently
        $OrderBefore = (Get-Content $TestDrive/profiles.json -Raw | ConvertFrom-Json).PSObject.Properties.Name -Join ""
        Get-MSTerminalColorScheme | Remove-MSTerminalColorScheme -Confirm:$False
        $OrderAfter = (Get-Content $TestDrive/profiles.json -Raw | ConvertFrom-Json).PSObject.Properties.Name -Join ""
        $OrderAfter | Should -Be $OrderBefore
    }
}
