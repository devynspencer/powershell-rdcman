. "$PSScriptRoot\..\Private\Resolve-RDCManGroup.ps1"

function Get-RDCManConfiguration {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Path
    )

    # TODO: Warn if file open, maybe prompt to close (credentials aren't accessible if open)

    # Load the configuration
    $Config = [xml] (Get-Content -Path $Path -Raw)

    # Process the configuration recursively
    Resolve-RDCManGroup -Group $Config.RDCMan.file -Verbose
}
