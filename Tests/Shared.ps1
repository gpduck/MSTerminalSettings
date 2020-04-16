# Dot source this script in any Pester test script that requires the module to be imported.
param (
    [Switch]$SkipImportModule
)

$ModuleManifestName = 'MSTerminalSettings.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\MSTerminalSettings\$ModuleManifestName"

if (!$SkipImportModule) {
    # -Scope Global is needed when running tests from inside of psake, otherwise
    # the module's functions cannot be found in the MSTerminalConfig\ namespace
    Import-Module $ModuleManifestPath -Scope Global -ErrorAction Stop -Force
}

$GLOBAL:Mocks = "$PSScriptRoot\Mocks"