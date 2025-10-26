@echo off
SET INNOSETUP=%CD%\nvm.iss
SET ORIG=%CD%
SET GOBIN=%CD%\bin

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
go build -o %GOBIN%\nvm-386.exe nvm.go
SET GOARCH=amd64
go build -o %GOBIN%\nvm-amd64.exe nvm.go
SET GOARCH=arm64
go build -o %GOBIN%\nvm-arm64.exe nvm.go

REM Group the file with the helper binaries
rem move nvm.exe "%GOBIN%"
cd ..\

REM Codesign the executable
echo ----------------------------
echo Sign the nvm executable...
echo ----------------------------
buildtools\signtool.exe sign /debug /tr http://timestamp.sectigo.com /td sha256 /fd sha256 /a "%GOBIN%\nvm-386.exe"
buildtools\signtool.exe sign /debug /tr http://timestamp.sectigo.com /td sha256 /fd sha256 /a "%GOBIN%\nvm-amd64.exe"
buildtools\signtool.exe sign /debug /tr http://timestamp.sectigo.com /td sha256 /fd sha256 /a "%GOBIN%\nvm-arm64.exe"

for /f %%i in ('"%GOBIN%\nvm-386.exe" version') do set AppVersion=%%i
for /f %%i in ('"%GOBIN%\nvm-amd64.exe" version') do set AppVersion=%%i
for /f %%i in ('"%GOBIN%\nvm-arm64.exe" version') do set AppVersion=%%i

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
for %%a in ("%GOBIN%") do (buildtools\zip -j -9 -r "%DIST%\nvm-noinstall.zip" "%CD%\LICENSE" %%a\* -x "%GOBIN%\nodejs.ico" )

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
echo Bundle the installer...
echo ----------------------------
buildtools\zip -j -9 -r "%DIST%\nvm-setup.zip" "%DIST%\nvm-setup.exe"

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
del "%GOBIN%\nvm-386.exe"
del "%GOBIN%\nvm-amd64.exe"
del "%GOBIN%\nvm-arm64.exe"
echo complete
@REM del %GOBIN%\nvm-update.exe
@REM del %GOBIN%\nvm-setup.exe

echo NVM for Windows v%AppVersion% build completed. Available in %DIST%
@echo on
