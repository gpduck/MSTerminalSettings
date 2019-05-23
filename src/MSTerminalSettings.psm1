$Script:ModuleRoot = $PSScriptRoot



#Export all scripts as functions in .\ExportedFunctions, The functions must also be listed in the FunctionsToExport variable in the psd1 file.
Get-ChildItem $PSScriptRoot\ExportedFunctions\*.ps1 -Exclude *.Tests.ps1 | ForEach-Object {
	. $_.fullname
}
