@echo off
setlocal enabledelayedexpansion

set "outfile=%~dp0WiFi_Passwords.txt"

echo Saved WiFi Networks and Passwords > "%outfile%"
echo Generated: %date% %time% >> "%outfile%"
echo ===================================== >> "%outfile%"
echo. >> "%outfile%"

for /f "tokens=2 delims=:" %%a in ('netsh wlan show profiles ^| findstr /c:"All User Profile"') do (
    set "profile=%%a"
    set "profile=!profile:~1!"

    echo Network: !profile! >> "%outfile%"

    for /f "tokens=2 delims=:" %%b in ('netsh wlan show profile name^="!profile!" key^=clear ^| findstr /c:"Key Content"') do (
        set "password=%%b"
        set "password=!password:~1!"
        echo Password: !password! >> "%outfile%"
    )

    netsh wlan show profile name="!profile!" key=clear | findstr /c:"Key Content" >nul
    if errorlevel 1 (
        echo Password: ^(none / open network^) >> "%outfile%"
    )

    echo ------------------------------------- >> "%outfile%"
)

echo.
echo Done! Results saved to:
echo %outfile%
echo.
start "" notepad "%outfile%"
pause