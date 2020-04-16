. $PSScriptRoot\Shared.ps1

Describe "Add-MSTerminalColorScheme" {
    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }
    BeforeEach {
        Copy-Item $Mocks/CustomSettings.json $TestDrive/settings.json
    }

    It "Adds the color scheme successfully" {
        Add-MSTerminalColorScheme -Name 'pester' -background '#ffffff'
        (Get-MSTerminalColorScheme -Name 'pester').background | Should -Be '#ffffff'
    }
}
