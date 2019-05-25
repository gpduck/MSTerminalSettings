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

### Path (Default)
```
Import-Iterm2ColorScheme [-Path] <String[]> [-Name <Object>] [<CommonParameters>]
```

### LiteralPath
```
Import-Iterm2ColorScheme [-LiteralPath] <String[]> [-Name <Object>] [<CommonParameters>]
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

### -LiteralPath
Specifies a path to one or more locations. The value of LiteralPath is used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose it in single quotation marks. Single quotation marks tell PowerShell not to interpret any characters as escape sequences.

```yaml
Type: String[]
Parameter Sets: LiteralPath
Aliases: PSPath

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
The name of the color scheme to create in MS Terminal.  If no name is specified, the base file name will be used.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Specifies the path to the itermcolors file. Wildcard characters are permitted. The paths must be paths to items, not to containers. For example, you must specify a path to one or more files, not a path to a directory.

```yaml
Type: String[]
Parameter Sets: Path
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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
