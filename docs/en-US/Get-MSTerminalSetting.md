---
external help file: MSTerminalSettings-help.xml
Module Name: MSTerminalSettings
online version:
schema: 2.0.0
---

# Get-MSTerminalSetting

## SYNOPSIS
Returns the current top-level settings for MS Terminal.

## SYNTAX

```
Get-MSTerminalSetting [-Force] [<CommonParameters>]
```

## DESCRIPTION
Returns the current top-level settings for MS Terminal.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-MSTerminalSetting

defaultProfile                  : {38782937-4ba3-4696-9ae1-0bfc33c60e62}
initialRows                     : 30
initialCols                     : 120
alwaysShowTabs                  : True
showTerminalTitleInTitlebar     : True
showTabsInTitlebar              : False
requestedTheme                  : system
keybindings                     : {@{keys=System.Object[]; command=closeTab},...}
```

Returns the current top-level settings for MS Terminal.

## PARAMETERS

### -Force
*** Deprecated as of Terminal 0.2.1715.0 and will be removed in a future release of the module ***

Use to force output to include the fully deserialized profiles.json file.  If not specified, the 'profiles' and 'schemes' elements will be omitted.



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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
