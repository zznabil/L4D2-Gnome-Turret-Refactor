# Renames every .nut in scripts/vscripts/ to .c in place.
# After running, the game can no longer find the script. Run c_to_nut.ps1
# to materialize .nut copies alongside the .c files for the game to load.

$ErrorActionPreference = "Stop"
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$VScripts   = Join-Path $ScriptRoot "..\scripts\vscripts"

if (-not (Test-Path $VScripts)) {
    Write-Error "scripts/vscripts/ not found at: $VScripts"
}

$files = Get-ChildItem -Path $VScripts -Filter "*.nut" -File
if ($files.Count -eq 0) {
    Write-Host "No .nut files to rename. Already in .c state."
    exit 0
}
foreach ($f in $files) {
    $newPath = [System.IO.Path]::ChangeExtension($f.FullName, ".c")
    Write-Host "  $($f.Name) -> $([System.IO.Path]::GetFileName($newPath))"
    Rename-Item -LiteralPath $f.FullName -NewName (Split-Path -Leaf $newPath)
}
Write-Host "Done. $($files.Count) file(s) renamed to .c"
