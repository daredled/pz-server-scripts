@echo off
setlocal

set "steamcmdLocation=C:\steamcmd"
set "installDir=C:\pzserver"

if "%steamUsername%"=="" (
    echo ERROR: steamUsername environment variable is not set.
    echo   set steamUsername=yourSteamAccount
    exit /b 1
)

set "validateFlag="
set "betaFlag="
for %%A in (%*) do (
    if /I "%%A"=="verify" set "validateFlag=validate"
    if /I "%%A"=="b42" set "betaFlag=-beta unstable"
)

if defined betaFlag set "installDir=C:\pzserverb42"

wmic process where "name='java.exe'" get commandline 2>nul | findstr /I "pzserver" >nul
if not errorlevel 1 (
    echo ERROR: The Project Zomboid server appears to be running. Stop it before updating.
    pause
    exit /b 1
)

if not exist "%steamcmdLocation%\steamcmd.exe" (
    echo steamcmd.exe not found in "%steamcmdLocation%" - installing it first.
    call "%~dp0install_steamcmd.bat"
    if errorlevel 1 (
        echo ERROR: install_steamcmd.bat failed.
        pause
        exit /b 1
    )
)

cd /d "%steamcmdLocation%"

set CMD=^
+force_install_dir "%installDir%" ^
+login %steamUsername% ^
+app_update 380870 %betaFlag% %validateFlag% ^
+quit

steamcmd %CMD%

rem steamcmd routinely returns a non-zero exit code on +quit even after a
rem successful update (a known steamcmd quirk, not a real failure signal),
rem so we don't gate on errorlevel here. Check the output above / C:\steamcmd\logs
rem if you suspect the update actually failed.

echo Update complete (exit code %errorlevel% - see steamcmd output above).
