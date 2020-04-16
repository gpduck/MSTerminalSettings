#This function dynamically generates types and is used for strong type definition
function Build-TerminalSettingsAssembly {
    param (
        #Output the assembly to a specified DLL location
        $OutputAssembly
    )
    $ReferencedAssemblies = @(
        ([newtonsoft.json.jsonpropertyattribute].assembly)
        'System.Collections, Version=4.1.2.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
        'netstandard, Version=2.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'
        'System.Runtime.Extensions, Version=4.2.2.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
    )

    $AddTypeParams = @{
        ReferencedAssemblies = $referencedAssemblies
        Path = "$PSSCRIPTROOT/../src/TerminalSettings.cs"
    }
    if ($OutputAssembly) {$AddTypeParams.OutputAssembly = $OutputAssembly}
    Write-Debug "Compiling $($AddTypeParams.Path)"
    Add-Type @AddTypeParams
}