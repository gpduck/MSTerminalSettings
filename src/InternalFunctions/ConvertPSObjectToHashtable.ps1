function ConvertPSObjectToHashtable
{
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )

    process
    {
        if ($null -eq $InputObject) { return $null }

        if ($InputObject -is [System.Array] -and $InputObject -isnot [string])
        {
            $collection = @($InputObject | ConvertPSObjectToHashtable)

            ,$collection
        }
        elseif ($InputObject -is [System.Management.Automation.PSCustomObject])
        {
            $hash = [ordered]@{}

            foreach ($property in $InputObject.PSObject.Properties)
            {
                $hash[$property.Name] = ConvertPSObjectToHashtable $property.Value
            }

            $hash
        }
        else
        {
            $InputObject
        }
    }
}