function Import-Iterm2ColorScheme {
    [cmdletbinding(DefaultParameterSetName = 'Path')]
    param(
        [parameter(
            Mandatory = $true,
            ParameterSetName  = 'Path',
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]]$Path,

        [parameter(
            Mandatory = $true,
            ParameterSetName = 'LiteralPath',
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('PSPath')]
        [string[]]$LiteralPath,

        $Name
    )
    process {
                #FIXME: Remove When Refactored
                throwuser $QuickTypeNotImplementedException
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $ResolvedPaths = Resolve-Path -Path $Path
        } elseif ($PSCmdlet.ParameterSetName -eq 'LiteralPath') {
            $ResolvedPaths = Resolve-Path -LiteralPath $LiteralPath
        }

        $ResolvedPaths | ForEach-Object {
            $FileInfo = [System.IO.FileInfo]$_.Path
            $Colors = ConvertFrom-Iterm2ColorScheme -LiteralPath $_.Path -AsHashtable
            if(!$PSBoundParameters.ContainsKey("Name")) {
                $Name = $FileInfo.BaseName
            }
            Add-MSTerminalColorScheme -Name $Name @Colors
        }
    }
}