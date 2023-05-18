@echo off
set "sourceFolder=%cd%\%1"
set "destinationFolder=%2\garrysmod\addons\%1"

if not exist "%sourceFolder%" (
    echo Source folder does not exist.
    exit /b
)

xcopy "%sourceFolder%" "%destinationFolder%" /E /I /Q /Y
