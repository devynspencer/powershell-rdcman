. "$PSScriptRoot\..\Private\Resolve-RDCManGroup.ps1"

function Get-RDCManServer {
    [CmdletBinding()]
    param (
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        $Path = $env:RDCMAN_CONFIG_PATH ?? (Get-Secret -Name 'RDCMAN_CONFIG_PATH' -AsPlainText)
    )

    # Load the configuration
    $Config = [xml] (Get-Content -Path $Path -Raw)

    Resolve-RDCManGroup -Group $Config.RDCMan.file -Flatten
}
