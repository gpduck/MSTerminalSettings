using namespace System.Management.Automation
using namespace System.Collections.ObjectModel
function Get-ObjectDynamicParameters {
    param(
        #The type to retrieve the dynamic parameters
        [Parameter(Mandatory)][Type]$Type,
        #Which Properties should be Mandatory
        [String[]]$MandatoryParameters,
        #If some parameters need to be positional, specify them in the position order that is required
        [String[]]$ParameterOrder,
        #Exclude some parameters, if present
        [String[]]$Exclude,
        #Rename parameters in hashtable syntax @{Name='NewName'}
        [Hashtable]$Rename
    )
    $dynamicParams = [RuntimeDefinedParameterDictionary]::new()
    foreach ($PropertyItem in $Type.declaredproperties) {
        if ($PropertyItem.Name -in $Exclude) {continue}
        if ($Rename.($PropertyItem.Name)) {
            $PropertyItem = [PSCustomObject]@{
                Name = $Rename.($PropertyItem.Name)
                PropertyType = $PropertyItem.PropertyType
            }
        }

        $attributes = [Collection[Attribute]]@()
        if ($PropertyItem.Name -in $MandatoryParameters) {
            $attributes.Add([ParameterAttribute]@{Mandatory=$true})
        } else {
            $attributes.Add([ParameterAttribute]@{})
        }

        #Convert Booleans to switches
        if ([String]$PropertyItem.PropertyType -match 'bool') {
            $PropertyType = [switch]
        } else {
            $PropertyType = $PropertyItem.PropertyType
        }

        $Param = [runtimedefinedparameter]::new(
            $PropertyItem.Name,         #string name
            $PropertyType,              #type ParameterType
            $attributes                 #System.Collections.ObjectModel.Collection[System.Attribute] attributes
        )
        $dynamicParams[$Param.Name] = $Param
    }
    $i=0
    $ParameterOrder.foreach{
        $dynamicParams[$PSItem].Attributes[0].Position = $i
        $i++
    }

    return $dynamicParams
}