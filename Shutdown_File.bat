@echo off
setlocal EnableExtensions

:: Shutdown PC with a 30-second delay (adjust /t as needed)
shutdown /s /t 1 /c "Scheduled shutdown initiated"

echo Shutdown scheduled in 30 seconds.
echo Press Ctrl+C in this window to cancel, or run: shutdown /a
pause