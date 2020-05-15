
Describe 'Module Manifest Tests' {
    BeforeAll {
        . $PSScriptRoot/Shared.ps1
    }

    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should -Not -BeNullOrEmpty
    }
}