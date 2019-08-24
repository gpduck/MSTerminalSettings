function CopyHashtable {
    param(
        [Parameter(Mandatory=$true)]
        $Source,

        [Parameter(Mandatory=$true)]
        $Destination,

        $Keys
    )
    if(!$Keys) {
        $Keys = $Source.Keys
    }
    $Keys | ForEach-Object {
        if($Source.ContainsKey($_)) {
            $Key = $_
            $NewValue = $Source[$_]
            switch($NewValue.GetType().Fullname) {
                "System.String" {
                    if([String]::IsNullOrEmpty($NewValue)) {
                        #Build a new collection so remove doesn't modify during enumeration
                        $Keys = $Destination.Keys | ForEach-Object {$_}
                        #Manually enumerate and compare so we get case-insensitive comparisons
                        $Keys | ForEach-Object {
                            if($_ -eq $Key) {
                                $Destination.Remove($_)
                            }
                        }
                    } else {
                        $Destination[$Key] = $NewValue
                    }
                }
                "System.Management.Automation.SwitchParameter" {
                    $Destination[$Key] = $NewValue.IsPresent
                }
                default {
                    $Destination[$Key] = $NewValue
                }
            }
        }
    }
}