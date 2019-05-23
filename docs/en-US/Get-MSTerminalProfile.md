---
external help file: MSTerminalSettings-help.xml
Module Name: MSTerminalSettings
online version:
schema: 2.0.0
---

# Get-MSTerminalProfile

## SYNOPSIS
Returns the currently defined profiles from the profiles.json file.

## SYNTAX

```
Get-MSTerminalProfile [[-Name] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Returns the currently defined profiles from the profiles.json file.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-MSTerminalProfile
```

Returns all currently defined profiles.

### Example 2
```powershell
PS C:\> Get-MSTerminalProfile -Name powershell
```

Returns any profiles with the name powershell.

### Example 3
```powershell
PS C:\> Get-MSTerminalProfile -Name *power*
```

Returns any profiles that match *power*.

## PARAMETERS

### -Name
The name of a profile or a wildcard pattern

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
