@echo off
cd /d "%~dp0"
where cursor >nul 2>nul
if errorlevel 1 (
  echo Cursor command not found. Open this folder manually in Cursor:
  echo %~dp0
  pause
  exit /b 1
)
cursor .

