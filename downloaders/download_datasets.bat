@echo off
setlocal EnableExtensions DisableDelayedExpansion

for %%I in ("%~dp0..") do set "PROJECT_ROOT=%%~fI"
set "TRAFFIC_DIR=%PROJECT_ROOT%\data\Dataset Network Traffic"
set "IANA_DIR=%PROJECT_ROOT%\data\Dataset Service and Port"
REM Batch files need %% for a literal percent in the URL.
set "TRAFFIC_URL=https://cse-cic-ids2018.s3.ca-central-1.amazonaws.com/Processed%%20Traffic%%20Data%%20for%%20ML%%20Algorithms"
set "IANA_URL=https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv"

where curl.exe >nul 2>&1
if errorlevel 1 (
    echo ERROR: curl.exe is required. 1>&2
    exit /b 1
)
if not exist "%TRAFFIC_DIR%\" mkdir "%TRAFFIC_DIR%"
if not exist "%TRAFFIC_DIR%\" exit /b 1
if not exist "%IANA_DIR%\" mkdir "%IANA_DIR%"
if not exist "%IANA_DIR%\" exit /b 1

set "FAILED=0"
for %%F in (
    "Wednesday-14-02-2018_TrafficForML_CICFlowMeter.csv"
    "Thursday-15-02-2018_TrafficForML_CICFlowMeter.csv"
    "Friday-16-02-2018_TrafficForML_CICFlowMeter.csv"
    "Thuesday-20-02-2018_TrafficForML_CICFlowMeter.csv"
    "Wednesday-21-02-2018_TrafficForML_CICFlowMeter.csv"
    "Thursday-22-02-2018_TrafficForML_CICFlowMeter.csv"
    "Friday-23-02-2018_TrafficForML_CICFlowMeter.csv"
    "Wednesday-28-02-2018_TrafficForML_CICFlowMeter.csv"
    "Thursday-01-03-2018_TrafficForML_CICFlowMeter.csv"
    "Friday-02-03-2018_TrafficForML_CICFlowMeter.csv"
) do (
    call :download_traffic "%%~F"
    if errorlevel 1 set "FAILED=1"
)
set "DOWNLOAD_URL=%IANA_URL%"
call :download "%IANA_DIR%\service-names-port-numbers.csv"
if errorlevel 1 set "FAILED=1"
if "%FAILED%"=="1" (
    echo ERROR: One or more downloads failed. Rerun to retry missing files. 1>&2
    exit /b 1
)
echo All ten original traffic CSVs and IANA are ready.
exit /b 0

:download_traffic
REM Keep URLs out of CALL arguments to avoid its second percent-expansion pass.
set "DOWNLOAD_URL=%TRAFFIC_URL%/%~1"
call :download "%TRAFFIC_DIR%\%~1"
exit /b %errorlevel%

:download
set "DESTINATION=%~1"
if exist "%DESTINATION%" (
    for %%I in ("%DESTINATION%") do if %%~zI GTR 0 (
        echo Already exists: "%DESTINATION%"
        exit /b 0
    )
)
set "PARTIAL=%DESTINATION%.part"
echo Downloading: "%DESTINATION%"
curl.exe --fail --location --retry 3 --connect-timeout 30 --speed-limit 1 --speed-time 120 --output "%PARTIAL%" "%DOWNLOAD_URL%"
if errorlevel 1 goto download_failed
if not exist "%PARTIAL%" goto download_failed
for %%I in ("%PARTIAL%") do if %%~zI EQU 0 goto download_failed
move /y "%PARTIAL%" "%DESTINATION%" >nul
if errorlevel 1 goto download_failed
exit /b 0

:download_failed
echo ERROR: Download failed or returned an empty file: "%DESTINATION%" 1>&2
if exist "%PARTIAL%" del /q "%PARTIAL%"
exit /b 1
