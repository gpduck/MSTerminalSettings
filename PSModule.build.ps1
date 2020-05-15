#requires -version 5.1

#region PowerCDBootstrap
. ([scriptblock]::Create((Invoke-WebRequest -UseBasicParsing 'https://git.io/PCDBootstrap')))
#endregion PowerCDBootstrap

task AdditionalFiles -After 'PowerCD.BuildPSModule' {
    if (Test-Path $BuildRoot\BuildOutput\MSTerminalSettings) {
        @(
            "Formats"
        ).foreach{
            $sourceItem = Join-Path $BuildRoot $PSItem
            if (Test-Path $sourceItem) {
                #FIXME: Use variables for module name and path
                Copy-Item $sourceItem -Destination (Get-Item $BuildRoot\BuildOutput\MSTerminalSettings)
            }
        }
    }
}

task BuildTerminalSettings -After 'PowerCD.BuildPSModule' {
    if (-not (get-command dotnet)) {throw 'This build requires dotnet SDK 3.0 or greater installed'}
    #FIXME: Use variables for module name and path
    dotnet publish -o $BuildRoot\BuildOutput\MSTerminalSettings $BuildROot\MSTerminalSettings\src\TerminalSettings.csproj | Write-Verbose
}