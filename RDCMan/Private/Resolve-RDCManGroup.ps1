function Resolve-RDCManGroup {
    param (
        # TODO: Validate the parameter type ([xml] was too restrictive)
        # The XML object representing the group (or subgroup) to process, for example:
        #   $Config = [xml] (Get-Content -Path config.rdg)
        #   Resolve-RDCManGroup -Group $Config.file.group
        [Parameter(Mandatory)]
        $Group,

        # Include only server objects in the output
        [switch]
        $Flatten,

        # Parent group name for recursive calls. This should be the "full" name of the Parent
        # group, for example: "/example.com/Application Servers/Application Name". Specifying the
        # parent group is useful in recursive calls to subgroups, building a fully-qualified group
        # name to each server object.
        $ParentGroupName = '/'
    )

    Write-Verbose "[Get-RDCManGroup] Processing group [$($Group.properties.name)]..."

    # Build the group object
    $GroupObj = @{
        Name = $Group.properties.name
    }

    # Build the fully-qualified group name from previous levels
    $GroupObj.FullName = "$ParentGroupName/$($Group.properties.name)" -replace '//', '/'

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

        $ChildServers = foreach ($Server in $Group.server) {
            Write-Verbose "[Get-RDCManGroup] Processing server [$($Server.properties.name)]"

            # Build the output object based on available properties
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

        # Return the servers as a flat list or as a property of the group object, depending on the Flatten switch
        if ($Flatten) {
            $ChildServers
        }

        else {
            $GroupObj.Servers = $ChildServers
        }
    }

    # If the group contains subgroups, process them
    if ($Group.group) {
        Write-Verbose "[Get-RDCManGroup] Processing [$($Group.group.Count)] subgroups of group [$($GroupObj.Name)]..."

        # Ensure optional parameters are passed down to recursive calls
        $ResolveParams = @{
            ParentGroupName = $GroupObj.FullName
        }

        if ($Flatten) {
            $ResolveParams.Flat = $true
        }

        # Recursively process each subgroup
        foreach ($SubGroup in $Group.group) {
            $OutputObj = Resolve-RDCManGroup @ResolveParams -Group $SubGroup

            # Return the subgroup object (containing servers) if Flatten specified
            if ($Flatten) {
                $OutputObj
            }

            # Otherwise add the subgroup to the parent object
            else {
                $GroupObj.Groups += $OutputObj
            }
        }
    }

    # Return the entire configuration object
    if (!$Flatten) {
        [pscustomobject] $GroupObj
    }
}
