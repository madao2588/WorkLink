param(
    [string]$Version = "1.0.0",
    [switch]$SkipTests
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$backendDir = Join-Path $repoRoot "backend"
$backendVenv = Join-Path $backendDir ".venv"
$backendPython = Join-Path $backendVenv "Scripts\python.exe"
$backendDist = Join-Path $backendDir "dist\WorkLinkBackend"
$bundleName = "WorkLink-windows-$Version"
$bundleRoot = Join-Path $repoRoot "dist\windows\$bundleName"
$zipPath = Join-Path $repoRoot "dist\windows\$bundleName.zip"
$windowsReleaseDir = Join-Path $repoRoot "build\windows\x64\runner\Release"

function Invoke-Step {
    param(
        [string]$Description,
        [scriptblock]$Action
    )

    Write-Host "==> $Description"
    & $Action
}

function Ensure-BackendVenv {
    if (!(Test-Path $backendPython)) {
        Invoke-Step "Creating backend virtual environment" {
            python -m venv $backendVenv
        }
    }

    Invoke-Step "Installing backend packaging dependencies" {
        & $backendPython -m pip install --upgrade pip
        & $backendPython -m pip install -r (Join-Path $backendDir "requirements.txt") pyinstaller
    }
}

Invoke-Step "Flutter dependencies" {
    Set-Location $repoRoot
    flutter pub get
}

Ensure-BackendVenv

if (!$SkipTests) {
    Invoke-Step "Flutter analyze" {
        Set-Location $repoRoot
        flutter analyze
    }

    Invoke-Step "Flutter tests" {
        Set-Location $repoRoot
        flutter test
    }

    Invoke-Step "Backend tests" {
        Set-Location $backendDir
        & $backendPython -m pytest
    }
}

Invoke-Step "Preparing backend demo database" {
    Set-Location $backendDir
    Remove-Item (Join-Path $backendDir "worklink.duckdb") -Force -ErrorAction SilentlyContinue
    Remove-Item (Join-Path $backendDir "worklink.duckdb.wal") -Force -ErrorAction SilentlyContinue
    $env:APP_ENV = "development"
    $env:APP_DEBUG = "false"
    $env:APP_EXPOSE_INTERNAL_ERRORS = "false"
    $env:DATABASE_URL = "duckdb:///./worklink.duckdb"
    & $backendPython -m app.scripts.init_db --seed
    Remove-Item Env:APP_ENV -ErrorAction SilentlyContinue
    Remove-Item Env:APP_DEBUG -ErrorAction SilentlyContinue
    Remove-Item Env:APP_EXPOSE_INTERNAL_ERRORS -ErrorAction SilentlyContinue
    Remove-Item Env:DATABASE_URL -ErrorAction SilentlyContinue
}

Invoke-Step "Building Windows desktop frontend" {
    Set-Location $repoRoot
    if (Test-Path (Join-Path $repoRoot "build\windows")) {
        Remove-Item (Join-Path $repoRoot "build\windows") -Recurse -Force
    }
    flutter build windows --release --build-name $Version --dart-define=WORKLINK_API_BASE_URL=http://127.0.0.1:8000/api/v1
}

Invoke-Step "Packaging backend executable" {
    Set-Location $backendDir
    if (Test-Path (Join-Path $backendDir "build")) {
        Remove-Item (Join-Path $backendDir "build") -Recurse -Force
    }
    if (Test-Path (Join-Path $backendDir "dist")) {
        Remove-Item (Join-Path $backendDir "dist") -Recurse -Force
    }

    & $backendPython -m PyInstaller `
        --noconfirm `
        --clean `
        --onedir `
        --name WorkLinkBackend `
        --hidden-import duckdb_engine `
        --hidden-import pytz `
        --collect-submodules passlib.handlers `
        --collect-submodules sqlalchemy.dialects `
        --collect-binaries duckdb `
        (Join-Path $backendDir "run_packaged.py")
}

Invoke-Step "Assembling portable bundle" {
    if (Test-Path $bundleRoot) {
        Remove-Item $bundleRoot -Recurse -Force
    }
    if (Test-Path $zipPath) {
        Remove-Item $zipPath -Force
    }

    New-Item -ItemType Directory -Path $bundleRoot | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $bundleRoot "app") | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $bundleRoot "backend") | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $bundleRoot "logs") | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $bundleRoot "scripts") | Out-Null

    Copy-Item (Join-Path $windowsReleaseDir "*") (Join-Path $bundleRoot "app") -Recurse -Force
    Copy-Item (Join-Path $backendDist "*") (Join-Path $bundleRoot "backend") -Recurse -Force
    Copy-Item (Join-Path $backendDir "worklink.duckdb") (Join-Path $bundleRoot "backend\worklink.duckdb") -Force
    Copy-Item (Join-Path $repoRoot "README.md") (Join-Path $bundleRoot "README.md") -Force

    $frontendExe = Join-Path $bundleRoot "app\WorkLink.exe"
    if (!(Test-Path $frontendExe)) {
        $builtExe = Get-ChildItem (Join-Path $bundleRoot "app") -Filter "*.exe" | Select-Object -First 1
        if ($null -eq $builtExe) {
            throw "No frontend executable was found in $windowsReleaseDir"
        }
        Rename-Item -Path $builtExe.FullName -NewName "WorkLink.exe"
    }

    Copy-Item (Join-Path $repoRoot "packaging\windows\Start WorkLink.bat") (Join-Path $bundleRoot "Start WorkLink.bat") -Force
    Copy-Item (Join-Path $repoRoot "packaging\windows\Stop WorkLink Backend.bat") (Join-Path $bundleRoot "Stop WorkLink Backend.bat") -Force
    Copy-Item (Join-Path $repoRoot "packaging\windows\scripts\launch_worklink.ps1") (Join-Path $bundleRoot "scripts\launch_worklink.ps1") -Force
    Copy-Item (Join-Path $repoRoot "packaging\windows\scripts\stop_worklink_backend.ps1") (Join-Path $bundleRoot "scripts\stop_worklink_backend.ps1") -Force

    Compress-Archive -Path (Join-Path $bundleRoot "*") -DestinationPath $zipPath -Force
}

Write-Host ""
Write-Host "Portable bundle ready:"
Write-Host "  Folder: $bundleRoot"
Write-Host "  Zip:    $zipPath"
