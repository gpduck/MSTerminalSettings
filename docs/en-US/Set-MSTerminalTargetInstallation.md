---
external help file: MSTerminalSettings-help.xml
Module Name: MSTerminalSettings
online version:
schema: 2.0.0
---

# Set-MSTerminalTargetInstallation

## SYNOPSIS
Used to switch the module target between the Dev, Release, and Standalone installations of Microsoft Terminal.

## SYNTAX

### Builtin
```
Set-MSTerminalTargetInstallation -Type <Object> [<CommonParameters>]
```

### Custom
```
Set-MSTerminalTargetInstallation -Path <Object> [<CommonParameters>]
```

## DESCRIPTION
Used to switch the module target between the Dev, Release, and Standalone installations of Microsoft Terminal.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-MSTerminalTargetInstallation -Type Dev
```

Change the target profiles.json to the dev path (WindowsTerminalDev_8wekyb3d8bbwe)

### Example 2
```powershell
PS C:\> Set-MSTerminalTargetInstallation -Type Release
```

Change the target profiles.json to the release path (Microsoft.WindowsTerminal_8wekyb3d8bbwe)

## PARAMETERS

### -Path
A fully qualified path to the parent folder of a profiles.json file.

```yaml
Type: Object
Parameter Sets: Custom
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The application release to target for the module.

Release = Installed from Windows Store
Standalone = Non-packaged version
Dev = Compiled from source and installed via appx
Clear = Enables the auto-discovery mode that searches for Release, Standalone, then Dev.

```yaml
Type: Object
Parameter Sets: Builtin
Aliases:
Accepted values: Dev, Release, Standalone, Clear

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

## NOTES

## RELATED LINKS
