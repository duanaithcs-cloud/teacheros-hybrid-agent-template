@echo off
setlocal EnableExtensions
chcp 65001 >nul

set "ROOT=%~dp0.."
set "TASK_NAME=TeacherOS_ProxyPal_Watchdog"
set "SCRIPT=%ROOT%\scripts\watchdog-proxypal.ps1"
set "HIDDEN=%ROOT%\scripts\run-watchdog-hidden.vbs"
set "RUNNER=wscript.exe \"%HIDDEN%\""

if not exist "%SCRIPT%" (
  echo [ERROR] Watchdog script not found:
  echo %SCRIPT%
  exit /b 1
)

if not exist "%HIDDEN%" (
  echo [ERROR] Hidden runner not found:
  echo %HIDDEN%
  exit /b 1
)

schtasks /Query /TN "%TASK_NAME%" >nul 2>nul
if %errorlevel%==0 (
  schtasks /Delete /TN "%TASK_NAME%" /F >nul
)

schtasks /Create /TN "%TASK_NAME%" /SC MINUTE /MO 1 /TR "%RUNNER%" /F
if errorlevel 1 (
  echo [ERROR] Cannot create scheduled task.
  exit /b 1
)

echo [OK] Installed scheduled task:
echo   %TASK_NAME%
echo It checks ProxyPal every 1 minute and restarts it if needed.
