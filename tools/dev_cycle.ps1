# Orchestrator for the dev cycle. This script does NOT run the QA
# gauntlet (that's an MCP/agent action). It runs the mechanical steps
# in order and pauses for the agent to do the gauntlet.
#
# Steps:
#   1. nut_to_c    - ensure .c view is current
#   2. <agent runs QA gauntlet> - Parse / Drift / Reachability
#   3. publish     - overwrite .nut from .c (only if gauntlet passed)
#   4. build_vpk   - produce dist/<addonname>.vpk
#   5. <agent asks user FEEDBACK_TEMPLATE questions>
#   6. <agent updates CHANGELOG.md / cuts release>
#
# Usage:  tools\dev_cycle.bat
#         tools\dev_cycle.bat -SkipVpk      (skip the build step)
#         tools\dev_cycle.bat -SkipPublish  (only rebuild .c and produce vpk)
#         tools\dev_cycle.bat -DryRun       (print steps without running)

param(
    [switch]$SkipVpk,
    [switch]$SkipPublish,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptRoot

function Step($label, $scriptName) {
    Write-Host ""
    Write-Host "=== $label ==="
    Write-Host "    tools\$scriptName"
    if ($DryRun) { return }
    $ps1 = Join-Path $ScriptRoot $scriptName
    if (-not (Test-Path $ps1)) {
        Write-Error "Missing script: $ps1"
    }
    & $ps1 @args
    if ($LASTEXITCODE -ne 0) {
        Write-Error "$scriptName failed with exit code $LASTEXITCODE. Stopping cycle."
    }
}

Write-Host "Gnome Turret Mod - Dev Cycle"
Write-Host "Project: $ProjectRoot"
Write-Host "Mode:    $(if ($DryRun) {'DRY RUN'} else {'LIVE'})"

Step "Step 1/4 - ensure .c view is current"  "nut_to_c.ps1"
Write-Host ""
Write-Host "Step 2/4 - QA gauntlet (Parse / Drift / Reachability)"
Write-Host "    This step is an agent action. Run the three passes from docs/QA_GAUNTLET.md"
Write-Host "    using mcp_serena_* MCP calls. Do not proceed if any pass fails."
if (-not $DryRun) {
    $ok = Read-Host "    Type 'gauntlet passed' to continue"
    if ($ok -ne 'gauntlet passed') {
        Write-Error "Gauntlet not confirmed. Stopping cycle. Fix and re-run."
    }
}

if (-not $SkipPublish) {
    Step "Step 3/4 - publish .nut from .c"   "publish.ps1"
} else {
    Write-Host ""
    Write-Host "Step 3/4 - SKIPPED (-SkipPublish)"
}

if (-not $SkipVpk) {
    Step "Step 4/4 - build vpk"              "build_vpk.ps1"
} else {
    Write-Host ""
    Write-Host "Step 4/4 - SKIPPED (-SkipVpk)"
}

Write-Host ""
Write-Host "Dev cycle complete. Next: agent asks user the FEEDBACK_TEMPLATE questions"
Write-Host "and updates CHANGELOG.md. See docs/SDLC_AND_QA.md for the full loop."
