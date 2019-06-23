---
external help file: MSTerminalSettings-help.xml
Module Name: MSTerminalSettings
online version:
schema: 2.0.0
---

# New-MSTerminalColorTable

## SYNOPSIS
Generates a new array of colors for use in the -ColorTable parameter of New-MSTerminalProfile and Set-MSTerminalProfile.

## SYNTAX

```
New-MSTerminalColorTable [[-black] <String>] [[-blue] <String>] [[-brightBlack] <String>]
 [[-brightBlue] <String>] [[-brightCyan] <String>] [[-brightGreen] <String>] [[-brightPurple] <String>]
 [[-brightRed] <String>] [[-brightWhite] <String>] [[-brightYellow] <String>] [[-cyan] <String>]
 [[-green] <String>] [[-purple] <String>] [[-red] <String>] [[-white] <String>] [[-yellow] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Generates a new array of colors for use in the -ColorTable parameter of New-MSTerminalProfile and Set-MSTerminalProfile.  All colors are optional with default values being provided from the built-in Campbell color scheme.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Colors = @{
    black = '#0C0C0C'
    blue = '#0037DA'
    brightBlack = '#767676'
    brightBlue = '#3B78FF'
    brightCyan = '#61D6D6'
    brightGreen = '#16C60C'
    brightPurple = '#B4009E'
    brightRed = '#E74856'
    brightWhite = '#F2F2F2'
    brightYellow = '#F9F1A5'
    cyan = '#3A96DD'
    green = '#13A10E'
    purple = '#881798'
    red = '#C50F1F'
    white = '#CCCCCC'
    yellow = '#C19C00'
}
PS C:\> $ColorTable = New-MSTerminalColorTable @Colors
PS C:\> Set-MSTerminalProfile -Name PowerShell -ColorTable $ColorTable -ColorScheme $null
```

Generates a color table array and sets the profile named "PowerShell" to use the custom color table instead of a defined color scheme.

## PARAMETERS

### -black
The black color in hex color format "#rrggbb".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: "#0C0C0C"
Accept pipeline input: False
Accept wildcard characters: False
```

### -blue
The blue color in hex color format "#rrggbb"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: "#0037DA"
Accept pipeline input: False
Accept wildcard characters: False
```

### -brightBlack
The brightBlack color in hex color format "#rrggbb"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: "#767676"
Accept pipeline input: False
Accept wildcard characters: False
```

### -brightBlue
The brightBlue color in hex color format "#rrggbb"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: "#3B78FF"
Accept pipeline input: False
Accept wildcard characters: False
```

### -brightCyan
The brightCyan color in hex color format "#rrggbb"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: "#61D6D6"
Accept pipeline input: False
Accept wildcard characters: False
```

### -brightGreen
The brightGreen color in hex color format "#rrggbb"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: "#16C60C"
Accept pipeline input: False
Accept wildcard characters: False
```

### -brightPurple
The brightPurple color in hex color format "#rrggbb"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: "#B4009E"
Accept pipeline input: False
Accept wildcard characters: False
```

### -brightRed
The brightRed color in hex color format "#rrggbb"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: "#E74856"
Accept pipeline input: False
Accept wildcard characters: False
```

### -brightWhite
The brightWhite color in hex color format "#rrggbb"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: "#F2F2F2"
Accept pipeline input: False
Accept wildcard characters: False
```

### -brightYellow
The brightYellow color in hex color format "#rrggbb"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: "#F9F1A5"
Accept pipeline input: False
Accept wildcard characters: False
```

### -cyan
The cyan color in hex color format "#rrggbb"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: "#3A96DD"
Accept pipeline input: False
Accept wildcard characters: False
```

### -green
The green color in hex color format "#rrggbb"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: "#13A10E"
Accept pipeline input: False
Accept wildcard characters: False
```

### -purple
The purple color in hex color format "#rrggbb"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: "#881798"
Accept pipeline input: False
Accept wildcard characters: False
```

### -red
The red color in hex color format "#rrggbb"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: "#C50F1F"
Accept pipeline input: False
Accept wildcard characters: False
```

### -white
The white color in hex color format "#rrggbb"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: "#CCCCCC"
Accept pipeline input: False
Accept wildcard characters: False
```

### -yellow
The yellow color in hex color format "#rrggbb"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: "#C19C00"
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.String[]
## NOTES

## RELATED LINKS
