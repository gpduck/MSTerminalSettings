. $PSScriptRoot\Shared.ps1

Describe "Add-MSTerminalProfile" {
    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }

    BeforeEach {
        Copy-Item $Mocks/DefaultUserSettings.json $TestDrive/settings.json
    }

    It "Adds a new profile" {
        $NewValues = @{
            Name = "newPester"
            useAcrylic = $true
            fontFace = "new-pester-font-face"
            cursorColor = "#FFFFFF"
            padding = '11,11,11,11'
            commandLine = "new-pester.exe"
            icon = "ms-appx:///new-pester.png"
            background = "#FFFFFF"
            backgroundImageAlignment = "bottomRight"
            fontSize = 11
            closeOnExit = $true
            snapOnInput = $true
            colorScheme = "new-pester"
            historySize = 11
            acrylicOpacity = 0.11
            cursorShape = "vintage"
            startingDirectory = "new-pester"
            hidden = $true
            source = "Windows.Terminal.PowershellCore"
            Guid = [Guid]::NewGuid().ToString('B')
        }
        Add-MSTerminalProfile @NewValues
        $NewProfile = Get-MSTerminalProfile -Name newPester
        $NewProfile | Should -Not -Be $null
        $NewValues.Keys | ForEach-Object {
            $ExpectedValue = $NewValues[$_]
            $ActualValue = $NewProfile."$_"
            $ActualValue | Should -Be $ExpectedValue
        }
    }

    It "Updates the default profile in globals" {
        $Before = Import-JsonWithComments $TestDrive/settings.json | ForEach-Object {$_}
        Add-MSTerminalProfile -Name "test default" -CommandLine "default" -MakeDefault
        $After = Import-JsonWithComments $TestDrive/settings.json | ForEach-Object {$_}
        $After.defaultProfile | Should -Not -Be $Before.defaultProfile
    }

    It "Generates a guid when one is not provided" {
        Add-MSTerminalProfile -Name NoGuid -CommandLine NoGuid.exe
        (Get-MSTerminalProfile -name NoGuid).Guid | Should -Not -Be $null
    }
}