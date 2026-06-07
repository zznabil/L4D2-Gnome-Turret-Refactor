@echo off
setlocal
pushd "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0nut_to_c.ps1"
set "RC=%ERRORLEVEL%"
popd
endlocal & exit /b %RC%
