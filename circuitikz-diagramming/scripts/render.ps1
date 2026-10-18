#!/usr/bin/env pwsh
#Requires -Version 5.1
<#
.SYNOPSIS
  Compile a CircuiTikZ snippet or .tex file to PDF and PNG for visual verification.

.DESCRIPTION
  Wraps a bare circuitikz/tikzpicture snippet in a standalone document (unless the
  input already contains \documentclass), compiles it with a LaTeX engine, then
  rasterizes page 1 to PNG with pdftoppm. Prints machine-readable result lines so
  an agent can act on them:

      STATUS=ok|error
      ENGINE=<name>
      TEX=<path>            LOG=<path>            PDF=<path>        PNG=<path>

  On failure it prints the notable LaTeX error lines and exits non-zero.

.PARAMETER Source
  Path to a .tex file, or a literal TeX snippet string. (Alias: -In)

.PARAMETER Engine
  pdflatex (default), xelatex, or lualatex.

.PARAMETER OutDir
  Output directory. Default: <temp>/circuitikz-render.

.PARAMETER DPI
  Raster DPI for the PNG. Default 150.

.PARAMETER Vietnam
  Shorthand for -Engine xelatex plus fontspec + Times New Roman so Vietnamese
  diacritics in labels/annotations render correctly.

.PARAMETER Open
  Open the PNG after a successful run.

.EXAMPLE
  ./render.ps1 -Source '.\rc.tex'
.EXAMPLE
  ./render.ps1 -Source '\begin{circuitikz}\draw (0,0) to[R] ++(2,0);\end{circuitikz}'
.EXAMPLE
  ./render.ps1 -Source '.\vn.tex' -Vietnam -Open
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory = $true, Position = 0)]
  [Alias('In')]
  [string]$Source,

  [ValidateSet('pdflatex', 'xelatex', 'lualatex')]
  [string]$Engine = 'pdflatex',

  [string]$OutDir,

  [ValidateRange(36, 1200)]
  [int]$DPI = 150,

  [switch]$Vietnam,

  [switch]$Open
)

$ErrorActionPreference = 'Stop'

function Fail([string]$msg) {
  Write-Output 'STATUS=error'
  Write-Output "MESSAGE=$msg"
  exit 1
}

# --- resolve engine -------------------------------------------------------
if ($Vietnam -and $Engine -eq 'pdflatex') { $Engine = 'xelatex' }
$engineCmd = Get-Command $Engine -ErrorAction SilentlyContinue
if (-not $engineCmd) { Fail "LaTeX engine '$Engine' not found on PATH (install TeX Live or MiKTeX)." }
$engineExe = $engineCmd.Source

$pdftoppm = Get-Command pdftoppm -ErrorAction SilentlyContinue
if (-not $pdftoppm) { Fail 'pdftoppm not found on PATH (ships with TeX Live; on MiKTeX install poppler).' }

# --- output dir -----------------------------------------------------------
if (-not $OutDir) {
  $OutDir = Join-Path ([IO.Path]::GetTempPath()) 'circuitikz-render'
}
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$OutDir = (Resolve-Path $OutDir).Path

# --- gather source --------------------------------------------------------
$isFile = $false
try { $isFile = Test-Path -LiteralPath $Source -PathType Leaf } catch { $isFile = $false }
$raw = if ($isFile) { Get-Content -LiteralPath $Source -Raw -Encoding UTF8 } else { $Source }
if ([string]::IsNullOrWhiteSpace($raw)) { Fail 'Empty input.' }

$isFullDoc = $raw -match '\\documentclass'

if ($isFullDoc) {
  $tex = $raw
}
else {
  $vietnamPreamble = ''
  if ($Vietnam) {
    $vietnamPreamble = "`n\usepackage{fontspec}`n\setmainfont{Times New Roman}`n"
  }
  $tex = @"
\documentclass[border=3mm]{standalone}
\usepackage[RPvoltages, american]{circuitikz}
\usepackage{amsmath}
$vietnamPreamble
\begin{document}
$raw
\end{document}
"@
}

# --- write file (no BOM) --------------------------------------------------
$base = if ($isFile) { [IO.Path]::GetFileNameWithoutExtension($Source) } else { 'figure' }
$texPath = Join-Path $OutDir "$base.tex"
[IO.File]::WriteAllText($texPath, $tex, (New-Object System.Text.UTF8Encoding($false)))

# --- compile --------------------------------------------------------------
$texArgs = @('-interaction=nonstopmode', '-halt-on-error', "-output-directory=$OutDir", $texPath)
$logPath = Join-Path $OutDir "$base.log"
try {
  $proc = Start-Process -FilePath $engineExe -ArgumentList $texArgs -NoNewWindow -Wait -PassThru `
    -RedirectStandardOutput (Join-Path $OutDir "$base.stdout")
}
catch { Fail "Failed to launch $Engine : $($_.Exception.Message)" }

$pdfPath = Join-Path $OutDir "$base.pdf"
if ($proc.ExitCode -ne 0 -or -not (Test-Path -LiteralPath $pdfPath)) {
  $errs = Select-String -LiteralPath $logPath -Pattern '^!|^l\.\d+|Emergency stop|Fatal error|Undefined control' `
    -ErrorAction SilentlyContinue | Select-Object -First 25 | ForEach-Object { $_.Line }
  Write-Output 'STATUS=error'
  Write-Output "ENGINE=$Engine"
  Write-Output "TEX=$texPath"
  Write-Output "LOG=$logPath"
  Write-Output '----- LaTeX errors -----'
  if ($errs) { $errs | ForEach-Object { Write-Output $_ } } else { Write-Output '(no explicit error lines; inspect LOG)' }
  exit 1
}

# --- rasterize ------------------------------------------------------------
$pngPrefix = Join-Path $OutDir $base
& $pdftoppm.Source -png -r $DPI -f 1 -l 1 $pdfPath $pngPrefix | Out-Null
$png = Get-ChildItem -Path $OutDir -Filter "$base-*.png" | Sort-Object Name | Select-Object -First 1

Write-Output 'STATUS=ok'
Write-Output "ENGINE=$Engine"
Write-Output "TEX=$texPath"
Write-Output "PDF=$pdfPath"
if ($png) { Write-Output "PNG=$($png.FullName)" }
if ($Open -and $png) { Start-Process $png.FullName }
exit 0
