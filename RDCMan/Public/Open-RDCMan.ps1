function Open-RDCMan {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        # Path to the RDCMan configuration file
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        $ConfigPath = $env:RDCMAN_CONFIG_PATH ?? (Get-Secret -Name RDCManConfigPath -AsPlainText),

        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        $ExecPath = $env:RDCMAN_PATH ?? 'C:\Program Files\Microsoft\Remote Desktop Connection Manager\RDCMan.exe',

        # Connect to servers from previous session without prompting
        [Parameter(ParameterSetName = 'Reconnect')]
        [switch]
        $Reconnect,

        # Do not prompt to reconnect to servers from previous session
        [Parameter(ParameterSetName = 'NoReconnect')]
        [switch]
        $NoReconnect,

        # Start RDCMan with a clean session, resetting all settings and with no configuration file loaded
        [switch]
        $Clean,

        # List of servers to open on startup. See: https://learn.microsoft.com/en-us/sysinternals/downloads/rdcman#command-line
        $Servers = @()
    )

    # Build base parameters for `Start-Process`
    $StartParams = @{
        FilePath = $ExecPath
        WindowStyle = 'Maximized'
        ArgumentList = @("`"$ConfigPath`"")
    }

    # Handle optional startup parameters
    if ($PSBoundParameters.ContainsKey('Servers')) {
        $StartParams.ArgumentList += "/c $($Servers -join ',')"
    }

    if ($Reconnect) {
        $StartParams.ArgumentList += '/reconnect'
    }

    if ($NoReconnect) {
        $StartParams.ArgumentList += '/noreconnect'
    }

    # Start RDCMan with specified parameters
    Start-Process @StartParams
}
