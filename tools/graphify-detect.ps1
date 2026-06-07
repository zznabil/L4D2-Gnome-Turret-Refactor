# graphify-detect.ps1
# Detect whether graphify is installed, its version, binary path,
# Python interpreter, available API keys, and existing graph state.
#
# Usage:
#   tools\graphify-detect.ps1               # human-readable output
#   tools\graphify-detect.ps1 -Json          # raw JSON (for agent parsing)
#
# Returns exit code 0 if found, 1 if not found.

param(
    [switch]$Json
)

$ErrorActionPreference = "Stop"

$result = [ordered]@{
    installed = $false
    binary    = $null
    version   = $null
    python    = $null
    python_version = $null
}

# --- Locate the graphify binary ---
$graphifyBin = (Get-Command graphify -ErrorAction SilentlyContinue).Source

if (-not $graphifyBin) {
    # Search common install locations
    $candidates = @(
        Join-Path $env:LOCALAPPDATA "Programs\Python\Python*\Scripts\graphify.exe"
        Join-Path $env:LOCALAPPDATA "Programs\Python\Python*\Scripts\graphify"
        Join-Path $env:USERPROFILE ".local\bin\graphify.exe"
        Join-Path $env:USERPROFILE ".local\bin\graphify"
        Join-Path $env:USERPROFILE "AppData\Roaming\Python\Scripts\graphify.exe"
        Join-Path $env:USERPROFILE ".cargo\bin\graphify.exe"
    )
    foreach ($pattern in $candidates) {
        $matches = Resolve-Path $pattern -ErrorAction SilentlyContinue
        if ($matches) {
            $graphifyBin = $matches[0].Path
            break
        }
    }
}

if (-not $graphifyBin) {
    $result.error = "graphify binary not found on PATH or any standard location"
    if ($Json) { $result | ConvertTo-Json }
    else { Write-Host "[ERR] graphify NOT installed" -ForegroundColor Red; Write-Host "  $($result.error)" }
    exit 1
}

$result.binary = $graphifyBin
$result.installed = $true

# --- Get version ---
$versionOutput = & $graphifyBin --version 2>&1 | Out-String
$versionOutput = $versionOutput.Trim()
if ($versionOutput -match '(\d+\.\d+\.\d+)') {
    $result.version = $matches[1]
} else {
    $result.version = $versionOutput
}

# --- Find Python interpreter ---
$pythonPath = $null
if ($graphifyBin -match '\.exe$') {
    # Windows PE binary - try common interpreters
    foreach ($py in @('python', 'python3', 'py')) {
        $found = (Get-Command $py -ErrorAction SilentlyContinue).Source
        if ($found) { $pythonPath = $found; break }
    }
    # Try to get pip-installed graphifyy location
    try {
        $pipInfo = pip show graphifyy 2>&1 | Out-String
        if ($pipInfo -match 'Location:\s+(.+)') {
            $result.pip_location = $matches[1].Trim()
        }
    } catch { }
} else {
    # Script-based install (pipx, uv) - read shebang
    try {
        $firstLine = Get-Content $graphifyBin -TotalCount 1 -ErrorAction Stop
        if ($firstLine -match '#!(.+)') {
            $pythonPath = $matches[1].Trim()
        }
    } catch { }
}

if ($pythonPath) {
    $result.python = $pythonPath
    try {
        $pyVer = & $pythonPath --version 2>&1 | Out-String
        $result.python_version = $pyVer.Trim()
    } catch { }
}

# --- Check API keys ---
$result.has_gemini_key    = [bool]$env:GEMINI_API_KEY
$result.has_google_key    = [bool]$env:GOOGLE_API_KEY
$result.has_anthropic_key = [bool]$env:ANTHROPIC_API_KEY
$result.has_openai_key    = [bool]$env:OPENAI_API_KEY
$result.has_deepseek_key  = [bool]$env:DEEPSEEK_API_KEY
$result.has_moonshot_key  = [bool]$env:MOONSHOT_API_KEY
$result.can_full_extract = $result.has_gemini_key -or $result.has_google_key `
    -or $result.has_anthropic_key -or $result.has_openai_key `
    -or $result.has_deepseek_key -or $result.has_moonshot_key

# --- Check existing graph ---
$result.has_existing_graph = Test-Path "graphify-out\graph.json"
$result.graphify_out_exists = Test-Path "graphify-out"

# --- Output ---
if ($Json) {
    $result | ConvertTo-Json
    exit 0
}

Write-Host "[OK] graphify $($result.version) installed" -ForegroundColor Green
Write-Host "  Binary: $($result.binary)"
if ($result.python) {
    Write-Host "  Python: $($result.python) ($($result.python_version))"
} else {
    Write-Host "  Python: (not detected)"
}
$keys = @()
if ($result.has_gemini_key)    { $keys += "Gemini" }
if ($result.has_google_key)    { $keys += "Google" }
if ($result.has_anthropic_key) { $keys += "Anthropic" }
if ($result.has_openai_key)    { $keys += "OpenAI" }
if ($result.has_deepseek_key)  { $keys += "DeepSeek" }
if ($result.has_moonshot_key)  { $keys += "Moonshot" }
if ($keys.Count -eq 0) { $keys += "none (code-only mode)" }
Write-Host "  API keys: $($keys -join ', ')"
if ($result.has_existing_graph) {
    Write-Host "  Graph: graphify-out\graph.json [OK] (update available)"
} elseif ($result.graphify_out_exists) {
    Write-Host "  Graph: graphify-out\ exists but no graph.json (needs fresh build)"
} else {
    Write-Host "  Graph: none (run graphify-run)"
}
Write-Host ""
if ($result.can_full_extract) { $recMode = "full extract" } else { $recMode = "code-only update" }
Write-Host "  Recommended mode: $recMode"
exit 0
