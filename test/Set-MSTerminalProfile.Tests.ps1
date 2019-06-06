[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $false
. $PSScriptRoot\Shared.ps1

Describe "Set-MSTerminalProfile" {
    New-Item -Path $TestDrive/RoamingState -ItemType Directory

    Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
        $TestDrive
    }
    BeforeEach {
        Copy-Item $PSScriptRoot/Profiles/OneProfile.json $TestDrive/RoamingState/profiles.json
    }
    Context "Profile by pipeline" {
        It "Updates commandLine" {
$c = get-command write-host
write-host "$($c.modulename)\$($c.name)"
            $P = Get-MSTerminalProfile
            $ExpectedValue = [Guid]::NewGuid().Guid
            $P | Set-MSTerminalProfile -CommandLine $ExpectedValue
            (Get-MSTerminalProfile).CommandLine | Should -Be $ExpectedValue
        }
    }
}
