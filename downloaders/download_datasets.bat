@echo off
setlocal EnableExtensions

title CIC-IDS2018 Dataset Downloader

echo ------------------------------------------
echo       CIC-IDS2018 Dataset Downloader
echo ------------------------------------------
echo.

REM Script is stored in the project's downloaders folder.
REM Destination folders are relative to the project root.
for %%I in ("%~dp0..") do set "PROJECT_ROOT=%%~fI"
set "DATA_DIR=%PROJECT_ROOT%\data"
set "DATASET1_DEST=%DATA_DIR%\raw\dataset_1"
set "DATASET2_DEST=%DATA_DIR%\raw\dataset_2"
set "BUCKET=s3://cse-cic-ids2018/Processed Traffic Data for ML Algorithms/"
set "IANA_URL=https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv"
set "IANA_FILE=%DATASET2_DEST%\service-names-port-numbers.csv"

echo Project root:
echo "%PROJECT_ROOT%"
echo.

REM Check whether AWS CLI is installed.
where aws >nul 2>&1
if errorlevel 1 (
    echo ERROR: AWS CLI was not found.
    echo Install AWS CLI v2 from https://aws.amazon.com/cli/
    echo Then reopen this script.
    echo.
    pause
    exit /b 1
)

REM Confirm the existing data folder is present.
if not exist "%DATA_DIR%\" (
    echo ERROR: The existing project data folder was not found:
    echo "%DATA_DIR%"
    echo Keep this script inside the project's downloaders folder.
    echo.
    pause
    exit /b 1
)

REM Create dataset directories.
if not exist "%DATASET1_DEST%\" mkdir "%DATASET1_DEST%"
if errorlevel 1 (
    echo ERROR: Could not create "%DATASET1_DEST%"
    pause
    exit /b 1
)

if not exist "%DATASET2_DEST%\" mkdir "%DATASET2_DEST%"
if errorlevel 1 (
    echo ERROR: Could not create "%DATASET2_DEST%"
    pause
    exit /b 1
)

echo AWS CLI:
aws --version
echo.

echo Downloading Dataset 1: CIC-IDS2018 CSV files


echo Destination: "%DATASET1_DEST%"
echo.

aws s3 sync ^
  --no-sign-request ^
  --region ca-central-1 ^
  "%BUCKET%" ^
  "%DATASET1_DEST%"

if errorlevel 1 (
    echo.
    echo ERROR: Dataset 1 download failed.
    echo Check internet access, disk space, and AWS CLI.
    echo The script will still attempt to download Dataset 2.
    echo.
    set "DATASET1_FAILED=1"
) else (
    echo Dataset 1 sync completed.
)

echo.

echo Downloading Dataset 2: IANA service/port CSV


echo Source: "%IANA_URL%"
echo Destination: "%IANA_FILE%"
echo.

REM Use Windows curl. -f fails on HTTP errors, -L follows redirects,
REM and -o writes the downloaded CSV to the intended destination.
curl.exe --fail --location --output "%IANA_FILE%" "%IANA_URL%"
if errorlevel 1 (
    echo.
    echo ERROR: Dataset 2 download failed.
    echo Check your internet connection and try again.
    echo.
    set "DATASET2_FAILED=1"
) else (
    echo Dataset 2 download completed.
)

echo.

echo Download Summary


echo Dataset 1 folder: "%DATASET1_DEST%"
echo Dataset 2 folder: "%DATASET2_DEST%"
echo.

if exist "%DATASET1_DEST%\" (
    echo Dataset 1 CSV files found:
    dir /b /s "%DATASET1_DEST%\*.csv" 2>nul | find /c /v ""
)
if exist "%IANA_FILE%" (
    echo Dataset 2 file downloaded:
    echo "%IANA_FILE%"
)

if defined DATASET1_FAILED (
    echo.
    echo WARNING: Dataset 1 did not finish successfully.
)
if defined DATASET2_FAILED (
    echo.
    echo WARNING: Dataset 2 did not finish successfully.
)

echo.
echo You can rerun this script to retry the downloads.
pause
endlocal
