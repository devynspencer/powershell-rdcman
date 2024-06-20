function Close-RDCMan {
    param (
        [switch]
        $Force
    )

    $Running = Get-Process -Name RDCMan -ErrorAction SilentlyContinue

    foreach ($Process in $Running) {
        $null = $Process.CloseMainWindow()

        # Forcefully close remaining processes, if specified
        if ($Force -and (Get-Process -Id $Process.Id -ErrorAction SilentlyContinue)) {
            Write-Verbose "Process [$($Process.Id)] with title $($Process.MainWindowTitle) did not close gracefully, stopping [$($Process.Id)"

            Stop-Process -Id $Process.Id -Force
        }
    }
}
