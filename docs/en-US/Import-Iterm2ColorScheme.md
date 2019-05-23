---
external help file: MSTerminalSettings-help.xml
Module Name: MSTerminalSettings
online version:
schema: 2.0.0
---

# Import-Iterm2ColorScheme

## SYNOPSIS
Imports an iterm2 colorscheme file into MS Terminal.

## SYNTAX

```
Import-Iterm2ColorScheme [-Path] <Object> [-Name] <Object> [<CommonParameters>]
```

## DESCRIPTION
Imports an iterm2 colorscheme file into MS Terminal.

## EXAMPLES

### Example 1
```powershell
PS C:\> Import-Iterm2ColorScheme -Path .\file.itermcolors -Name ColorScheme
```

Imports the file .\file.itermcolors into MS Terminal as a new color scheme named "ColorScheme"

## PARAMETERS

### -Name
The name of the color scheme to create in MS Terminal

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The path to the itermcolors file to import

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
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

### None

## NOTES

## RELATED LINKS
