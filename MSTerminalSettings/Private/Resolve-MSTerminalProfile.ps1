using namespace WindowsTerminal
function Resolve-MSTerminalProfile {
    param (
        [Parameter(Mandatory,ValueFromPipeline)][Alias('Name','Guid')]$InputObject
    )
    process{ foreach ($ProfileItem in $InputObject) {
        switch ($true) {
            ($ProfileItem -is [Profile]) {break}
            ($ProfileItem -is [ProfileList]) {break}
            ($null -ne ($ProfileItem -as [Guid])) {$ProfileItem=Get-MSTerminalProfile -Guid $ProfileItem;break}
            ($null -ne ($ProfileItem -as [String])) {$ProfileItem=Get-MSTerminalProfile -Name $ProfileItem;break}
        }
        $ProfileItem
    }}
}
