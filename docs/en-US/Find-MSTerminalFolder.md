---
external help file: MSTerminalSettings-help.xml
Module Name: MSTerminalSettings
online version:
schema: 2.0.0
---

# Find-MSTerminalFolder

## SYNOPSIS
Locates the profiles.json file for MS Terminal

## SYNTAX

```
Find-MSTerminalFolder [<CommonParameters>]
```

## DESCRIPTION
Locates the profiles.json file for MS Terminal.

## EXAMPLES

### Example 1
```powershell
PS C:\> Find-MSTerminalFolder
C:\Users\AUser\AppData\Local\packages\WindowsTerminalDev_8wekyb3d8bbwe
```

Searches for the WindowsTermminalDev or Microsoft.WindowsTerminal folder in the current user's packages path.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS
