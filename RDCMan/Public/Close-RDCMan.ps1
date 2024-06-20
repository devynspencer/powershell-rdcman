function Close-RDCMan {
    param (
        [switch]
        $Force
    )

    $Running = Get-Process -Name RDCMan -ErrorAction SilentlyContinue

    foreach ($Process in $Running) {
        if ($Force) {
            Write-Verbose "[Close-RDCMan] Stopping RDCMan process [$($Process.Id) with title $($Process.MainWindowTitle) ..."
            Stop-Process -Id $Process.Id -Force
        }

        else {
            Write-Verbose "[Close-RDCMan] Closing RDCMan process [$($Process.Id) with title $($Process.MainWindowTitle)"
            $null = $Process.CloseMainWindow()
        }
    }
}
