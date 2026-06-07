# Publish: overwrite every .nut in scripts/vscripts/ from its .c mirror.
# This is the DESTRUCTIVE counterpart of c_to_nut.ps1. Use it at the end
# of a successful dev cycle (after the QA gauntlet has passed).
#
# The .c files are kept intact; only the .nut files are touched. After
# this runs, the game will load exactly the contents of the .c files.

$ErrorActionPreference = "Stop"
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$VScripts   = Join-Path $ScriptRoot "..\scripts\vscripts"

if (-not (Test-Path $VScripts)) {
    Write-Error "scripts/vscripts/ not found at: $VScripts"
}

$files = Get-ChildItem -Path $VScripts -Filter "*.c" -File
if ($files.Count -eq 0) {
    Write-Host "No .c files found. Run nut_to_c.ps1 first to populate the .c view."
    exit 1
}

$copied = 0; $overwritten = 0; $skipped = 0
foreach ($f in $files) {
    $nutPath = [System.IO.Path]::ChangeExtension($f.FullName, ".nut")
    $nutName = [System.IO.Path]::GetFileName($nutPath)
    if (Test-Path -LiteralPath $nutPath) {
        Copy-Item -LiteralPath $f.FullName -Destination $nutPath -Force
        Write-Host "  overwrite: $nutName"
        $overwritten++
    } else {
        Copy-Item -LiteralPath $f.FullName -Destination $nutPath
        Write-Host "  create:    $nutName"
        $copied++
    }
}
Write-Host "Done. $overwritten overwritten, $copied created, $skipped skipped."
Write-Host "The .nut files in scripts/vscripts/ now match the .c files."
