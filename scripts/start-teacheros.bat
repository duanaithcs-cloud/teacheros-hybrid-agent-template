@echo off
setlocal EnableExtensions
chcp 65001 >nul
title TeacherOS Hybrid Agent

set "ROOT=%~dp0.."
set "PROXYPAL_DIR=%LOCALAPPDATA%\ProxyPal"
set "PROXYPAL_CLI=%PROXYPAL_DIR%\cli-proxy-api.exe"
set "CONFIG=%ROOT%\config\proxypal.local.yaml"
set "STARTER=%ROOT%\scripts\start-proxypal-stable.ps1"

if not exist "%CONFIG%" (
  echo [ERROR] Missing config\proxypal.local.yaml
  echo Run scripts\setup.bat first.
  pause
  exit /b 1
)

if not exist "%PROXYPAL_CLI%" (
  echo [ERROR] ProxyPal CLI not found:
  echo %PROXYPAL_CLI%
  echo Install ProxyPal, then run this file again.
  pause
  exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%STARTER%" -ProjectRoot "%ROOT%"
if errorlevel 1 (
  echo [ERROR] Cannot start ProxyPal stable bridge.
  pause
  exit /b 1
)

set "ANTHROPIC_AUTH_TOKEN=proxypal-local"
set "ANTHROPIC_API_KEY=proxypal-local"
set "ANTHROPIC_BASE_URL=http://127.0.0.1:8317"
set "ANTHROPIC_MODEL=gemini-3-flash-claude"
set "ANTHROPIC_DEFAULT_HAIKU_MODEL=gemini-3-flash-claude"
set "ANTHROPIC_DEFAULT_SONNET_MODEL=gemini-3-flash-claude"
set "ANTHROPIC_DEFAULT_OPUS_MODEL=gemini-3-flash-claude"

echo ========================================================
echo  TeacherOS Hybrid Agent is ready
echo  ProxyPal: http://127.0.0.1:8317/v1
echo  Model: gemini-3-flash-claude
echo ========================================================
echo.

cd /d "%ROOT%"
claude --model gemini-3-flash-claude
