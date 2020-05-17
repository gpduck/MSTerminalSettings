#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="4.999.999" }
# Dot source this script in any Pester test script that requires the module to be imported.
param (
    [Switch]$SkipImportModule,
    [String]$ModuleManifestPath = $ENV:PesterModulePath
)

#Load Private function used for Powershell 5.1 compatibility
. $PSScriptRoot\..\MSTerminalSettings\Private\Import-JsonWithComments.ps1

if ($PSEdition -eq 'Desktop') {
    Write-Verbose "Detected Windows Powershell 5.1, running tests against released module"
    $ModuleManifestPath = Resolve-Path "$psscriptroot\..\BuildOutput\MSterminalSettings\MSTerminalSettings.psd1"
}

if ($BuildRoot) {
    Write-Verbose "Detected Invoke-Build, running tests against compiled module"
    $ModuleManifestPath = Resolve-Path "$psscriptroot\..\BuildOutput\MSterminalSettings\MSTerminalSettings.psd1"
}

$ModuleManifestName = 'MSTerminalSettings.psd1'
if (-not $ModuleManifestPath) {
    $ModuleManifestPath = "$PSScriptRoot\..\MSTerminalSettings\$ModuleManifestName"
}

if (!$SkipImportModule) {
    # -Scope Global is needed when running tests from inside of psake, otherwise
    # the module's functions cannot be found in the MSTerminalConfig\ namespace
    Import-Module $ModuleManifestPath -Scope Global -ErrorAction Stop -Force
}

$GLOBAL:Mocks = "$PSScriptRoot\Mocks"

Set-Variable -Scope 1 -Name MSTerminalDefaultSettingsPath -Value (Resolve-Path "$PSScriptRoot\..\MSTerminalSettings\src\TerminalSettingsDefaults.json")

Mock Find-MSTerminalFolder -ModuleName MSTerminalSettings -MockWith {
    if (-not $TestDrive) {throw 'TestDrive could not be detected, this should not happen!'}
    return $TestDrive
}