# graphify-query.ps1
# Query the graphify knowledge graph with natural language questions.
# Handles proper quoting, graph path resolution, and error messages.
#
# Usage:
#   tools\graphify-query.ps1 "How does X connect to Y?"
#   tools\graphify-query.ps1 "Explain Turret_Think()" -Dfs
#   tools\graphify-query.ps1 "Find vector dependencies" -Budget 3000
#
# Exit codes: 0 = success, 1 = no graph, 2 = query failed

param(
    [Parameter(Mandatory, Position = 0)]
    [string]$Question,

    [string]$Path = ".",

    [switch]$Dfs,

    [int]$Budget = 2000,

    [switch]$Json
)

$ErrorActionPreference = "Stop"

$projectRoot = (Resolve-Path $Path).Path
$graphJsonPath = Join-Path $projectRoot "graphify-out\graph.json"

function Write-Result($status, $message) {
    if ($Json) {
        $r = @{ status = $status; question = $Question; message = $message }
        $r | ConvertTo-Json
    } else {
        Write-Host $message
    }
    if ($status -eq "success") { exit 0 }
    exit 2
}

# --- Check graph exists ---
if (-not (Test-Path $graphJsonPath)) {
    Write-Result "error" "No graph at $graphJsonPath. Run tools\graphify-run first."
}

# --- Find graphify binary ---
$graphifyBin = (Get-Command graphify -ErrorAction SilentlyContinue).Source
if (-not $graphifyBin) {
    Write-Result "error" "graphify binary not found. Run tools\graphify-detect."
}

# --- Check if query subcommand is available ---
$helpOutput = & $graphifyBin --help 2>&1 | Out-String
if ($helpOutput -notmatch 'query') {
    Write-Result "error" "graphify CLI does not support 'query' subcommand (version too old)."
}

# --- Build arguments ---
$graphArg = "--graph"
$graphValue = $graphJsonPath
$budgetArg = "--budget"
$budgetValue = "$Budget"

# --- Execute query ---
try {
    if ($Dfs) {
        & $graphifyBin query "`"$Question`"" "--dfs" $graphArg $graphValue $budgetArg $budgetValue 2>&1
    } else {
        & $graphifyBin query "`"$Question`"" $graphArg $graphValue $budgetArg $budgetValue 2>&1
    }
    if ($LASTEXITCODE -ne 0) { throw "exit code $LASTEXITCODE" }
} catch {
    $msg = $_.Exception.Message
    if ($msg -match 'JSON.*parse') {
        Write-Result "failed" "Query produced unparseable output. Try a simpler question."
    } elseif ($msg -match 'not found|no such') {
        Write-Result "failed" "Could not find nodes matching '$Question'. Try broader terms."
    } else {
        Write-Result "failed" "Query failed: $msg"
    }
}

exit 0
