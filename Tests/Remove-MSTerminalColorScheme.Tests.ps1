. $PSScriptRoot\Shared.ps1

Describe "Remove-MSTerminalColorScheme" {
    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }

    BeforeEach {
        Copy-Item $Mocks/CustomSettings.json $TestDrive/settings.json
    }

    It "Removes a profile via pipeline" {
        Get-MSTerminalColorScheme -Name 'Dark Plus' | Remove-MSTerminalColorScheme -Confirm:$False
        Get-MSTerminalColorScheme -Name 'Dark Plus' | Should -BeNullOrEmpty
    }
}
