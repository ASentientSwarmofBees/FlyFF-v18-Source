@echo off
title FlyFF Resource & Client Synchronizer

:: Self-elevate if administrative rights are required for file copying
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrative Privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: %~dp0 points to the Client folder. %~dp0..\ targets the parent directory.
set "DEST_DIR=%~dp0"
set "SOURCE_RES_DIR=%~dp0..\Server\ResClient"
set "SOURCE_NEUZ_DIR=%~dp0..\Source\Output\Neuz\NoGameguard"

echo Syncing client resource files and executable...
echo Client Dir: "%DEST_DIR%"
echo.

:: 1. Copy Resource Files (.res + Flyff.a)
if exist "%SOURCE_RES_DIR%" (
    echo [1/2] Copying resource files...
    xcopy "%SOURCE_RES_DIR%\data.res"     "%DEST_DIR%" /Y /Q
    xcopy "%SOURCE_RES_DIR%\dataSub1.res" "%DEST_DIR%" /Y /Q
    xcopy "%SOURCE_RES_DIR%\dataSub2.res" "%DEST_DIR%" /Y /Q
    xcopy "%SOURCE_RES_DIR%\Flyff.a"      "%DEST_DIR%" /Y /Q
) else (
    echo [WARNING] Source directory "%SOURCE_RES_DIR%" not found!
)

:: 2. Copy Freshly Compiled Neuz.exe
if exist "%SOURCE_NEUZ_DIR%\Neuz.exe" (
    echo [2/2] Copying fresh Neuz.exe...
    xcopy "%SOURCE_NEUZ_DIR%\Neuz.exe"    "%DEST_DIR%" /Y /Q
) else (
    echo [ERROR] Neuz.exe was not found in "%SOURCE_NEUZ_DIR%"!
    echo Please verify that your Visual Studio build succeeded.
    pause
    exit /b
)

echo.
echo Success! All client resources and Neuz.exe updated successfully.
timeout /t 1 >nul