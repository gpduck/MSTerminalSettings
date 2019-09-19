[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $false
. $PSScriptRoot\Shared.ps1

Describe "New-MSTerminalProfile" {
    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }

    context "Existing Profile" {
        BeforeEach {
            Copy-Item $PSScriptRoot/Profiles/OneProfile.json $TestDrive/profiles.json
        }

        It "Adds a new profile" {
            $NewValues = @{
                Name = "new-pester"
                useAcrylic = $true
                fontFace = "new-pester-font-face"
                cursorColor = "#newpester"
                padding = @(11,11,11,11)
                commandLine = "new-pester.exe"
                icon = "ms-appx:///new-pester.png"
                background = "#new-pester"
                backgroundImageAlignment = "bottomRight"
                fontSize = 11
                closeOnExit = $true
                snapOnInput = $true
                colorScheme = "new-pester"
                historySize = 11
                acrylicOpacity = 0.11
                cursorShape = "vintage"
                startingDirectory = "new-pester"
            }
            $SCRIPT:ExtraSettingValue1 = [Guid]::NewGuid().guid
            $SCRIPT:ExtraSettingValue2 = [Guid]::NewGuid().guid
            $ExtraSettings = @{
                ExtraSetting1 = $ExtraSettingValue1
                ExtraSetting2 = $ExtraSettingValue2
            }
            New-MSTerminalProfile @NewValues -ExtraSettings $ExtraSettings
            $NewProfile = Get-MSTerminalProfile -Name new-pester
            $NewProfile | Should -Not -Be $null
            $NewValues.Keys | ForEach-Object {
                if($_ -eq "padding") {
                    $ExpectedValue = $NewValues[$_] -Join ", "
                } else {
                    $ExpectedValue = $NewValues[$_]
                }
                $ActualValue = $NewProfile."$_"
                $ActualValue | Should -Be $ExpectedValue
            }
            1..2 | foreach {
                (Get-MSTerminalProfile -Name 'new-pester')."ExtraSetting$_" | Should -Be (Get-Variable "ExtraSettingValue$_").value
            }
        }

        It "Updates the default profile in globals" {
            $Before = Get-Content $TestDrive/profiles.json | ConvertFrom-Json | ForEach-Object {$_}
            New-MSTerminalProfile -Name "test default" -CommandLine "default" -MakeDefault
            $After = Get-Content $TestDrive/profiles.json | ConvertFrom-Json | ForEach-Object {$_}
            $After.Globals.defaultProfile | Should -Not -Be $Before.Globals.defaultProfile

        }
    }

    context "No existing profiles" {
        BeforeEach {
            Copy-Item $PSScriptRoot/Profiles/MainSettings.json $TestDrive/profiles.json
        }

        It "Adds a new profile" {
            $NewValues = @{
                Name = "new-pester"
                useAcrylic = $true
                fontFace = "new-pester-font-face"
                cursorColor = "#newpester"
                padding = @(11,11,11,11)
                commandLine = "new-pester.exe"
                icon = "ms-appx:///new-pester.png"
                background = "#new-pester"
                fontSize = 11
                closeOnExit = $true
                snapOnInput = $true
                colorScheme = "new-pester"
                backgroundImage = "pester-background.jpg"
                backgroundImageOpacity = "0.11"
                backgroundImageStretchMode = "uniform"
                historySize = 11
                acrylicOpacity = 0.11
                cursorShape = "vintage"
                startingDirectory = "new-pester"
            }
            New-MSTerminalProfile @NewValues
            $NewProfile = Get-MSTerminalProfile -Name new-pester
            $NewProfile | Should -Not -Be $null
            $NewValues.Keys | ForEach-Object {
                if($_ -eq "padding") {
                     $ExpectedValue = $NewValues[$_] -Join ", "
                } else {
                    $ExpectedValue = $NewValues[$_]
                }
                $ActualValue = $NewProfile."$_"
                $ActualValue | Should -Be $ExpectedValue
            }
        }
    }
}
