---
external help file: MSTerminalSettings-help.xml
Module Name: MSTerminalSettings
online version:
schema: 2.0.0
---

# Get-MSTerminalColorScheme

## SYNOPSIS
Returns the currently defined color schemes from the profiles.json file.

## SYNTAX

```
Get-MSTerminalColorScheme [[-Name] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Returns the currently defined color schemes from the profiles.json file.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-MSTerminalColorScheme
```

Returns all currently defined color schemes.

### Example 2
```powershell
PS C:\> Get-MSTerminalColorScheme -Name Campbell
```

Returns any color schemes with the name Campbell.

### Example 3
```powershell
PS C:\> Get-MSTerminalColorScheme -Name *dark*
```

Returns any color schemes that match *dark*.

## PARAMETERS

### -Name
The name of a color scheme or a wildcard pattern.

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
