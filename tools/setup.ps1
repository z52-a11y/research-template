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
& (Join-Path (Get-Location) ".venv\Scripts\jupyter.exe") kernelspec list

Write-Host ""
Write-Host "Done. Next: 'quarto preview' (website) or 'quarto render --profile lualatex' (PDF)."
