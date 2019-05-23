# MSTerminalSettings
## about_MSTerminalSettings

# SHORT DESCRIPTION
Manage MS Terminal settings, profiles, and color schemes with PowerShell.

# LONG DESCRIPTION
Manage MS Terminal settings, profiles, and color schemes with PowerShell.

# EXAMPLES
Import-Module MSTerminalSettings
New-MSTerminalProfile -Name pwsh -CommandLine "C:\Program Files\PowerShell\6\pwsh.exe -WorkingDirectory ~" -Background "#012456" -ColorScheme Campbell

Import-Iterm2ColorScheme -Path .\ItermProfile.itermcolors -Name ItermProfile

# TROUBLESHOOTING NOTE
Note this only runs in PowerShell 6+.

Until there is an official build, the package names used in Find-MSTerminalFolder may not be accurate.  You can edit this function if the module cannot find your terminal settings folder.