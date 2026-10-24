@echo off
rem SPDX-License-Identifier: GPL-3.0-or-later
rem
rem Same as start-polargraph.cmd, but keeps a console window open so that
rem log output and errors (e.g. from the serial connection) are visible.

setlocal
cd /d "%~dp0controller"
if not exist "jre\bin\java.exe" goto :nojre

set "CP=lib\polargraphcontroller.jar;lib\core.jar;lib\jogl-all.jar;lib\gluegen-rt.jar;lib\jogl-all-natives-windows-amd64.jar;lib\gluegen-rt-natives-windows-amd64.jar;lib\diewald_CV_kit.jar;lib\batikfont.jar;lib\geomerative.jar;lib\jssc.jar;lib\serial.jar;lib\controlP5.jar"

"jre\bin\java.exe" -Djna.nosys=true -Djava.library.path=lib -classpath "%CP%" polargraphcontroller

echo.
echo Polargraph Controller has exited. Press any key to close this window.
pause >nul
exit /b 0

:nojre
echo Java runtime not found in "%~dp0controller\jre".
echo See README.md, section "Java runtime".
pause
exit /b 1
