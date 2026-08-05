@echo off
setlocal EnableExtensions
chcp 65001 >nul

set "ROOT=%~dp0.."
set "TASK_NAME=TeacherOS_ProxyPal_Watchdog"
set "SCRIPT=%ROOT%\scripts\watchdog-proxypal.ps1"
set "PS=powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File \"%SCRIPT%\""

if not exist "%SCRIPT%" (
  echo [ERROR] Watchdog script not found:
  echo %SCRIPT%
  exit /b 1
)

schtasks /Query /TN "%TASK_NAME%" >nul 2>nul
if %errorlevel%==0 (
  schtasks /Delete /TN "%TASK_NAME%" /F >nul
)

schtasks /Create /TN "%TASK_NAME%" /SC MINUTE /MO 1 /TR "%PS%" /F
if errorlevel 1 (
  echo [ERROR] Cannot create scheduled task.
  exit /b 1
)

echo [OK] Installed scheduled task:
echo   %TASK_NAME%
echo It checks ProxyPal every 1 minute and restarts it if needed.

