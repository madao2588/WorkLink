$ErrorActionPreference = "Stop"

$packageRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$backendExe = Join-Path $packageRoot "backend\WorkLinkBackend.exe"
$logsDir = Join-Path $packageRoot "logs"
$backendStdout = Join-Path $logsDir "backend.out.log"
$backendStderr = Join-Path $logsDir "backend.err.log"
$backendPidFile = Join-Path $logsDir "backend.pid"
$healthUrl = "http://127.0.0.1:8000/api/v1/health"
$frontendDir = Join-Path $packageRoot "app"
$frontendExe = Join-Path $frontendDir "WorkLink.exe"

if (!(Test-Path $frontendExe)) {
    $fallbackExe = Get-ChildItem $frontendDir -Filter "*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($fallbackExe) {
        $frontendExe = $fallbackExe.FullName
    }
}

if (!(Test-Path $frontendExe)) {
    throw "WorkLink frontend was not found at $frontendExe"
}

if (!(Test-Path $backendExe)) {
    throw "WorkLink backend was not found at $backendExe"
}

New-Item -ItemType Directory -Path $logsDir -Force | Out-Null

function Test-BackendHealth {
    try {
        $response = Invoke-WebRequest -UseBasicParsing -Uri $healthUrl -TimeoutSec 2
        return $response.StatusCode -eq 200
    } catch {
        return $false
    }
}

if (!(Test-BackendHealth)) {
    if (Test-Path $backendPidFile) {
        Remove-Item $backendPidFile -Force
    }

    $process = Start-Process `
        -FilePath $backendExe `
        -WorkingDirectory (Split-Path -Parent $backendExe) `
        -WindowStyle Hidden `
        -RedirectStandardOutput $backendStdout `
        -RedirectStandardError $backendStderr `
        -PassThru

    Set-Content -Path $backendPidFile -Value $process.Id -Encoding ascii

    $deadline = (Get-Date).AddSeconds(20)
    while ((Get-Date) -lt $deadline) {
        if (Test-BackendHealth) {
            break
        }
        Start-Sleep -Milliseconds 500
    }
}

if (!(Test-BackendHealth)) {
    throw "WorkLink backend failed to start. Check logs in $logsDir"
}

Start-Process -FilePath $frontendExe -WorkingDirectory (Split-Path -Parent $frontendExe)
