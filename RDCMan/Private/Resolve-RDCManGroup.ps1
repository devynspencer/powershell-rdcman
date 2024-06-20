function Resolve-RDCManGroup {
    param (
        # TODO: Validate the parameter type ([xml] was too restrictive)
        [Parameter(Mandatory)]
        $Group,

        # Parent group name for recursive calls
        $ParentGroup
    )

    Write-Verbose "[Get-RDCManGroup] Processing group [$($Group.properties.name)]..."

    # Build the group object
    $GroupObj = @{
        Name = $Group.properties.name
    }

    # Build the fully-qualified group name from previous levels
    if ($PSBoundParameters.ContainsKey('ParentGroup')) {
        # TODO: Find a (much) more elegant way to prepend a slash to the root group name
        $GroupObj.FullName = "/$ParentGroup/$($Group.properties.name)" -replace '//', '/'
    }

    # If the group contains credential profiles, process them
    if ($Group.credentialsProfiles) {
        Write-Verbose "[Get-RDCManGroup] Processing [$($Group.credentialsProfiles.Count)] credential profiles of group [$($GroupObj.Name)]..."

        $GroupObj.Credentials = foreach ($CredentialProfile in $Group.credentialsProfiles.credentialsProfile) {
            [pscustomobject] @{
                ProfileName = $CredentialProfile.profileName.'#text'
                Inherited = $CredentialProfile.inherit
                Scope = $CredentialProfile.profileName.scope
                UserName = $CredentialProfile.userName
                Password = $CredentialProfile.password
                Domain = $CredentialProfile.domain
            }
        }
    }

    # If the group contains logon credentials, process them
    if ($Group.logonCredentials) {
        Write-Verbose "[Get-RDCManGroup] Processing [$($Group.logonCredentials.Count)] logon credentials of group [$($GroupObj.Name)]..."

        $GroupObj.LogonCredentials = foreach ($LogonCredential in $Group.logonCredentials) {
            [pscustomobject] @{
                Inherited = $LogonCredential.inherit
                Scope = $LogonCredential.profileName.scope
                UserName = $LogonCredential.profileName.'#text'
            }

        }
    }

    # If the group contains server entries, process them
    if ($Group.server) {
        Write-Verbose "[Get-RDCManGroup] Processing servers of group [$($GroupObj.Name)]..."

        $GroupObj.Servers = foreach ($Server in $Group.server) {
            Write-Verbose "[Get-RDCManGroup] Processing server [$($Server.properties.name)]"

            $OutputObj = [ordered] @{
                GroupName = $GroupObj.Name
                Name = $Server.properties.name
                DisplayName = $Server.properties.displayName ?? $Server.properties.name
                Comment = $Server.properties.comment ?? ''
            }

            # Use display name for the full name of the entry, as name could be just an IP address
            $OutputObj.FullName = "$($GroupObj.FullName)/$($OutputObj.DisplayName)"

            # Return the server object
            [pscustomobject] $OutputObj
        }
    }

    # If the group contains subgroups, process them
    if ($Group.group) {
        Write-Verbose "[Get-RDCManGroup] Processing [$($Group.group.Count)] subgroups of group [$($GroupObj.Name)]..."

        $GroupObj.Groups = foreach ($SubGroup in $Group.group) {
            Resolve-RDCManGroup -ParentGroup $GroupObj.FullName -Group $SubGroup
        }
    }

    # Return the group object
    [pscustomobject] $GroupObj
}
