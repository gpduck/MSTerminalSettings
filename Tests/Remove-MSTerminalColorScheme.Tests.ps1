Describe "Remove-MSTerminalColorScheme" {
    BeforeAll {
        . $PSScriptRoot\Shared.ps1
    }

    BeforeEach {
        Copy-Item $Mocks/CustomSettings.json $TestDrive/settings.json
    }

    It "Removes a profile via pipeline" {
        Get-MSTerminalColorScheme -Name 'Dark Plus' | Remove-MSTerminalColorScheme -Confirm:$False
        Get-MSTerminalColorScheme -Name 'Dark Plus' | Should -BeNullOrEmpty
    }
}
