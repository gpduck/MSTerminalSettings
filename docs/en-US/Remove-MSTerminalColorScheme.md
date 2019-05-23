---
external help file: MSTerminalSettings-help.xml
Module Name: MSTerminalSettings
online version:
schema: 2.0.0
---

# Remove-MSTerminalColorScheme

## SYNOPSIS
Removes a defined color scheme from profiles.json

## SYNTAX

```
Remove-MSTerminalColorScheme [-Name] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes a defined color scheme from profiles.json

## EXAMPLES

### Example 1
```powershell
PS C:\> Remove-MSTerminalColorScheme -Name TestColors
```

Removes the "TestColors" scheme from profiles.json.

### Example 2
```powershell
PS C:\> Get-MSTerminalColorScheme -Name TestColors | Remove-MSTerminalColorScheme
```

Removes the "TestColors" scheme from profiles.json.

## PARAMETERS

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name(s) of the color scheme(s) to remove.  This can also be piped from Get-MSTerminalColorScheme.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### None

## NOTES

## RELATED LINKS
