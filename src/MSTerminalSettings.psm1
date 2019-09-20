$Script:ModuleRoot = $PSScriptRoot

$Script:DEV_PATH = "packages/WindowsTerminalDev_8wekyb3d8bbwe/LocalState"
$Script:DEV_PATH_ALT = "packages/WindowsTerminalDev_8wekyb3d8bbwe/RoamingState"
$Script:RELEASE_PATH = "packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"
$Script:RELEASE_PATH_ALT = "packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/RoamingState"
$Script:STANDALONE_PATH = "Microsoft/Windows Terminal"

#Export all scripts as functions in .\ExportedFunctions, The functions must also be listed in the FunctionsToExport variable in the psd1 file.
Get-ChildItem $PSScriptRoot\ExportedFunctions\*.ps1 -Exclude *.Tests.ps1 | ForEach-Object {
	. $_.fullname
}

# Import all scripts as functions in .\InternalFunctions.
Get-ChildItem $PSScriptRoot\InternalFunctions\*.ps1 -Exclude *.Tests.ps1 | ForEach-Object {
	. $_.fullname
}

# Load any argument completers
if( Test-Path $PSScriptRoot\ArgumentCompleters ) {
	Get-ChildItem $PSScriptRoot\ArgumentCompleters\*.ps1 -Exclude *.Tests.ps1 | ForEach-Object {
		. $_.fullname
	}
}
