$Script:ModuleRoot = $PSScriptRoot



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