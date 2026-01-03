@echo off

REM Source runtime environment

set FOAMDIR="C:\Apps\blueCFD-Core-2024"
set CWD=%CD%

if 12 GEQ 1000 goto OPENCFD
:FOUNDATION
set OLDPATH=%PATH%
call %FOAMDIR%\setvars_OF12.bat
set PATH=%PATH%;%OLDPATH%

REM Fix for error in FOAM_MPI in setvars-OF.bat
FOR /F "tokens=* USEBACKQ" %%F IN (`dir /b %%FOAM_LIBBIN%%\MS-MPI*`) DO (
SET FOAM_MPI=%%F
)
set PATH=%FOAM_LIBBIN%\%FOAM_MPI%;%PATH%
goto CONTINUE

:OPENCFD
call %FOAMDIR%\setEnvVariables-v12.bat

:CONTINUE

cd /d %CWD%

REM Run PowerShell script
PowerShell -NoProfile -ExecutionPolicy Bypass -File Allrun.ps1
