@echo off
SETLOCAL ENABLEEXTENSIONS
set HOSTS_FILE=%SystemRoot%\System32\drivers\etc\hosts

NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo This script must be run as Administrator.
    pause
    exit /b
)

:: Add static IP mappings
set "entries=172.24.0.5 jellyfin.local"

copy %HOSTS_FILE% %HOSTS_FILE%.bak >nul

for %%A in (%entries%) do (
    findstr /C:"%%A" %HOSTS_FILE% >nul || echo %%A>> %HOSTS_FILE%
)

echo Mappings updated.
pause
