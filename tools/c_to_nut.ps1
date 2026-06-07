# Copies every .c file in scripts/vscripts/ to a sibling .nut in the same
# directory. Existing .nut files are NOT overwritten. The .c files are
# preserved so Serena can keep indexing them. After this runs, the game
# sees the .nut copies and loads them normally.

$ErrorActionPreference = "Stop"
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$VScripts   = Join-Path $ScriptRoot "..\scripts\vscripts"

if (-not (Test-Path $VScripts)) {
    Write-Error "scripts/vscripts/ not found at: $VScripts"
}

$files = Get-ChildItem -Path $VScripts -Filter "*.c" -File
if ($files.Count -eq 0) {
    Write-Host "No .c files found. Run nut_to_c.ps1 first."
    exit 0
}
$copied = 0; $skipped = 0
foreach ($f in $files) {
    $newPath = [System.IO.Path]::ChangeExtension($f.FullName, ".nut")
    $newName = [System.IO.Path]::GetFileName($newPath)
    if (Test-Path -LiteralPath $newPath) {
        Write-Host "  skip (exists): $newName"
        $skipped++
        continue
    }
    Write-Host "  $($f.Name) -> $newName"
    Copy-Item -LiteralPath $f.FullName -Destination $newPath
    $copied++
}
Write-Host "Done. $copied copied, $skipped skipped."
