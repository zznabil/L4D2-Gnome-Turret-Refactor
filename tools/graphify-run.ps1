# graphify-run.ps1
# Smart graphify pipeline runner. Auto-selects code-only vs full extract
# based on available API keys. Handles errors gracefully.
#
# Usage:
#   tools\graphify-run.ps1                        # auto mode on current dir
#   tools\graphify-run.ps1 -Path "..\other-repo"  # target a different dir
#   tools\graphify-run.ps1 -Mode full             # force full extraction
#   tools\graphify-run.ps1 -Mode code-only -Force # force re-extract
#   tools\graphify-run.ps1 -DryRun                # preview only
#   tools\graphify-run.ps1 -Json                  # machine-readable output
#
# Exit codes: 0 = success, 1 = graphify not found, 2 = pipeline failed

param(
    [string]$Path = ".",
    [ValidateSet("auto", "code-only", "full")]
    [string]$Mode = "auto",
    [switch]$Force,
    [switch]$DryRun,
    [switch]$Json
)

$ErrorActionPreference = "Stop"

# --- Resolve project root ---
$CallerDir = (Resolve-Path $Path).Path

function Write-Result($status, $mode, $message) {
    $r = [ordered]@{
        status     = $status
        mode       = $mode
        message    = $message
        output_dir = "$CallerDir\graphify-out"
    }
    if ($Json) { $r | ConvertTo-Json } else { Write-Host $message }
    if ($status -eq "success") { exit 0 }
    if ($status -eq "failed") { exit 2 }
    exit 1
}

# --- Find graphify binary ---
$graphifyBin = (Get-Command graphify -ErrorAction SilentlyContinue).Source
if (-not $graphifyBin) {
    Write-Result "error" $Mode "graphify binary not found. Run tools\graphify-detect first."
}

# --- Detect API keys ---
$hasApiKey = [bool]($env:GEMINI_API_KEY -or $env:GOOGLE_API_KEY -or $env:ANTHROPIC_API_KEY `
    -or $env:OPENAI_API_KEY -or $env:DEEPSEEK_API_KEY -or $env:MOONSHOT_API_KEY)

# --- Choose effective mode ---
$effectiveMode = $Mode
if ($effectiveMode -eq "auto") {
    if ($hasApiKey) { $effectiveMode = "full" } else { $effectiveMode = "code-only" }
}

if ($effectiveMode -eq "full") {
    $modeLabel = "full extract (with semantic)"
    $subcommand = "extract"
} else {
    $modeLabel = "code-only (no LLM)"
    $subcommand = "update"
}

if ($DryRun) {
    if ($effectiveMode -eq "full") { $action = "extract" } else { $action = "update" }
    Write-Host "Would run: graphify $action $CallerDir" -ForegroundColor Yellow
    Write-Host "  Mode: $modeLabel"
    $f = $Force -or ($effectiveMode -eq "code-only")
    Write-Host "  Force: $f"
    exit 0
}

Write-Host "Graphify pipeline -- mode: $modeLabel" -ForegroundColor Cyan

# --- Execute ---
$argsList = @($subcommand, "`"$CallerDir`"")
if ($effectiveMode -eq "full") {
    $argsList += "--mode"
    $argsList += "deep"
} elseif ($Force) {
    $argsList += "--force"
}

try {
    $output = & $graphifyBin @argsList 2>&1
    $exitCode = $LASTEXITCODE
    $output | ForEach-Object { Write-Host $_ }
} catch {
    Write-Result "failed" $effectiveMode "graphify crashed: $_"
}

if ($exitCode -ne 0) {
    Write-Result "failed" $effectiveMode "graphify exited with code $exitCode"
}

# --- Verify output ---
$graphJson = Join-Path $CallerDir "graphify-out\graph.json"
$reportMd  = Join-Path $CallerDir "graphify-out\GRAPH_REPORT.md"

if (-not (Test-Path $graphJson)) {
    Write-Result "failed" $effectiveMode "pipeline completed but graph.json not found at $graphJson"
}

Write-Host ""
Write-Host "[OK] graphify $effectiveMode complete" -ForegroundColor Green
Write-Host "  Output: $CallerDir\graphify-out\"
Write-Host "  graph.json [OK]"
if (Test-Path $reportMd) { Write-Host "  GRAPH_REPORT.md [OK]" }

Write-Result "success" $effectiveMode "graphify $effectiveMode completed successfully"
