@echo off
setlocal

for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

set "GREEN=%ESC%[92m"
set "RED=%ESC%[91m"
set "YELLOW=%ESC%[93m"
set "RESET=%ESC%[0m"

echo %YELLOW%========================================%RESET%
echo %YELLOW%     Building Turret VPK%RESET%
echo %YELLOW%========================================%RESET%
echo.

pushd "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build_vpk.ps1" %*
set "RC=%ERRORLEVEL%"
popd

echo.
if "%RC%"=="0" (
    echo %GREEN%[SUCCESS] Build complete: dist\turret.vpk%RESET%
    echo.
    for /l %%i in (5,-1,1) do (
        echo Auto-closing in %%i...
        ping -n 2 127.0.0.1 >nul 2>&1
    )
) else (
    echo %RED%[FAILED] Build failed with exit code %RC%%RESET%
    echo.
    pause
)

endlocal
exit /b %RC%
