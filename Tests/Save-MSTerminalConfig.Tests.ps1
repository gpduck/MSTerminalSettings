Describe 'Save-MSTerminalConfig' {
    BeforeAll {
        . $PSScriptRoot\Shared.ps1
    }
    BeforeEach {
        Copy-Item $Mocks/DefaultUserSettings.json $TestDrive/settings.json
        $testConfig = Get-MSTerminalConfig
        $testConfig.CopyFormatting = $true
    }
    Context 'Scenarios' {
        It 'No Parameters' {
            $testConfig | Save-MSTerminalConfig | Should -BeNullOrEmpty
            (Get-MSTerminalConfig).CopyFormatting | Should -BeTrue
        }
        It 'TerminalConfig Parameter' {
            (Save-MSTerminalConfig -TerminalConfig $testConfig -PassThru).CopyFormatting | Should -BeTrue
        }
        It 'TerminalConfig Positional Parameter' {
            (Save-MSTerminalConfig $testConfig -PassThru).CopyFormatting | Should -BeTrue
        }
        It 'TerminalConfig via Pipeline' {
            ($testConfig | Save-MSTerminalConfig -PassThru).CopyFormatting | Should -BeTrue
        }
        It 'Custom Output Path' {
            $customPath = "$TestDrive/customPath.json"
            Save-MSTerminalConfig $testConfig -Path $customPath
            Test-Path $customPath | Should -Be $true
            (Import-JsonWithComments $CustomPath).CopyFormatting | Should -Not -BeNullOrEmpty
        }
    }
}