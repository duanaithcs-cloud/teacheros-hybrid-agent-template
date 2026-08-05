@echo off
setlocal EnableExtensions
chcp 65001 >nul

set "ROOT=%~dp0.."
set "BIN=%USERPROFILE%\bin"
set "SHIM=%BIN%\teacheros.bat"

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

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$bin='%BIN%'; " ^
  "$path=[Environment]::GetEnvironmentVariable('Path','User'); " ^
  "$parts=@(); if($path){$parts=$path -split ';' | Where-Object { $_ -ne '' }}; " ^
  "if($parts -notcontains $bin){ [Environment]::SetEnvironmentVariable('Path',(($parts+$bin)-join ';'),'User'); Write-Host '[OK] Added to User PATH.' } else { Write-Host '[OK] Already in User PATH.' }"

echo [OK] Installed command:
echo   %SHIM%
echo.
echo Close old Cursor Terminal tabs, open a new terminal, then run:
echo   teacheros

