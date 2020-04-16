. $PSScriptRoot\Shared.ps1

Describe "Get-MSTerminalProfile" {
    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }

    $profileNameToTest = 'Windows Powershell'
    Copy-Item $Mocks/DefaultSettings.json $TestDrive/settings.json
    $profileToTest = Get-MSTerminalProfile -Name $profileNameToTest

    $valuesToTest = (Get-Content $TestDrive/settings.json | ConvertFrom-Json).profiles.list | Where-Object name -match $profileNameToTest

    $valuesToTest.psobject.properties.foreach{
        It "Reads $($PSItem.Name)" {
            $propertyToTest = if ($profileToTest.($PSItem.Name).Enum) {
                $profileToTest.($PSItem.Name).Enum
            } else {
                $profileToTest.($PSItem.Name)
            }
            $propertyToTest | Should -be $PSItem.Value
        }
    }

    # Context "Default Profile" {
    #     BeforeEach {
    #         Copy-Item $PSScriptRoot/Profiles/NewInstallSettings.json $TestDrive/settings.json
    #     }

    #     It "Reads the default profile" {
    #         $profileResult = Get-MSTerminalProfile -GUID "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}"
    #         $profileResult.Name | Should -Be 'Windows Powershell'
    #     }
    # }
}
