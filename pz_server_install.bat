@echo off
setlocal enabledelayedexpansion

set "installDir=C:\pzserver"
set "appId=380870"

if "%STEAM_USER%"=="" (
    echo ERROR: STEAM_USER environment variable is not set.
    echo   set STEAM_USER=yourSteamAccount
    exit /b 1
)

set "installArgs="
for %%A in (%*) do (
    if /I "%%A"=="verify" set "installArgs=!installArgs! validate"
    if /I "%%A"=="b42" set "installArgs=!installArgs! beta:unstable" & set "installDir=C:\pzserverb42"
)

wmic process where "name='java.exe'" get commandline 2>nul | findstr /I "pzserver" >nul
if not errorlevel 1 (
    echo ERROR: The Project Zomboid server appears to be running. Stop it before updating.
    pause
    exit /b 1
)

call "%~dp0common\install_steam_app.bat" %appId% "%installDir%" %installArgs%
if errorlevel 1 (
    echo ERROR: install_steam_app.bat failed.
    pause
    exit /b 1
)
