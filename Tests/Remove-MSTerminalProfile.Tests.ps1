. $PSScriptRoot\Shared.ps1

Describe "Remove-MSTerminalProfile" {
    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }

    BeforeEach {
        Copy-Item $Mocks/CustomSettings.json $TestDrive/settings.json
    }

    It "Removes a profile via pipeline" {
        Get-MSTerminalProfile -Name 'Powershell Demo' | Remove-MSTerminalProfile -Confirm:$False
        Get-MSTerminalProfile -Name 'Powershell Demo' | Should -BeNullOrEmpty
    }
}
