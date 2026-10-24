@echo off
rem SPDX-License-Identifier: GPL-3.0-or-later
rem
rem Optional: makes the ORIGINAL polargraphcontroller.exe work with a 64-bit system Java.
rem The exe does not tell jSSC where its native DLL is, so jSSC looks in
rem %USERPROFILE%\.jssc\windows\ and fails if only the 32-bit DLL is there.
rem This copies the 64-bit DLL to that folder. The portable launchers do not need it.

setlocal
set "SRC=%~dp0controller\lib\jSSC-2.8.dll"
set "DST_DIR=%USERPROFILE%\.jssc\windows"
set "DST=%DST_DIR%\jSSC-2.8_x86_64.dll"

if not exist "%SRC%" goto :nosrc
if exist "%DST%" goto :present
if not exist "%DST_DIR%" mkdir "%DST_DIR%"
copy /y "%SRC%" "%DST%" >nul
if errorlevel 1 goto :failed
echo Copied the 64-bit jSSC DLL to "%DST%".
pause
exit /b 0

:present
echo Already present: "%DST%". Nothing to do.
pause
exit /b 0

:nosrc
echo Not found: "%SRC%".
pause
exit /b 1

:failed
echo Copying to "%DST%" failed.
pause
exit /b 1
