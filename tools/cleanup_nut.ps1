# Reports the reachability status of every .nut in scripts/vscripts/.
# This is the script-level equivalent of QA Gauntlet Pass 3
# (Reachability). It does not delete anything; it only prints.
#
# Exit code is always 0. Read the output to see which files are
# orphans and decide what to do with them.

$ErrorActionPreference = "Stop"
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$VScripts   = Join-Path $ScriptRoot "..\scripts\vscripts"

if (-not (Test-Path $VScripts)) {
    Write-Error "scripts/vscripts/ not found at: $VScripts"
}

$nutFiles = Get-ChildItem -Path $VScripts -Filter "*.nut" -File | Sort-Object Name
if ($nutFiles.Count -eq 0) {
    Write-Host "No .nut files found in scripts/vscripts/."
    exit 0
}

# Read all .nut contents once for the search step.
$contents = @{}
foreach ($f in $nutFiles) {
    $contents[$f.Name] = Get-Content -LiteralPath $f.FullName -Raw
}

# Build the reachability set.
$reachable = @{}
$reachable["mapspawn_addon.nut"] = "L4D2 auto-loads this file for AddonContent_Script 1 mods"

$changed = $true
while ($changed) {
    $changed = $false
    foreach ($name in $nutFiles.Name) {
        if ($reachable.ContainsKey($name)) { continue }
        $body = $contents[$name]
        if ($null -eq $body) { continue }
        # Match IncludeScript("X", ...) and vscripts = "X" in reachable files
        foreach ($r in $reachable.Keys) {
            $rbody = $contents[$r]
            if ($null -eq $rbody) { continue }
            $nameBare = [System.IO.Path]::GetFileNameWithoutExtension($name)
            $includePattern = 'IncludeScript\s*\(\s*"' + [regex]::Escape($nameBare) + '"'
            $vscriptsPattern = 'vscripts\s*=\s*"' + [regex]::Escape($nameBare) + '"'
            if ($rbody -match $includePattern) {
                $reachable[$name] = "loaded by $r (IncludeScript)"
                $changed = $true
                break
            }
            if ($rbody -match $vscriptsPattern) {
                $reachable[$name] = "loaded by $r (vscripts)"
                $changed = $true
                break
            }
        }
    }
}

Write-Host "Reachability report for scripts/vscripts/*.nut"
Write-Host "================================================="
foreach ($f in $nutFiles) {
    $name = $f.Name
    if ($reachable.ContainsKey($name)) {
        Write-Host ("REACHABLE: {0,-30} {1}" -f $name, $reachable[$name])
    } else {
        Write-Host ("ORPHAN:    {0,-30} no edge reaches it from any reachable .nut" -f $name)
    }
}
Write-Host ""
$orphanCount = ($nutFiles | Where-Object { -not $reachable.ContainsKey($_.Name) }).Count
if ($orphanCount -gt 0) {
    Write-Host "$orphanCount orphan(s) found. No files were deleted."
    Write-Host "Run mcp_serena_search_for_pattern on the .c files for cross-checks (see docs/QA_GAUNTLET.md Pass 3)."
} else {
    Write-Host "All .nut files are reachable from the L4D2 entry chain."
}
exit 0
