using namespace WindowsTerminal
$Script:ModuleRoot = $PSScriptRoot

$Script:DEV_PATH = "packages/WindowsTerminalDev_8wekyb3d8bbwe/LocalState"
$Script:DEV_PATH_ALT = "packages/WindowsTerminalDev_8wekyb3d8bbwe/RoamingState"
$Script:RELEASE_PATH = "packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"
$Script:RELEASE_PATH_ALT = "packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/RoamingState"
$Script:STANDALONE_PATH = "Microsoft/Windows Terminal"

#Load the validated schema types if not already loaded
try {
	$null = [WindowsTerminal.TerminalSettings]
} catch [Management.Automation.RuntimeException] {
	if ([String]$psitem -match 'Unable to find type') {
        if (Test-Path "$PSSCRIPTROOT/lib/TerminalSettings.dll") {
            Add-Type -Path "$PSSCRIPTROOT/lib/*.dll"
        } elseif (Test-Path "$PSSCRIPTROOT/Private/Build-TerminalSettingsAssembly.ps1") {
            . $PSSCRIPTROOT/Private/Build-TerminalSettingsAssembly.ps1
            Build-TerminalSettingsAssembly
        } else {
            throw 'TerminalSettings: Could not find compiled DLL or the src files. This is probably a bug.'
        }
	} else {throw $PSItem}
}

$publicFunctions = @()
foreach ($ScriptPathItem in 'Private','Public','ArgumentCompleters') {
    $ScriptSearchFilter = [io.path]::Combine($PSScriptRoot, $ScriptPathItem, '*.ps1')
    Get-ChildItem $ScriptSearchFilter | Foreach-Object {
        if ($ScriptPathItem -eq 'Public') {$PublicFunctions += $PSItem.BaseName}
        . $PSItem
    }
}
Export-ModuleMember -Function $PublicFunctions
foreach ($verb in 'Get','Set','New') {
    New-Alias -Name "$verb-MSTerminalSetting" -Value "$verb-MSTerminalConfig"
    Export-ModuleMember -Alias "$verb-MSTerminalSetting"
}


#Add a not implemented exception for work in progress

$SCRIPT:QuickTypeNotImplementedException = [notimplementedexception]'This command has not been reimplemented for the new version yet. Stay tuned!'