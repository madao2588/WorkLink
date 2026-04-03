$ErrorActionPreference = "Stop"

$packageRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$logsDir = Join-Path $packageRoot "logs"
$backendPidFile = Join-Path $logsDir "backend.pid"

if (Test-Path $backendPidFile) {
    $rawPid = Get-Content $backendPidFile -ErrorAction SilentlyContinue
    if ($rawPid) {
        try {
            Stop-Process -Id ([int]$rawPid) -Force -ErrorAction Stop
        } catch {
            # If the recorded pid is stale, fall back to process name lookup below.
        }
    }
    Remove-Item $backendPidFile -Force -ErrorAction SilentlyContinue
}

Get-Process WorkLinkBackend -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
