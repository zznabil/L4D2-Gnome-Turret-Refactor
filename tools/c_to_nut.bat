@echo off
setlocal
pushd "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0c_to_nut.ps1"
set "RC=%ERRORLEVEL%"
popd
endlocal & exit /b %RC%
