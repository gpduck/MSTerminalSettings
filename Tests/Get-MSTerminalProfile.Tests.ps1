Describe "Get-MSTerminalProfile" {
    BeforeAll {
        . $PSScriptRoot\Shared.ps1
        $profileNameToTest = 'Windows Powershell'
        Copy-Item $MSTerminalDefaultSettingsPath $TestDrive/settings.json
        $profileToTest = Get-MSTerminalProfile -Name $profileNameToTest
    }

    #FIXME: Some awkward setup to please Pester 5, it shouldn't be duplicated both here and in BeforeAll
    $profileNameToTest = 'Windows Powershell'
    $GLOBAL:Mocks = "$PSScriptRoot\Mocks"
    $MSTerminalDefaultSettingsPath = "$PSScriptRoot\..\MSTerminalSettings\src\TerminalSettingsDefaults.json"
    #End FIX

    . $PSScriptRoot\..\MSTerminalSettings\Private\Import-JsonWithComments.ps1
    $valuesToTest = (Import-JsonWithComments $MSTerminalDefaultSettingsPath).profiles.list | Where-Object name -match $profileNameToTest
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
