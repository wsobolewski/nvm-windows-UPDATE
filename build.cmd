@echo off
SET INNOSETUP=%CD%\nvm.iss
SET ORIG=%CD%
REM SET GOPATH=%CD%\src
SET GOBIN=%CD%\bin
SET GOBINS=%CD%\bins
REM Support for older architectures
rem SET GOARCH=386

REM Cleanup existing build if it exists
if exist src\nvm.exe (
  del src\nvm.exe
)

REM Make the executable and add to the binary directory
echo ----------------------------
echo Building nvm.exe
echo ----------------------------
cd .\src
SET GOARCH=386
go build -o %GOBINS%\nvm.exe nvm.go
SET GOARCH=amd64
go build -o %GOBINS%\x64\nvm.exe nvm.go
SET GOARCH=arm64
go build -o %GOBINS%\arm64\nvm.exe nvm.go

REM Group the file with the helper binaries
rem move nvm.exe "%GOBIN%"
cd ..\

REM Codesign the executable
echo ----------------------------
echo Sign the nvm executable...
echo ----------------------------
buildtools\signtool.exe sign /debug /tr http://timestamp.sectigo.com /td sha256 /fd sha256 /a "%GOBINS%\nvm.exe"
buildtools\signtool.exe sign /debug /tr http://timestamp.sectigo.com /td sha256 /fd sha256 /a "%GOBINS%\x64\nvm.exe"
buildtools\signtool.exe sign /debug /tr http://timestamp.sectigo.com /td sha256 /fd sha256 /a "%GOBINS%\arm64\nvm.exe"

for /f %%i in ('"%GOBINS%\nvm.exe" version') do set AppVersion=%%i

echo nvm.exe v%AppVersion% built.

REM Create the distribution folder
SET DIST=%CD%\dist\%AppVersion%

REM Remove old build files if they exist.
if exist "%DIST%" (
  echo ----------------------------
  echo Clearing old build in %DIST%
  echo ----------------------------
  rd /s /q "%DIST%"
)

REM Create the distribution directory
mkdir "%DIST%"

REM Create the "no install" zip version
for %%a in ("%GOBIN%") do (buildtools\zip -j -9 -r "%DIST%\nvm-noinstall.zip" "%CD%\LICENSE" "%GOBINS%\nvm.exe" %%a\* -x "%GOBIN%\nodejs.ico" )
for %%a in ("%GOBIN%") do (buildtools\zip -j -9 -r "%DIST%\nvm-noinstall-x64.zip" "%CD%\LICENSE" "%GOBINS%\x64\nvm.exe" %%a\* -x "%GOBIN%\nodejs.ico")
for %%a in ("%GOBIN%") do (buildtools\zip -j -9 -r "%DIST%\nvm-noinstall-arm64.zip" "%CD%\LICENSE" "%GOBINS%\arm64\nvm.exe" %%a\* -x "%GOBIN%\nodejs.ico")

REM Generate update utility
REM echo ----------------------------
REM echo Generating update utility...
REM echo ----------------------------
REM cd .\updater
REM SET GOARCH=386
REM go build -o %DIST%\nvm-update.exe nvm-update.go
REM SET GOARCH=amd64
REM go build -o %DIST%\nvm-update-64.exe nvm-update.go
REM SET GOARCH=arm64
REM go build -o %DIST%\nvm-update-arm64.exe nvm-update.go
REM move nvm-update.exe "%DIST%"
REM cd ..\

REM Generate the installer (InnoSetup)
echo ----------------------------
echo Generating installer...
echo ----------------------------
buildtools\iscc "%INNOSETUP%" "/o%DIST%"

echo ----------------------------
echo Sign the installer
echo ----------------------------
buildtools\signtool.exe sign /debug /tr http://timestamp.sectigo.com /td sha256 /fd sha256 /a "%DIST%\nvm-setup.exe"

echo ----------------------------
echo Sign the updater...
echo ----------------------------
buildtools\signtool.exe sign /debug /tr http://timestamp.sectigo.com /td sha256 /fd sha256 /a "%DIST%\nvm-update.exe"
buildtools\signtool.exe sign /debug /tr http://timestamp.sectigo.com /td sha256 /fd sha256 /a "%DIST%\nvm-update-64.exe"
buildtools\signtool.exe sign /debug /tr http://timestamp.sectigo.com /td sha256 /fd sha256 /a "%DIST%\nvm-update-arm64.exe"

echo ----------------------------
echo Bundle the installer...
echo ----------------------------
buildtools\zip -j -9 -r "%DIST%\nvm-setup.zip" "%DIST%\nvm-setup.exe"


REM echo ----------------------------
REM echo Bundle the updater...
REM echo ----------------------------
REM buildtools\zip -j -9 -r "%DIST%\nvm-update.zip" "%DIST%\nvm-update.exe" "%DIST%\nvm-update-64.exe" "%DIST%\nvm-update-arm64.exe"

REM del "%DIST%\nvm-update.exe"
REM del "%DIST%\nvm-update-64.exe"
REM del "%DIST%\nvm-update-arm64.exe"
REM del "%DIST%\nvm-setup.exe"

REM Generate checksums
echo ----------------------------
echo Generating checksums...
echo ----------------------------
for %%f in ("%DIST%"\*.*) do (certutil -hashfile "%%f" MD5 | find /i /v "md5" | find /i /v "certutil" >> "%%f.checksum.txt")
echo complete

echo ----------------------------
echo Cleaning up...
echo ----------------------------
del "%GOBINS%\nvm.exe"
del "%GOBINS%\x64\nvm.exe"
del "%GOBINS%\arm64\nvm.exe"
echo complete
@REM del %GOBIN%\nvm-update.exe
@REM del %GOBIN%\nvm-setup.exe

echo NVM for Windows v%AppVersion% build completed. Available in %DIST%
@echo on
