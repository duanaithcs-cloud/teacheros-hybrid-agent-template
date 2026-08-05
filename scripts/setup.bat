@echo off
setlocal EnableExtensions
chcp 65001 >nul
title TeacherOS Hybrid Agent Setup

set "ROOT=%~dp0.."
pushd "%ROOT%" >nul

echo ========================================================
echo  TeacherOS Hybrid Agent - Setup
echo ========================================================
echo.

call :check_tool "Cursor" "cursor" "https://www.cursor.com/"
call :check_tool "Node.js" "node" "https://nodejs.org/"
call :check_tool "Python" "python" "https://www.python.org/downloads/"

where claude >nul 2>nul
if errorlevel 1 (
  echo [WARN] Claude Code CLI not found.
  where npm >nul 2>nul
  if not errorlevel 1 (
    set /p INSTALL_CLAUDE="Install Claude Code CLI with npm now? (Y/N): "
    if /I "%INSTALL_CLAUDE%"=="Y" npm install -g @anthropic-ai/claude-code
  )
) else (
  echo [OK] Claude Code CLI detected.
)

echo.
set /p GOOGLE_AI_STUDIO_API_KEY="Paste your GOOGLE_AI_STUDIO_API_KEY: "
if "%GOOGLE_AI_STUDIO_API_KEY%"=="" (
  echo [ERROR] API key is required.
  exit /b 1
)

if not exist "config" mkdir "config"
if not exist "_system_backup" mkdir "_system_backup"

> "config\local.env" (
  echo GOOGLE_AI_STUDIO_API_KEY=%GOOGLE_AI_STUDIO_API_KEY%
  echo PROXYPAL_API_KEY=proxypal-local
  echo OPENAI_BASE_URL=http://127.0.0.1:8317/v1
  echo DEFAULT_MODEL=gemini-3-flash-claude
)

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$key='%GOOGLE_AI_STUDIO_API_KEY%'; " ^
  "$tpl=Get-Content -Raw 'config/proxypal.config.example.yaml'; " ^
  "$tpl=$tpl.Replace('__GOOGLE_AI_STUDIO_API_KEY__',$key); " ^
  "[IO.File]::WriteAllText('config/proxypal.local.yaml',$tpl,[Text.UTF8Encoding]::new($false));"

echo [OK] Wrote ignored local config:
echo   config\local.env
echo   config\proxypal.local.yaml

copy /Y "config\proxypal.local.yaml" "_system_backup\proxypal.local.yaml.backup" >nul
copy /Y ".cursor\.cursorrules" "_system_backup\cursorrules.backup" >nul

echo.
echo [NEXT] Run:
echo   0_Start_TeacherOS.bat
echo.

popd >nul
endlocal
exit /b 0

:check_tool
where %~2 >nul 2>nul
if errorlevel 1 (
  echo [WARN] %~1 not found. Install from: %~3
) else (
  echo [OK] %~1 detected.
)
exit /b 0

