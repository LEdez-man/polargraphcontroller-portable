@echo off
rem SPDX-License-Identifier: GPL-3.0-or-later
rem
rem Starts Polargraph Controller 2.4.2 with the Java runtime in controller\jre
rem instead of the Java installed on the system.
rem -Djava.library.path=lib lets jSSC find lib\jSSC-2.8.dll (native serial library).

setlocal
cd /d "%~dp0controller"
if not exist "jre\bin\javaw.exe" goto :nojre

set "CP=lib\polargraphcontroller.jar;lib\core.jar;lib\jogl-all.jar;lib\gluegen-rt.jar;lib\jogl-all-natives-windows-amd64.jar;lib\gluegen-rt-natives-windows-amd64.jar;lib\diewald_CV_kit.jar;lib\batikfont.jar;lib\geomerative.jar;lib\jssc.jar;lib\serial.jar;lib\controlP5.jar"

start "" "jre\bin\javaw.exe" -Djna.nosys=true -Djava.library.path=lib -classpath "%CP%" polargraphcontroller
exit /b 0

:nojre
echo Java runtime not found in "%~dp0controller\jre".
echo See README.md, section "Java runtime".
pause
exit /b 1
