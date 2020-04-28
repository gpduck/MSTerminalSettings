using namespace WindowsTerminal
function Add-TerminalSettingsParams {
    param (
        [Parameter(Mandatory, ValueFromPipeline)][RuntimeDefinedParameterDictionary]$InputObject,
        #Which Type passed from the dynamic parameters
        [Type]$Type,

        [ValidateNotNullOrEmpty()]
        [IO.FileInfo]
        $SchemaPath = (Join-Path (Split-Path $PSScriptRoot) 'src/TerminalSettingsSchema.json')
    )

    begin {
        #Gather important schema dictionaries and settings
        $WTSchema = (Import-JsonWithComments $SchemaPath).definitions
    }

    process {
        $definitionName = switch ($Type) {
            ([ProfileList]) {
                'profile'
                break
            }
            ([SchemeList]) {
                'scheme'
                break
            }
            ([TerminalSettings]) {
                'globals'
                break
            }
            default {
                $PSItem.Name
            }
        }
        $propertyList = $WTSchema.$definitionName.properties
        foreach ($paramName in $InputObject.keys) {
            $paramItem = $propertyList.$ParamName
            $paramAttributes = $inputObject[$paramName].Attributes
            #$paramAttributes[0].ValueFromPipelineByPropertyName = $true
            if ($paramItem.description) {
                $parameterAttribute = $inputObject[$paramName].Attributes.where{$PSItem -is [ParameterAttribute]}
                $parameterAttribute[0].HelpMessage = $paramItem.description
            }
            #TODO: Multiple type struct support
            if (($paramItem.maximum -or $paramItem.minimum) -and $paramItem.Type.Count -eq 1) {
                if ('integer' -in $ParamItem.Type) {
                    $maxValue = [long]::MaxValue
                    $minValue = [long]::MinValue
                    $paramMax = [long]$paramItem.maximum
                    $paramMin = [long]$paramItem.minimum
                } elseif ('number' -in $ParamItem.Type) {
                    $maxValue = [decimal]::MaxValue
                    $minValue = [decimal]::MinValue
                    $paramMax = [decimal]$paramItem.maximum
                    $paramMin = [decimal]$paramItem.minimum
                }

                $minimum = if ($null -eq $paramItem.minimum) {$minValue} else {$paramMin}
                $maximum =  if ($null -eq $paramItem.maximum) {$maxValue} else {$paramMax}
                $paramAttributes.Add([ValidateRange]::new($minimum,$maximum))
            }
            if ($ParamItem.minlength -or $paramItem.maxlength) {
                $minLength = if ($null -eq $paramItem.minLength) {[int]::MinValue} else {$paramItem.minlength}
                $maxLength = if ($null -eq $paramItem.maxLength) {[int]::MaxValue} else {$paramItem.maxlength}
                $paramAttributes.Add([ValidateLength]::new($minLength,$maxLength))
            }
            if ($ParamItem.'$ref' -match '^#/definitions/(\w+)$') {
                if ($WTSchema.($matches[1]).pattern) {
                    $paramAttributes.Add([ValidatePattern]::new($WTSchema.($matches[1]).pattern))
                }
            }
        }
    }
}