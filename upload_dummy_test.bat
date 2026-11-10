@echo off
setlocal

if not defined GOFILE_API_TOKEN (
    echo Set GOFILE_API_TOKEN before running this test.
    exit /b 1
)

where powershell.exe >nul 2>&1
if errorlevel 1 (
    echo Windows PowerShell is required.
    exit /b 1
)

set "testdir=%TEMP%\gofile-wifi-test-%RANDOM%-%RANDOM%"
mkdir "%testdir%" || exit /b 1
set "testfile=%testdir%\WiFi_Passwords.txt"

(
    echo Synthetic test report only
    echo Network: TEST_NETWORK
    echo Password: NOT_A_REAL_PASSWORD
) > "%testfile%"

set "GOFILE_TEST_FILE=%testfile%"
powershell.exe -NoProfile -Command "$ErrorActionPreference = 'Stop'; Add-Type -AssemblyName System.Net.Http; $client = $null; $form = $null; $stream = $null; try { $token = $env:GOFILE_API_TOKEN; if ([string]::IsNullOrWhiteSpace($token)) { throw 'GOFILE_API_TOKEN is empty.' }; $client = [System.Net.Http.HttpClient]::new(); $client.DefaultRequestHeaders.Authorization = [System.Net.Http.Headers.AuthenticationHeaderValue]::new('Bearer', $token); $form = [System.Net.Http.MultipartFormDataContent]::new(); $form.Add([System.Net.Http.StringContent]::new('33f0f17d-4f6e-4360-bff7-c524a59d208c'), 'folderId'); $stream = [System.IO.File]::OpenRead($env:GOFILE_TEST_FILE); $fileContent = [System.Net.Http.StreamContent]::new($stream); $fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::new('text/plain'); $form.Add($fileContent, 'file', 'WiFi_Passwords.txt'); $response = $client.PostAsync('https://upload.gofile.io/uploadfile', $form).GetAwaiter().GetResult(); $body = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult(); if (-not $response.IsSuccessStatusCode) { throw ('HTTP upload failed: ' + [int]$response.StatusCode + ' ' + $body) }; $result = $body | ConvertFrom-Json; if ($result.status -ne 'ok' -or [string]::IsNullOrWhiteSpace($result.data.downloadPage)) { throw ('Gofile rejected the upload or returned no download page: ' + $body) }; Write-Output ('Upload complete: ' + $result.data.downloadPage) } finally { if ($form) { $form.Dispose() }; if ($client) { $client.Dispose() }; if ($stream) { $stream.Dispose() } }"
set "uploadresult=%ERRORLEVEL%"

rmdir /s /q "%testdir%" >nul 2>&1
if not "%uploadresult%"=="0" (
    echo Gofile test upload failed.
    exit /b %uploadresult%
)

endlocal