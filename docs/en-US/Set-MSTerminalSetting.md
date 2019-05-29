---
external help file: MSTerminalSettings-help.xml
Module Name: MSTerminalSettings
online version:
schema: 2.0.0
---

# Set-MSTerminalSetting

## SYNOPSIS
Updates the top-level settings for MS Terminal.

## SYNTAX

```
Set-MSTerminalSetting [[-DefaultProfile] <String>] [[-InitialRows] <Int32>] [[-InitialCols] <Int32>]
 [-AlwaysShowTabs] [[-RequestedTheme] <String>] [-ShowTerminalTitleInTitlebar] [-ShowTabsInTitlebar]
 [[-ExtraSettings] <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the top-level settings for MS Terminal.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-MSTerminalSetting -Initialrows 50 -AlwaysShowTabs
```

Sets the inital rows to 50 and enables always showing tabs.

## PARAMETERS

### -AlwaysShowTabs
Show tabs even when there is only a single console application running.

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

### -DefaultProfile
The GUID of the profile to launch when MS Terminal is opened.  Use Get-MSTerminalProfile | Set-MSTerminalProfile -MakeDefault to set the default without using the GUID.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtraSettings
A hashtable of extra settings to set in the profile.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InitialCols
The number of columns to launch with.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InitialRows
The number of rows to launch with.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequestedTheme
Sets the theme of the tab bar. Possible values: "light", "dark", "system"

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: light, dark, system

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowTabsInTitlebar
When set to 'true', the tabs are moved into the titlebar and the titlebar disappears. When set to 'false', the titlebar sits above the tabs.

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

### -ShowTerminalTitleInTitlebar
Show the current console application's title in the MS Terminal title bar.

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

### None

## OUTPUTS

### None

## NOTES

## RELATED LINKS
