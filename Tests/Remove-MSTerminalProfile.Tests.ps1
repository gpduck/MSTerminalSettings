Describe "Remove-MSTerminalProfile" {
    BeforeAll {
        . $PSScriptRoot\Shared.ps1
    }

    BeforeEach {
        Copy-Item $Mocks/CustomSettings.json $TestDrive/settings.json
    }

    It "Removes a profile via pipeline" {
        Get-MSTerminalProfile -Name 'Powershell Demo' | Remove-MSTerminalProfile -Confirm:$False
        Get-MSTerminalProfile -Name 'Powershell Demo' | Should -BeNullOrEmpty
    }
}
