@echo off
REM -------------------------------------------------------------
REM  NVM for Windows – Install from the script's own location
REM -------------------------------------------------------------

REM Set the destination folder in the user's AppData
set NVM_HOME=%APPDATA%\nvm
set NVM_SYMLINK=%APPDATA%\nodejs

REM Persist environment variables (system‑wide)
setx NVM_HOME "%NVM_HOME%"
setx NVM_SYMLINK "%NVM_SYMLINK%"

REM Append the new paths to PATH so that nvm.exe is immediately usable
setx PATH "%PATH%;%NVM_HOME%;%NVM_SYMLINK%"

REM Detect OS architecture (PowerShell or WMIC fallback)
set SYS_ARCH=unknown

for /f %%i in ('powershell -command "[System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture"') do (
    set SYS_ARCH=%%i
)

if "%SYS_ARCH%"=="unknown" (
    for /f "tokens=2 delims==" %%a in ('wmic cpu get Architecture /value ^| find "="') do (
        if "%%a"=="9" set SYS_ARCH=X64
        if "%%a"=="6" set SYS_ARCH=ARM64
        if "%%a"=="0" set SYS_ARCH=x86
    )
)

REM Choose the correct binary based on architecture
if /i "%SYS_ARCH%"=="ARM64" (
    set NVM_BINARY=nvm-arm64.exe
) else if /i "%SYS_ARCH%"=="X64" (
    set NVM_BINARY=nvm-amd64.exe
) else (
    set NVM_BINARY=nvm-386.exe
)

echo Using binary: %NVM_BINARY%
mkdir %APPDATA%\nvm
mkdir %APPDATA%\nodejs
REM Copy the binary from the script's directory to the destination folder
copy "%~dp0%NVM_BINARY%" "%NVM_HOME%\nvm.exe" >nul
copy "%~dp0nodejs.ico" "%NVM_HOME%\nodejs.ico" >nul

REM Write a simple settings file for future reference
(
    echo root: %NVM_HOME%
    echo path: %NVM_SYMLINK%
    echo arch: %SYS_ARCH%
    echo proxy: none
) > "%NVM_HOME%\settings.txt"

echo ===========================================================
echo NVM for Windows installation complete!
echo Root: %NVM_HOME%
echo Path: %NVM_SYMLINK%
echo OS Arch: %SYS_ARCH%
echo.
echo Open a new terminal and run: nvm version
echo ===========================================================

pause
@echo on
