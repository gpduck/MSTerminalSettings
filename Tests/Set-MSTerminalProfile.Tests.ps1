Describe "Set-MSTerminalProfile" {
    BeforeAll {
        . $PSScriptRoot\Shared.ps1
        $testProfileName = 'Windows Powershell'
    }
    BeforeEach {
        Copy-Item $Mocks/DefaultUserSettings.json $TestDrive/settings.json
    }


    Context "Profile by pipeline" {
        It "Updates commandLine" {
            $ExpectedValue = [Guid]::NewGuid().ToString('B')
            Get-MSTerminalProfile -Name $testProfileName |
                Set-MSTerminalProfile -CommandLine $ExpectedValue
            (Get-MSTerminalProfile -Name $testProfileName).CommandLine | Should -Be $ExpectedValue
        }
    }

    #Not relevant in new strongly typed scenario
    #TODO: Remove test once approved
    # Context "Wrong Case" {
    #     BeforeEach {
    #         Copy-Item $PSScriptRoot/Profiles/WrongCase.json $TestDrive/settings.json
    #     }
    #     #Clear was deprecated/removed because you can just set something to $null and it won't passthrough the null setting
    #     # It "Clear works with wrong case" {
    #     #     Get-MSTerminalProfile -Name 'Windows Powershell'
    #     #     $P | Set-MSTerminalProfile -Clear colorscheme
    #     #     (Get-MSTerminalProfile).colorScheme | Should -Be $Null
    #     # }

    #     # It "Empty string parameter works with wrong case" {
    #     #     $P = Get-MSTerminalProfile
    #     #     $P | Set-MSTerminalProfile -ColorScheme ""
    #     #     (Get-MSTerminalProfile).colorScheme | Should -Be $Null
    #     # }
    # }

    Context "Update Settings" {
        BeforeAll {
            $ExpectedValues = @{
                "backgroundImageAlignment" = "bottomRight"
                "source" = "Windows.Terminal.Wsl"
            }
            $ExpectedValues.Keys | ForEach-Object {
                $SettingName = $_
                $ExpectedValue = $ExpectedValues[$_]
                It "Updates $SettingName" {
                    $profileToTest = Get-MSTerminalProfile -Name $testProfileName
                    Invoke-Expression "Set-MSTerminalProfile -InputObject `$profileToTest -$SettingName $ExpectedValue"
                    (Get-MSTerminalProfile -Name $testProfileName)."$Settingname" | Should -Be $ExpectedValue
                }
            }
        }

        It "Can change a profile's guid" {
            $Before = Get-MSTerminalProfile -Name $testProfileName
            $NewGuid = [Guid]::NewGuid().ToString('B')
            Set-MSTerminalProfile -InputObject $Before -NewGuid $NewGuid
            $After = Get-MSTerminalProfile -Name $testProfileName
            $After.Guid | Should -Be $NewGuid
        }
    }

    It "Updates the default profile guid" {
        Set-MSTerminalConfig -DefaultProfile (New-Guid).ToString('B')
        $Before = Get-MSTerminalConfig
        Set-MSTerminalProfile -InputObject (Get-MSTerminalProfile -Name $testProfileName) -MakeDefault
        $After = Get-MSTerminalConfig
        $After.defaultProfile | Should -Not -Be $Before.defaultProfile
    }
}
