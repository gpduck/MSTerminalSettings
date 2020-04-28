# Description

This module updates the settings.json file for the new [Windows Terminal](https://github.com/microsoft/terminal).

# Installation

The module is available from the [PowerShell Gallery](https://www.powershellgallery.com/packages/MSTerminalConfig) and can be installed using PowerShellGet

```
Install-Module -Name MSTerminalSettings
```

The module is supported on Powershell 5.1+

# 2.0 What's New

## QuickType-Powered Configuration
Object Types are generated from the [official Windows Terminal schema](https://aka.ms/terminal-profiles-schema), so configuration parameters are generated dynamically and input validated. Parameter help is also populated from the schema.

## Summary Views
Config and Profile objects have summary views by default, and Color Schemes auto-highlight the color being used

![SummaryViews](Images\README\SummaryViews.gif)

## `Get-MSTerminalProfile` Autocompletion and Filter
`Get-MSTerminalProfile` will autocomplete the `Name` parameter with available profiles. You can also filter on any property with wildcard syntax.

![](Images\README\NameAutoComplete.gif)

## Full Parameter Validation
Parameters are validated based on the validation in the json schema. True/False parameters are implemented as switches.

## Support for defaults and globals
Ability to apply settings for all profiles and "global" config settings

![](Images\README\DefaultProfileSetting.gif)

## Full Pipeline Support
`Get` commands can be piped to `Set`, `Add`, and `Remove` commands
![](Images\README\Pipeline.gif)

##Retrieve Configurations from online

# 2.0 Breaking Changes

### No Comment Support
Comments will be removed from configs by the parsing engine.

# Examples

This example downloads the Pandora color scheme from [https://iterm2colorschemes.com/](https://iterm2colorschemes.com/) and sets it as the color scheme for the PowerShell Core terminal profile.

```
Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Pandora.itermcolors' -OutFile .\Pandora.itermcolors

Import-Iterm2ColorScheme -Path .\Pandora.itermcolors -Name Pandora

Get-MSTerminalProfile -Name "PowerShell Core" | Set-MSTerminalProfile -ColorScheme Pandora
```

This example creates a new profile for the PowerShell 7 preview using the PowerShell Hero logo.

```
$TerminalFolder = Find-MSTerminalFolder
Invoke-RestMethod -Uri 'https://github.com/PowerShell/PowerShell/raw/master/assets/StoreLogo-Preview.png' -OutFile "$TerminalFolder\StoreLogo-Preview.png"

$Pwsh7 = @{
    Name = "pwsh7-preview"
    CommandLine = 'C:\Program Files\PowerShell\7-preview\pwsh.exe'
    Icon = 'ms-appdata:///roaming/StoreLogo-Preview.png'
    ColorScheme = 'Campbell'
    FontFace = 'Consolas'
    StartingDirectory = '%USERPROFILE%'
}
New-MSTerminalProfile @Pwsh7
```

This example sets all your profiles to use a [programming font](https://app.programmingfonts.org/).  (Note the font must already be installed on your system)

```
Get-MSTerminalProfile | Set-MSTerminalProfile -FontFace "Fira Code Retina"
```
