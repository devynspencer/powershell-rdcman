function Resolve-RDCManGroup {
    param (
        # TODO: Validate the parameter type ([xml] was too restrictive)
        [Parameter(Mandatory)]
        $Group
    )

    # Build the group object
    Write-Verbose "[Get-RDCManGroup] Processing group [$($Group.properties.name)]..."

    $GroupObj = @{
        Name = $Group.properties.name
    }


    # If the group contains server entries, process them
    if ($Group.server) {
        Write-Verbose "[Get-RDCManGroup] Processing servers of group [$($GroupObj.Name)]..."

        $GroupObj.Servers = foreach ($Server in $Group.server) {
            Write-Verbose "[Get-RDCManGroup] Processing server [$($Server.properties.name)]"

            [pscustomobject] @{
                Name = $Server.properties.name
                DisplayName = $Server.properties.displayName
            }
        }
    }

    # If the group contains subgroups, process them
    if ($Group.group) {
        Write-Verbose "[Get-RDCManGroup] Processing [$($Group.group.Count)] subgroups of group [$($GroupObj.Name)]..."

        $GroupObj.Groups = foreach ($SubGroup in $Group.group) {
            Resolve-RDCManGroup -Group $SubGroup
        }
    }

    # Return the group object
    [pscustomobject] $GroupObj
}
