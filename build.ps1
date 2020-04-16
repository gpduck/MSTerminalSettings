# Builds the module by invoking Invoke-Build on the module.build.ps1 script.
& $PSScriptRoot/Invoke-Build.ps1 -task Clean,Build,BuildHelp