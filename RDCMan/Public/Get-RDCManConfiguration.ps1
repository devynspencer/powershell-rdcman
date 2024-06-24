. "$PSScriptRoot\..\Private\Resolve-RDCManGroup.ps1"

function Get-RDCManConfiguration {
    param (
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        $Path = $env:RDCMAN_CONFIG_PATH ?? (Get-Secret -Name 'RDCMAN_CONFIG_PATH' -AsPlainText)
    )

    # TODO: Warn if file open, maybe prompt to close (credentials aren't accessible if open)

    # Load the configuration
    $Config = [xml] (Get-Content -Path $Path -Raw)

    # Process the configuration recursively
    Resolve-RDCManGroup -Group $Config.RDCMan.file -Verbose
}
