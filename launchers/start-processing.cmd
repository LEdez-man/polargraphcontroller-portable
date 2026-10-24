@echo off
rem SPDX-License-Identifier: GPL-3.0-or-later
rem
rem Opens the Polargraph Controller sketch in Processing 2.2.1 (for working on the source code).
rem Processing is not part of the release package; see docs\development.md.

setlocal
set "PROCESSING=%~dp0processing-2.2.1\processing.exe"
set "SKETCH=%~dp0sketchbook\polargraphcontroller\polargraphcontroller.pde"

if not exist "%PROCESSING%" goto :noprocessing
if not exist "%SKETCH%" goto :nosketch

start "" "%PROCESSING%" "%SKETCH%"
exit /b 0

:noprocessing
echo Processing 2.2.1 not found in "%~dp0processing-2.2.1".
echo Download processing-2.2.1-windows64.zip from
echo https://github.com/processing/processing/releases/tag/processing-0227-2.2.1
echo and unpack it so that processing.exe is in that folder.
echo See docs\development.md.
pause
exit /b 1

:nosketch
echo Sketch not found: "%SKETCH%".
pause
exit /b 1
