param(
    [string]$VpkPath = "D:\SteamLibrary\steamapps\common\Left 4 Dead 2\bin\vpk.exe"
)

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptRoot
$DistDir = Join-Path $ProjectRoot "dist"
$VpkOut = Join-Path $DistDir "turret.vpk"

try {
    if (-not (Test-Path $VpkPath)) {
        throw "vpk.exe not found at: $VpkPath"
    }
    if (-not (Test-Path $ProjectRoot)) {
        throw "Project root not found: $ProjectRoot"
    }
    if (-not (Test-Path $DistDir)) {
        New-Item -ItemType Directory -Path $DistDir -Force | Out-Null
    }
    # Clean old build artifacts to save storage
    Remove-Item -Path "$DistDir\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "Source: $ProjectRoot"
    Write-Host "Output: $VpkOut"
    Write-Host ""

    # vpk.exe CLI: vpk <dirname>
    # Produces <dirname>.vpk in the parent of <dirname>
    & $VpkPath $ProjectRoot
    if ($LASTEXITCODE -ne 0) {
        throw "vpk.exe exited with code $LASTEXITCODE"
    }

    # vpk.exe creates turret.vpk beside the project root
    $GeneratedVpk = Join-Path (Split-Path -Parent $ProjectRoot) "turret.vpk"
    if (-not (Test-Path $GeneratedVpk)) {
        throw "vpk.exe did not produce $GeneratedVpk"
    }

    Move-Item -Path $GeneratedVpk -Destination $VpkOut -Force
    $size = (Get-Item $VpkOut).Length
    Write-Host "Done. $VpkOut ($([math]::Round($size/1KB, 1)) KB)"
    exit 0
}
catch {
    Write-Host ""
    Write-Host "ERROR: $_" -ForegroundColor Red
    exit 1
}
