---
external help file: MSTerminalSettings-help.xml
Module Name: MSTerminalSettings
online version:
schema: 2.0.0
---

# Set-MSTerminalProfile

## SYNOPSIS
Updates a profile setting.

## SYNTAX

### Name (Default)
```
Set-MSTerminalProfile -Name <String> [-CommandLine <String>] [-MakeDefault] [-HistorySize <Int32>]
 [-SnapOnInput] [-ColorScheme <String>] [-CursorColor <String>] [-CursorShape <String>] [-FontFace <String>]
 [-StartingDirectory <String>] [-FontSize <Int32>] [-AcrylicOpacity <Single>] [-UseAcrylic] [-CloseOnExit]
 [-Icon <String>] [-Padding <Int32[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### InputObject
```
Set-MSTerminalProfile -InputObject <Object> [-CommandLine <String>] [-MakeDefault] [-HistorySize <Int32>]
 [-SnapOnInput] [-ColorScheme <String>] [-CursorColor <String>] [-CursorShape <String>] [-FontFace <String>]
 [-StartingDirectory <String>] [-FontSize <Int32>] [-AcrylicOpacity <Single>] [-UseAcrylic] [-CloseOnExit]
 [-Icon <String>] [-Padding <Int32[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates a profile setting.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-MSTerminalProfile -Name pwsh -MakeDefault -FontSize 14
```

Updates the "pwsh" profile to be the default and sets the font size to 14.

## PARAMETERS

### -AcrylicOpacity
Sets the acrylic opacity, 0 being completely transparent and 1 being completely opaque.  This should be a number between 0 and 1.

```yaml
Type: Single
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CloseOnExit
Should MS Terminal close the tab when the program exits.

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

### -ColorScheme
The name of the color scheme to use for this profile.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommandLine
The command line to run for this profile.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### -CursorColor
The cursor color in the format "#RRGGBB"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CursorShape
The cursor shape.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: bar, vintage

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FontFace
The name of the font to use for this profile.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FontSize
The size of the font

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HistorySize
The number of lines of history to store.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Icon
The icon to use for this profile.  Ex: "ms-appdata:///roaming/console.ico"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
A profile object from Get-MSTerminalProfile that will be updated.

```yaml
Type: Object
Parameter Sets: InputObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -MakeDefault
If specified, this profile will become the default profile.

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

### -Name
The name of the profile that will be updated.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Padding
The padding to use between the window edges and the text.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SnapOnInput
Enable the SnapOnInput setting.

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

### -StartingDirectory
The working directory to start in.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseAcrylic
Enable acrylic effects.

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

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
