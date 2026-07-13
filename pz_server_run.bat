@echo off
setlocal

set "serverLocation=D:\pzserver"
set "serverNameArg="
if /I "%~1"=="b42" (
    set "serverLocation=D:\pzserverb42"
    rem B41 and B42 share the same %USERPROFILE%\Zomboid data folder and both
    rem default to a save named "servertest" if no -servername is given, so B42
    rem would otherwise load the existing B41 "servertest" save and crash
    rem (B41 saves are not compatible with B42). Use a distinct name to keep
    rem them fully separate.
    set "serverNameArg=-servername pzb42"
)

if not exist "%serverLocation%\StartServer64.bat" (
    echo ERROR: "%serverLocation%\StartServer64.bat" not found.
    echo Check that serverLocation is correct and the drive is available.
    pause
    exit /b 1
)

wmic process where "name='java.exe'" get commandline 2>nul | findstr /I "pzserver" >nul
if not errorlevel 1 (
    echo ERROR: A Project Zomboid server process already appears to be running.
    pause
    exit /b 1
)

pushd "%serverLocation%"
call StartServer64.bat %serverNameArg%
popd
