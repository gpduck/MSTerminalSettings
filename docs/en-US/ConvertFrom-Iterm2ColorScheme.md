---
external help file: MSTerminalSettings-help.xml
Module Name: MSTerminalSettings
online version:
schema: 2.0.0
---

# ConvertFrom-Iterm2ColorScheme

## SYNOPSIS
Converts an itermcolors file to a PowerShell object (or Hashtable).

## SYNTAX

### Path (Default)
```
ConvertFrom-Iterm2ColorScheme [-Path] <String[]> [-AsHashtable] [<CommonParameters>]
```

### LiteralPath
```
ConvertFrom-Iterm2ColorScheme [-LiteralPath] <String[]> [-AsHashtable] [<CommonParameters>]
```

## DESCRIPTION
Converts an itermcolors file to a PowerShell object (or Hashtable).

## EXAMPLES

### Example 1
```powershell
PS C:\> ConvertFrom-Iterm2ColorScheme -Path .\file.itermcolors

brightRed    : #E50000
cyan         : #00A6B2
black        : #000000
brightGreen  : #00D900
green        : #00A600
brightYellow : #E5E500
brightBlue   : #0000FF
background   : #224FBC
foreground   : #FFFFFF
blue         : #0000B2
brightWhite  : #E5E5E5
white        : #BFBFBF
brightBlack  : #666666
brightCyan   : #00E5E5
brightPurple : #E500E5
yellow       : #999900
purple       : #B200B2
red          : #990000
```

Converts file.itermcolors into a PowerShell object.

### Example 2
```powershell
PS C:\> ConvertFrom-Iterm2ColorScheme -Path .\file.itermcolors -AsHashtable

Name                           Value
----                           -----
brightRed                      #E50000
cyan                           #00A6B2
black                          #000000
brightGreen                    #00D900
green                          #00A600
brightYellow                   #E5E500
brightBlue                     #0000FF
background                     #224FBC
foreground                     #FFFFFF
blue                           #0000B2
brightWhite                    #E5E5E5
white                          #BFBFBF
brightBlack                    #666666
brightCyan                     #00E5E5
brightPurple                   #E500E5
yellow                         #999900
purple                         #B200B2
red                            #990000
```

Converts file.itermcolors into a hash table suitable for splatting to New-MSTerminalColorScheme.

## PARAMETERS

### -AsHashtable
Return the color values as a hash table (suitable for splatting to New-MSTerminalColorScheme)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### A path to an itermcolors file

## OUTPUTS

### System.Object or Hashtable

## NOTES

## RELATED LINKS
