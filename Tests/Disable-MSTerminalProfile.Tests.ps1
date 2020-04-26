. $PSScriptRoot\Shared.ps1

Describe "Disable-MSTerminalProfile" {
    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }

    BeforeEach {
        Copy-Item $Mocks/DefaultUserSettings.json $TestDrive/settings.json
    }

    It "Disables a Profile" {
        get-msterminalprofile -guid '{61c54bbd-c2c6-5271-96e7-009a87ff44bf}' | Disable-MSTerminalProfile
        (get-msterminalprofile -guid '{61c54bbd-c2c6-5271-96e7-009a87ff44bf}').hidden | Should -Be $True
    }
    It "Re-Enables a Profile" {
        get-msterminalprofile -guid '{61c54bbd-c2c6-5271-96e7-009a87ff44bf}' | Disable-MSTerminalProfile
        get-msterminalprofile -guid '{61c54bbd-c2c6-5271-96e7-009a87ff44bf}' | Enable-MSTerminalProfile
        (get-msterminalprofile -guid '{61c54bbd-c2c6-5271-96e7-009a87ff44bf}').hidden | Should -Be $False
    }
}