@echo off
REM ===================================================
REM Setup AdGuard EDNS Auto-Update in C:\Adguard-Home-EDNS-Auto
REM ===================================================

@echo off
REM Check for admin privileges
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO Requesting administrative privileges...
    powershell -Command "Start-Process -FilePath '%~dpnx0' -Verb RunAs"
    EXIT /B
)

SET TARGET_DIR=C:\Adguard-Home-EDNS-Auto
SET SOURCE_DIR=%~dp0
SET PS_SCRIPT=vietnam_ecs_optimizer.ps1
SET TASK_NAME=EDNSAutoUpdate

REM Create target directory if it doesn't exist
IF NOT EXIST "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%"
    echo Created directory %TARGET_DIR%
)

REM Copy PowerShell script to target directory
IF EXIST "%SOURCE_DIR%%PS_SCRIPT%" (
    copy /Y "%SOURCE_DIR%%PS_SCRIPT%" "%TARGET_DIR%" >nul
    echo Copied %PS_SCRIPT% to %TARGET_DIR%
) ELSE (
    echo ERROR: %PS_SCRIPT% not found in %SOURCE_DIR%
    pause
    exit /b 1
)

REM Delete existing Task Scheduler task if present
schtasks /Delete /TN "%TASK_NAME%" /F >nul 2>&1

REM Create a new scheduled task to run the script every 5 minutes
schtasks /Create ^
    /SC MINUTE ^
    /MO 5 ^
    /TN "%TASK_NAME%" ^
    /TR "powershell -NoProfile -ExecutionPolicy Bypass -File \"%TARGET_DIR%\%PS_SCRIPT%\"" ^
    /RL HIGHEST ^
    /F ^
    /RU SYSTEM

IF %ERRORLEVEL% EQU 0 (
    echo Task "%TASK_NAME%" created successfully.
    echo It will run every 5 minutes from %TARGET_DIR%.
) ELSE (
    echo Failed to create scheduled task. Try running this script as Administrator.
)

pause
