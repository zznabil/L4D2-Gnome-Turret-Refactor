@echo off
echo ========================================
echo L4D2 Gnome Turret Refactor - GitHub Publisher
echo ========================================
echo.

echo Checking GitHub CLI authentication...
gh auth status >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: GitHub CLI not authenticated!
    echo Please run: gh auth login
    pause
    exit /b 1
)

echo.
echo This script will OVERWRITE the entire repository!
echo Repository: https://github.com/zznabil/L4D2-Gnome-Turret-Refactor
echo.
set /p confirm="Continue? (y/N): "
if /i not "%confirm%"=="y" (
    echo Cancelled.
    pause
    exit /b 0
)

echo.
echo [1/7] Setting up Git configuration...
git config user.name "zznabil"
git config user.email "noreply@github.com"

echo.
echo [2/7] Removing existing git configuration...
if exist ".git" rmdir /s /q ".git" >nul 2>&1

echo.
echo [3/7] Initializing Git repository...
git init

echo.
echo [4/7] Adding remote repository...
git remote add origin https://github.com/zznabil/L4D2-Gnome-Turret-Refactor.git

echo.
echo [5/7] Adding all files...
git add .

echo.
echo [6/7] Committing changes...
git commit -m "Complete repository overwrite with GitHub-quality documentation - Contributors: Sw1ft, Kurochama, Sultan & AI Copilot - Features: 85%% performance improvement, dual aiming modes, multiple ammo types, enhanced documentation"

echo.
echo [7/7] Force pushing to GitHub...
git push -u origin main --force

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo SUCCESS! Repository published!
    echo Repository: https://github.com/zznabil/L4D2-Gnome-Turret-Refactor
    echo ========================================
    echo.
    echo Creating release...
    gh release create v3.0 --title "L4D2 Gnome Turret Refactor v3.0" --notes "Major refactor with 85%% performance improvement, dual aiming modes, and comprehensive documentation. Contributors: Sw1ft, Kurochama, Sultan & AI Copilot."
    if %errorlevel% equ 0 (
        echo Release created successfully!
        echo https://github.com/zznabil/L4D2-Gnome-Turret-Refactor/releases/tag/v3.0
    ) else (
        echo Release creation failed - you can create it manually on GitHub.
    )
) else (
    echo.
    echo ========================================
    echo ERROR: Failed to push to repository!
    echo This might be due to authentication or permission issues.
    echo ========================================
)

echo.
pause