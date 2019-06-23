# Description

This module updates the profiles.json file for the new [Microsoft Terminal](https://github.com/microsoft/terminal).

# Installation

The module is available from the [PowerShell Gallery](https://www.powershellgallery.com/packages/MSTerminalSettings) and can be installed using PowerShellGet

```
Install-Module -Name MSTerminalSettings
```

I've been developing the module on PowerShell 6 but have been trying to ensure it will also run on Windows PowerShell 5.1.

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
Invoke-RestMethod -Uri 'https://github.com/PowerShell/PowerShell/raw/master/assets/StoreLogo-Preview.png' -OutFile "$TerminalFolder\RoamingState\StoreLogo-Preview.png"

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