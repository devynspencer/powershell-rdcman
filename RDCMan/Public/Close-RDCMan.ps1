function Close-RDCMan {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [switch]
        $Force
    )

    $Running = Get-Process -Name RDCMan -ErrorAction SilentlyContinue

    foreach ($Process in $Running) {
        # Attempt to close gracefully
        if ($PSCmdlet.ShouldProcess("RDCMan window [$($Process.Id)] with title $($Process.MainWindowTitle)", 'Close Window')) {
            $null = $Process.CloseMainWindow()
        }

        # Forcefully close remaining processes, if specified
        if ($Force -and (Get-Process -Id $Process.Id -ErrorAction SilentlyContinue)) {
            Write-Verbose "Process [$($Process.Id)] with title $($Process.MainWindowTitle) did not close gracefully, stopping [$($Process.Id)"

            if ($PSCmdlet.ShouldProcess("RDCMan process [$($Process.Id)] with title $($Process.MainWindowTitle)", 'Stop Process')) {
                Stop-Process -Id $Process.Id -Force
            }
        }
    }
}
