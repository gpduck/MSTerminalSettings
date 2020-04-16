using namespace WindowsTerminal
function Get-MSTerminalProfile {
    [CmdletBinding(DefaultParameterSetName='Filter')]
    param (
        [Parameter(ValueFromPipeline)][ValidateNotNull()][TerminalSettings]$TerminalConfig = (Get-MSTerminalConfig),
        #Return a profile object representing the "defaults" section for the default settings for all profiles
        [Parameter(Mandatory,ParameterSetName='DefaultSettings')][Switch]$DefaultSettings,
        #Return the default configured profile
        [Parameter(Mandatory,ParameterSetName='Default')][Switch]$Default,
        #Return the current profile, if relevant
        [Parameter(Mandatory,ParameterSetName='Current')][Switch]$Current
    )
    dynamicParam {
        $dynamicParams = Get-ObjectDynamicParameters 'WindowsTerminal.ProfileList' -ParameterOrder Name,guid
        Add-TerminalSettingsParams $dynamicParams -Type 'WindowsTerminal.ProfileList'
        $dynamicParams.keys.foreach{
            $dynamicParams.$PSItem.attributes[0].ParameterSetName = 'Filter'
        }
        $dynamicParams
    }
    process {
        $WTProfile = switch ($PSCmdlet.ParameterSetName) {
            'DefaultSettings' {$TerminalConfig.Profiles.Defaults;break}
            'Default' {
                $TerminalConfig.Profiles.List.where{
                    [Guid]($_.Guid) -eq [Guid]$TerminalConfig.DefaultProfile
                }
                break
            }
            'Current' {
                Find-CurrentTerminalProfile
                break
            }
            Default {
                $filters = [HashTable]$PSBoundParameters
                $PSBoundParameters.keys.foreach{
                    if ($PSItem -notin [ProfileList].DeclaredProperties.Name) { [void]$filters.remove($PSItem) }
                }
                $ProfileList = $TerminalConfig.Profiles.List
                foreach ($filterItem in $filters.keys) {
                    $ProfileList = $ProfileList.where{$PSItem.$FilterItem -like $Filters.$FilterItem}
                }
                $ProfileList
            }
        }

        #Add the parent to the item to reference later for saving
        $WTProfile | Add-Member -NotePropertyName 'TerminalConfig' -NotePropertyValue $TerminalConfig -Force -PassThru
    }
}