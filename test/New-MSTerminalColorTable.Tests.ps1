[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $false
. $PSScriptRoot\Shared.ps1

Describe "New-MSTerminalColorTable" {
    It "Generates default values" {
        $Colors = New-MSTerminalColorTable
        for($i=0; $i -lt $Colors.Length; $i++) {
            $Colors[$i] | Should -Match "#[\da-fA-F]{6}"
        }
    }
}
