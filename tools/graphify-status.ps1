# graphify-status.ps1
# Quick summary of the last graphify build. Reads graphify-out/ and reports
# node/edge/community counts, god nodes, isolated nodes, and graph health.
#
# Usage:
#   tools\graphify-status.ps1               # human-readable
#   tools\graphify-status.ps1 -Json          # raw JSON (for agent parsing)
#   tools\graphify-status.ps1 -Path "..\x"  # check another project

param(
    [string]$Path = ".",
    [switch]$Json
)

$ErrorActionPreference = "Stop"

$projectRoot = (Resolve-Path $Path).Path
$graphJsonPath = Join-Path $projectRoot "graphify-out\graph.json"
$reportMdPath  = Join-Path $projectRoot "graphify-out\GRAPH_REPORT.md"
$graphHtmlPath = Join-Path $projectRoot "graphify-out\graph.html"

$result = [ordered]@{
    graph_exists     = $false
    nodes            = 0
    edges            = 0
    communities      = 0
    god_nodes        = @()
    isolated_nodes   = 0
    cohesion_range   = @()
    extraction_pct   = $null
    inferred_count   = 0
    report_exists    = $false
    html_exists      = $false
}

if (-not (Test-Path $graphJsonPath)) {
    $result.error = "No graph.json found. Run tools\graphify-run first."
    if ($Json) { $result | ConvertTo-Json } else { Write-Host "[FAIL] No graph -- run graphify-run" -ForegroundColor Red }
    exit 1
}

$result.graph_exists = $true
$result.report_exists = Test-Path $reportMdPath
$result.html_exists = Test-Path $graphHtmlPath

# --- Parse graph.json for basic stats ---
try {
    $graph = Get-Content $graphJsonPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $result.nodes = $graph.nodes.Count
    $result.edges = $graph.edges.Count
} catch {
    $result.error = "Failed to parse graph.json: $_"
    if ($Json) { $result | ConvertTo-Json } else { Write-Host "[FAIL] Corrupt graph.json" -ForegroundColor Red }
    exit 1
}

# --- Parse GRAPH_REPORT.md for richer stats ---
if ($result.report_exists) {
    $report = Get-Content $reportMdPath -Encoding UTF8

    # Communities count
    $communityLines = $report | Select-String '^### Community \d+'
    $result.communities = $communityLines.Count

    # God nodes
    $inGods = $false
    foreach ($line in $report) {
        if ($line -match '^## God Nodes') { $inGods = $true; continue }
        if ($inGods -and $line -match '^\d+\.\s+`(.+?)`\s+-\s+(\d+) edges') {
            $entry = [ordered]@{ name = $matches[1]; edges = [int]$matches[2] }
            $result.god_nodes += $entry
        }
        if ($inGods -and $line -match '^##') { break }
    }

    # Extraction breakdown
    $extractMatch = $report | Select-String '(\d+)% EXTRACTED'
    if ($extractMatch) { $result.extraction_pct = [int]$extractMatch.Matches.Groups[1].Value }
    $inferredMatch = $report | Select-String 'INFERRED:\s+(\d+)'
    if ($inferredMatch) { $result.inferred_count = [int]$inferredMatch.Matches.Groups[1].Value }

    # Isolated nodes
    $isoMatch = $report | Select-String '(\d+)\s+isolated'
    if ($isoMatch) { $result.isolated_nodes = [int]$isoMatch.Matches.Groups[1].Value }

    # Cohesion range
    $cohesionValues = @()
    foreach ($line in $report) {
        if ($line -match 'Cohesion:\s+([\d.]+)') {
            $cohesionValues += [double]$matches[1]
        }
    }
    if ($cohesionValues.Count -gt 0) {
        $min = ($cohesionValues | Measure-Object -Minimum).Minimum
        $max = ($cohesionValues | Measure-Object -Maximum).Maximum
        $avg = ($cohesionValues | Measure-Object -Average).Average
        $result.cohesion_range = [ordered]@{
            min = [math]::Round($min, 3)
            max = [math]::Round($max, 3)
            avg = [math]::Round($avg, 3)
        }
    }
}

# --- Output ---
if ($Json) {
    $result | ConvertTo-Json
    exit 0
}

Write-Host "Graphify Status -- $projectRoot" -ForegroundColor Cyan
Write-Host "  $($result.nodes) nodes | $($result.edges) edges | $($result.communities) communities"

if ($result.god_nodes.Count -gt 0) {
    Write-Host "  God nodes: " -NoNewline
    $top5 = $result.god_nodes | Sort-Object edges -Descending | Select-Object -First 5
    $godParts = @()
    foreach ($g in $top5) { $godParts += "$($g.name)($($g.edges)ed)" }
    Write-Host ($godParts -join ", ")
}

if ($result.extraction_pct -ne $null) {
    Write-Host "  Extraction: $($result.extraction_pct)% EXTRACTED | $($result.inferred_count) INFERRED"
}
if ($result.cohesion_range.Count -gt 0) {
    Write-Host "  Cohesion: min=$($result.cohesion_range.min) avg=$($result.cohesion_range.avg) max=$($result.cohesion_range.max)"
}
if ($result.isolated_nodes -gt 0) {
    Write-Host "  Isolated nodes: $($result.isolated_nodes)" -ForegroundColor DarkYellow
}
if ($result.html_exists) { Write-Host "  HTML viz: graphify-out\graph.html [OK]" }

exit 0
