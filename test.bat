@echo off
setlocal

REM === Einstellungen ===
set DOWNLOAD_URL=https://github.com/java3east/RefineXModular/releases/download/latest/refinex.zip
set ZIP_FILE=refinex.zip
set EXTRACT_DIR=refinex
set JAR_FILE=RefineX-1.0-SNAPSHOT.jar
set LUA_SCRIPT=./test.lua

REM === Argumente prüfen ===
set KEEP=0
if "%~1"=="--keep" set KEEP=1
if "%~1"=="-k" set KEEP=1

REM === Falls Ordner schon existiert ===
if exist %EXTRACT_DIR% (
    if %KEEP%==1 (
        echo Folder "%EXTRACT_DIR%" already exists and will be kept.
        echo Skipping download and extraction.
        goto RUN_JAR
    ) else (
        echo Deleting old folder "%EXTRACT_DIR%"...
        rmdir /s /q %EXTRACT_DIR%
    )
)

echo [1/3] Downloading RefineX...
curl -L -o %ZIP_FILE% %DOWNLOAD_URL%
if errorlevel 1 (
    echo Error downloading!
    exit /b 1
)

echo [2/3] Extracting ZIP...
powershell -command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%EXTRACT_DIR%' -Force"
if errorlevel 1 (
    echo Error extracting!
    exit /b 1
)

:RUN_JAR
echo [3/3] Starting JAR...
java -jar "%EXTRACT_DIR%\%JAR_FILE%" RFX %LUA_SCRIPT%

REM === Cleanup, wenn nicht behalten ===
if %KEEP%==0 (
    echo Cleaning up extracted folder...
    rmdir /s /q %EXTRACT_DIR%
) else (
    echo Keeping extracted folder.
)

endlocal
