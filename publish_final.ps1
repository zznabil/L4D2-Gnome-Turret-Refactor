# L4D2 Gnome Turret Refactor - Complete Repository Overwrite
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "L4D2 Gnome Turret - Complete Repository Overwrite" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Get current directory info
$currentDir = Get-Location
$currentDirName = Split-Path $currentDir -Leaf
Write-Host "Current directory: $currentDir" -ForegroundColor Green
Write-Host "Directory name: $currentDirName" -ForegroundColor Green

# Show files that will be uploaded
Write-Host ""
Write-Host "Files and folders to upload:" -ForegroundColor Yellow
$items = Get-ChildItem -Force | Where-Object { $_.Name -ne "publish_final.ps1" }
foreach ($item in $items) {
    if ($item.PSIsContainer) {
        Write-Host "[DIR]  $($item.Name)/" -ForegroundColor Cyan
    } else {
        $size = [math]::Round($item.Length / 1KB, 2)
        Write-Host "[FILE] $($item.Name) ($size KB)" -ForegroundColor White
    }
}

# Check GitHub CLI authentication
Write-Host ""
Write-Host "Checking GitHub CLI authentication..." -ForegroundColor Yellow
try {
    $authStatus = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: GitHub CLI not authenticated!" -ForegroundColor Red
        Write-Host "Please run: gh auth login" -ForegroundColor Yellow
        Read-Host "Press Enter to exit"
        exit 1
    }
    Write-Host "✓ GitHub CLI authenticated" -ForegroundColor Green
} catch {
    Write-Host "ERROR: GitHub CLI not found or not authenticated!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "This script will COMPLETELY OVERWRITE the main branch!" -ForegroundColor Red
Write-Host "Repository: https://github.com/zznabil/L4D2-Gnome-Turret-Refactor" -ForegroundColor Cyan
Write-Host "Source: All files in current directory (except this script)" -ForegroundColor Yellow
Write-Host ""

$confirm = Read-Host "Continue with complete overwrite? (y/N)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 0
}

Write-Host ""
Write-Host "[1/9] Setting up Git configuration globally..." -ForegroundColor Yellow
git config --global user.name "zznabil"
git config --global user.email "noreply@github.com"

Write-Host "[2/9] Verifying Git configuration..." -ForegroundColor Yellow
$gitName = git config --global user.name
$gitEmail = git config --global user.email
Write-Host "Git user: $gitName <$gitEmail>" -ForegroundColor Green

Write-Host "[3/9] Removing existing git configuration..." -ForegroundColor Yellow
if (Test-Path ".git") {
    Remove-Item ".git" -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "[4/9] Initializing Git repository..." -ForegroundColor Yellow
git init
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to initialize Git repository!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[5/9] Adding remote repository..." -ForegroundColor Yellow
git remote add origin https://github.com/zznabil/L4D2-Gnome-Turret-Refactor.git
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to add remote repository!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[6/9] Adding all files and folders (excluding this script)..." -ForegroundColor Yellow
# Add all files and directories except the PowerShell script itself
git add .
git reset HEAD publish_final.ps1 2>$null  # Remove the script from staging if it was added

# Verify files were added
$addedFiles = git diff --cached --name-only
if (-not $addedFiles) {
    Write-Host "ERROR: No files were added to commit!" -ForegroundColor Red
    Write-Host "Current directory contents:" -ForegroundColor Yellow
    Get-ChildItem -Force | ForEach-Object { Write-Host "  $($_.Name)" }
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Files and folders staged for commit:" -ForegroundColor Green
$addedFiles | ForEach-Object { Write-Host "  + $_" -ForegroundColor White }

Write-Host "[7/9] Committing changes..." -ForegroundColor Yellow
$commitMessage = "Complete repository overwrite from $currentDirName directory

Updated with all files from local directory:
- All source files and configurations
- Documentation and project files  
- Compiled binaries and assets
- Development tools and scripts

Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Source: $currentDir"

git commit -m $commitMessage
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to commit changes!" -ForegroundColor Red
    Write-Host "Checking Git status..." -ForegroundColor Yellow
    git status
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[8/9] Setting main branch..." -ForegroundColor Yellow
git branch -M main
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to set main branch!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[9/9] Force pushing to GitHub..." -ForegroundColor Yellow
git push -u origin main --force
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to push to GitHub!" -ForegroundColor Red
    Write-Host "Checking remote configuration..." -ForegroundColor Yellow
    git remote -v
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "SUCCESS! Repository completely overwritten!" -ForegroundColor Green
Write-Host "Repository: https://github.com/zznabil/L4D2-Gnome-Turret-Refactor" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Creating release..." -ForegroundColor Yellow
$releaseTag = "complete-update-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$releaseNotes = "## Complete Repository Update

### Source Directory
- **Updated from**: $currentDir
- **Directory name**: $currentDirName  
- **Timestamp**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

### Files Updated
This release contains a complete overwrite of the repository with all files from the source directory.

### Installation
1. Download the files from this release
2. Extract to your desired location
3. Follow the installation instructions in the included documentation

**Note**: This is a complete repository overwrite - all previous files have been replaced."

gh release create $releaseTag --title "Complete Repository Update - $(Get-Date -Format 'yyyy-MM-dd')" --notes $releaseNotes

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Release created successfully!" -ForegroundColor Green
    Write-Host "https://github.com/zznabil/L4D2-Gnome-Turret-Refactor/releases/tag/$releaseTag" -ForegroundColor Cyan
} else {
    Write-Host "⚠ Release creation failed - you can create it manually on GitHub." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "COMPLETE! Repository updated with:" -ForegroundColor Green
Write-Host "Source: $currentDir" -ForegroundColor Cyan
Write-Host "Target: https://github.com/zznabil/L4D2-Gnome-Turret-Refactor" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Read-Host "Press Enter to exit"