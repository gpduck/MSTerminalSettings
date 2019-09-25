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
 [-SnapOnInput] [-ColorScheme <String>] [-ColorTable <String[]>] [-CursorColor <String>]
 [-CursorShape <String>] [-CursorHeight <Int32>] [-FontFace <String>] [-StartingDirectory <String>]
 [-FontSize <Int32>] [-Background <String>] [-Foreground <String>] [-AcrylicOpacity <Single>] [-UseAcrylic]
 [-BackgroundImage <String>] [-BackgroundImageAlignment <String>] [-BackgroundImageOpacity <Double>]
 [-BackgroundImageStretchMode <String>] [-Hidden] [-ScrollbarState <String>] [-Source <String>]
 [-NewGuid <Guid>] [-TabTitle <String>] [-CloseOnExit] [-Icon <String>] [-Padding <Int32[]>]
 [-Clear <String[]>] [-ExtraSettings <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### InputObject
```
Set-MSTerminalProfile -InputObject <Object> [-CommandLine <String>] [-MakeDefault] [-HistorySize <Int32>]
 [-SnapOnInput] [-ColorScheme <String>] [-ColorTable <String[]>] [-CursorColor <String>]
 [-CursorShape <String>] [-CursorHeight <Int32>] [-FontFace <String>] [-StartingDirectory <String>]
 [-FontSize <Int32>] [-Background <String>] [-Foreground <String>] [-AcrylicOpacity <Single>] [-UseAcrylic]
 [-BackgroundImage <String>] [-BackgroundImageAlignment <String>] [-BackgroundImageOpacity <Double>]
 [-BackgroundImageStretchMode <String>] [-Hidden] [-ScrollbarState <String>] [-Source <String>]
 [-NewGuid <Guid>] [-TabTitle <String>] [-CloseOnExit] [-Icon <String>] [-Padding <Int32[]>]
 [-Clear <String[]>] [-ExtraSettings <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
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

### -Background
Sets the background color of the profile. Overrides "background" set in color scheme if "colorScheme" is set.

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

### -BackgroundImage
The path to an image to use as the background for the terminal window.  This value is ignored if UseAcrylic is enabled.

Ex: "file:///c:/users/USER/Pictures/background.jpg"

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

### -BackgroundImageAlignment
Sets how the background image aligns to the boundaries of the window.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: center, left, top, right, bottom, topLeft, topRight, bottomLeft, bottomRight

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackgroundImageOpacity
The background image opacity, a number between 0 and 1.

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackgroundImageStretchMode
How to resize the background image.

Fill - The background is resized to fill the window.  The aspect ratio is not preserved.
None - The background image is kept at it's original dimensions.
Uniform - The background image is resized to fill the window, preserving the aspect ratio.
UniformToFill - The background image is resized to fill the window, clipping the image to make it fit the window and preserving the aspect ratio.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: none, fill, uniform, uniformToFill

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Clear
A list of profile settings to remove from the profile.  This takes precedence over any other value being set by this cmdlet.

```yaml
Type: String[]
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

### -ColorTable
Array of colors used in the profile if colorscheme is not set. Colors use hex color format: "#rrggbb". Ordering is as follows: [black, red, green, yellow, blue, magenta, cyan, white, bright black, bright red, bright green, bright yellow, bright blue, bright magenta, bright cyan, bright white]

```yaml
Type: String[]
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

### -CursorHeight
Sets the height of the cursor. Only works when "cursorShape" is set to "vintage". Accepts values from 25-100.

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

### -CursorShape
The cursor shape.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: bar, emptyBox, filledBox, underscore, vintage

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtraSettings
A hashtable of additional settings to set in the profile. These entries are not validated and override other parameter settings, use at your own risk!


```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

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

### -Foreground
Sets the foreground color of the profile. Overrides foreground set in color scheme if colorscheme is set. Uses hex color format: "#rrggbb".

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

### -Hidden
If set to true, the profile will not appear in the list of profiles. This can be used to hide default profiles and dynamicially generated profiles, while leaving them in your settings file.

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

### -NewGuid
A new GUID to use to identify this profile.

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: False
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

### -ScrollbarState
Defines the visibility of the scrollbar. Possible values: "visible", "hidden"

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: visible, hidden

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

### -Source
The source for dynamically generated profiles.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Windows.Terminal.Azure, Windows.Terminal.PowershellCore, Windows.Terminal.Wsl,

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

### -TabTitle
Overrides default title of the tab.

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
