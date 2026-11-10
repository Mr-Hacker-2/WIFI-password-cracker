@echo off
setlocal
title Wi-Fi Password Security Demo

set "datafile=%~dp0WiFi_Passwords.txt"

echo ==========================================
echo   WI-FI PASSWORD SECURITY - DEMO MODE
echo ==========================================
echo.
echo This is an offline science-fair demonstration.
echo It does not scan networks or collect credentials.
echo.

if not exist "%datafile%" (
    echo ERROR: WiFi_Passwords.txt was not found.
    echo Keep it in the same folder as this batch file.
    pause
    exit /b 1
)

echo Opening fictional sample dataset...
start "" notepad "%datafile%"
echo.
echo No network access was performed.
pause
