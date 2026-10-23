# =====================================================================
# First-time setup for a repository created from this template (Windows)
#
# Usage (run from the repository root):
#   powershell -ExecutionPolicy Bypass -File tools\setup.ps1
#
# What it does:
#   1. Creates the Python environment (.venv) with uv
#   2. Writes _environment.local so Quarto uses the .venv Python
#   3. Shows what Quarto detects (Python/Jupyter) and the Jupyter kernels
#
# Jupyter is run as "python -m ...", not as jupyter.exe. Windows Smart App
# Control may block the unsigned .exe wrappers that uv puts in .venv\Scripts.
# With Smart App Control on, the base Python should be the signed python.org
# build (see the setup guide).
#
# This file is intentionally ASCII-only so that Windows PowerShell 5.1
# reads it correctly regardless of the file encoding.
# =====================================================================
$ErrorActionPreference = "Stop"
Set-Location (Split-Path -Parent $PSScriptRoot)

Write-Host "[1/3] Creating the Python environment with uv (uv sync)..."
uv sync
if ($LASTEXITCODE -ne 0) { throw "uv sync failed" }

$python = Join-Path (Get-Location) ".venv\Scripts\python.exe"
if (-not (Test-Path $python)) { throw "Not found: $python" }

$base = & $python -c "import sys; print(sys.base_prefix)"
Write-Host "Base Python: $base"
if ($base -match '\\uv\\python\\') {
  Write-Warning "This .venv uses a uv-managed Python. With Smart App Control on, parts of it may be blocked. Use the python.org build (see the setup guide)."
}

Write-Host "[2/3] Writing _environment.local (QUARTO_PYTHON)..."
$pythonForQuarto = $python -replace '\\', '/'
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText(
  (Join-Path (Get-Location) "_environment.local"),
  "QUARTO_PYTHON=$pythonForQuarto`n",
  $utf8NoBom
)

Write-Host "[3/3] Checking Quarto and Jupyter..."
$env:QUARTO_PYTHON = $python
quarto check jupyter
& $python -m jupyter_client.kernelspecapp list

Write-Host ""
Write-Host "Done. Next: 'quarto preview' (website) or 'quarto render --profile lualatex' (PDF)."
