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
        Copy-Item $BuildRoot\MSTerminalSettings\src\TerminalSettingsDefaults.json -Destination $BuildRoot\BuildOutput\MSTerminalSettings
    }
}

task BuildTerminalSettings -After 'PowerCD.BuildPSModule' {
    if (-not (get-command dotnet)) {throw 'This build requires dotnet SDK 3.0 or greater installed'}
    #FIXME: Use variables for module name and path
    dotnet publish -o $BuildRoot\BuildOutput\MSTerminalSettings\lib $BuildRoot\MSTerminalSettings\src\TerminalSettings.csproj | Write-Verbose
    Remove-Item $BuildRoot\BuildOutput\MSTerminalSettings\lib\*.pdb
    Remove-Item $BuildRoot\BuildOutput\MSTerminalSettings\lib\*.deps.json
}

task BuildModuleHelp {
    #TODO: Run as job so as not to lock the build folder
    $buildOutputDir = "$BuildRoot\BuildOutput"
    Import-Module "$buildoutputdir\msterminalsettings\MSTerminalSettings.psd1" -force
    New-MarkdownHelp -Module MSTerminalSettings -OutputFolder $buildOutputDir\docs
    #Update-MarkdownHelp -Path $buildOutputDir\docs
    New-ExternalHelp -Path $buildOutputDir\docs -OutputPath $buildoutputdir\msterminalsettings\en-US

    #TODO: Derive content from README
    "Please see the Github README: https://github.com/gpduck/msterminalsettings" |
        Out-File -FilePath $buildoutputdir\msterminalsettings\en-US\about_MSTerminalSettings.txt -Encoding utf8
}

task BuildDocusaurusHelp {
    #TODO: Run as job so as not to lock the build folder
    $buildOutputDir = "$BuildRoot\BuildOutput"
    $newDocusaurusHelpParams = @{
        Module = "$buildoutputdir\msterminalsettings\MSTerminalSettings.psd1"
        DocsFolder = "$BuildRoot\BuildOutput\docs"
        SideBar = "commands"
        MetaDescription = 'Help page for the MSTerminalSettings "%1" command'
        MetaKeywords = @(
            "Windows"
            "Terminal"
            "Settings"
            "MSTerminalSettings"
            "Help"
            "Documentation"
        )
    }
    Write-Host "Generating Command Reference" -ForegroundColor Magenta
    New-DocusaurusHelp @newDocusaurusHelpParams
}