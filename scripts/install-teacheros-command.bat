@echo off
setlocal EnableExtensions
chcp 65001 >nul

set "ROOT=%~dp0.."
set "BIN=%USERPROFILE%\bin"
set "SHIM=%BIN%\teacheros.bat"
set "LITE=%BIN%\teacheros-lite.bat"
set "RESET=%BIN%\teacheros-reset.bat"

if not exist "%BIN%" mkdir "%BIN%"

> "%SHIM%" (
  echo @echo off
  echo setlocal
  echo set "TEACHEROS_PROJECT=%ROOT%"
  echo set "TEACHEROS_START=%%TEACHEROS_PROJECT%%\0_Start_TeacherOS.bat"
  echo if not exist "%%TEACHEROS_START%%" ^(
  echo   echo [ERROR] TeacherOS starter not found:
  echo   echo %%TEACHEROS_START%%
  echo   exit /b 1
  echo ^)
  echo cd /d "%%TEACHEROS_PROJECT%%"
  echo call "%%TEACHEROS_START%%"
)

> "%LITE%" (
  echo @echo off
  echo setlocal
  echo set "TEACHEROS_PROJECT=%ROOT%"
  echo cd /d "%%TEACHEROS_PROJECT%%"
  echo set "ANTHROPIC_AUTH_TOKEN=proxypal-local"
  echo set "ANTHROPIC_API_KEY=proxypal-local"
  echo set "ANTHROPIC_BASE_URL=http://127.0.0.1:8317"
  echo set "ANTHROPIC_MODEL=gemini-3-flash-claude"
  echo set "ANTHROPIC_DEFAULT_HAIKU_MODEL=gemini-3-flash-claude"
  echo set "ANTHROPIC_DEFAULT_SONNET_MODEL=gemini-3-flash-claude"
  echo set "ANTHROPIC_DEFAULT_OPUS_MODEL=gemini-3-flash-claude"
  echo echo TeacherOS Lite Mode: use smaller prompts and avoid subagents.
  echo claude --bare --model gemini-3-flash-claude --add-dir "%%TEACHEROS_PROJECT%%"
)

> "%RESET%" (
  echo @echo off
  echo setlocal
  echo set "TEACHEROS_PROJECT=%ROOT%"
  echo echo Stopping Claude retry loops...
  echo powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_Process ^| Where-Object { $_.Name -eq 'claude.exe' -and $_.CommandLine -match 'gemini-3-flash-claude^|teacheros^|--bare' } ^| ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }"
  echo echo Restarting ProxyPal watchdog...
  echo powershell -NoProfile -ExecutionPolicy Bypass -File "%%TEACHEROS_PROJECT%%\scripts\watchdog-proxypal.ps1"
  echo echo Done. If the last error was 429, wait 2-5 minutes before a large prompt.
)

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$bin='%BIN%'; " ^
  "$path=[Environment]::GetEnvironmentVariable('Path','User'); " ^
  "$parts=@(); if($path){$parts=$path -split ';' | Where-Object { $_ -ne '' }}; " ^
  "if($parts -notcontains $bin){ [Environment]::SetEnvironmentVariable('Path',(($parts+$bin)-join ';'),'User'); Write-Host '[OK] Added to User PATH.' } else { Write-Host '[OK] Already in User PATH.' }"

echo [OK] Installed command:
echo   %SHIM%
echo   %LITE%
echo   %RESET%
echo.
echo Close old Cursor Terminal tabs, open a new terminal, then run:
echo   teacheros
