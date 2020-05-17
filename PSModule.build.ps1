#requires -version 5.1

#region PowerCDBootstrap
. ([scriptblock]::Create((Invoke-WebRequest -UseBasicParsing 'https://git.io/PCDBootstrap')))
#endregion PowerCDBootstrap

task AdditionalFiles -After 'PowerCD.BuildPSModule' {
    if (Test-Path $BuildRoot\BuildOutput\MSTerminalSettings) {
        @(
            "MSTerminalSettings/Formats"
            "MSTerminalSettings/TerminalSettingsSchema.json"
        ).foreach{
            $sourceItem = Join-Path $BuildRoot $PSItem
            if (Test-Path $sourceItem) {
                #FIXME: Use variables for module name and path
                Copy-Item $sourceItem -Destination (Get-Item $BuildRoot\BuildOutput\MSTerminalSettings) -Recurse
            }
        }
        Copy-Item $BuildRoot/MSterminalSettings/src/TerminalSettingsDefaults.json -Destination $BuildRoot\BuildOutput\MSTerminalSettings
    }
}

task BuildTerminalSettings -After 'PowerCD.BuildPSModule' {
    if (-not (get-command dotnet)) {throw 'This build requires dotnet SDK 3.0 or greater installed'}
    #FIXME: Use variables for module name and path
    dotnet publish -o $BuildRoot\BuildOutput\MSTerminalSettings\lib $BuildRoot\MSTerminalSettings\src\TerminalSettings.csproj | Write-Verbose
    Remove-Item $BuildRoot\BuildOutput\MSTerminalSettings\lib\*.pdb
    Remove-Item $BuildRoot\BuildOutput\MSTerminalSettings\lib\*.deps.json
}