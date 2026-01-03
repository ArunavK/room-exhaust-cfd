@echo off
SETLOCAL

REM Check if a directory name argument was provided
IF "%1" == "" (
    ECHO Error: No directory name provided.
    ECHO Usage: %0 <NewDirectoryName>
    GOTO :End
)

REM Set the name of the new directory from the first command-line argument (%1)
SET "dest_dir=%1"

REM --- Configuration ---
REM Set the source directory (use quotes for paths with spaces)
SET "source_dir=C:\Users\kashy\AppData\Local\Temp\case"

REM Define the files to copy using wildcards or specific names
REM Separate multiple patterns with spaces, e.g., "*.txt *.log report.pdf"
SET "file_patterns=*.txt *.log"
REM ---------------------

REM Create the destination directory
IF NOT EXIST "%dest_dir%" (
    MKDIR "%dest_dir%"
    ECHO Created directory: "%dest_dir%"
) ELSE (
    ECHO Directory "%dest_dir%" already exists.
)

REM Copy the specified files
ECHO Copying files from "%source_dir%" to "%dest_dir%"...
FOR %%F IN (%file_patterns%) DO (
    IF EXIST "%source_dir%\%%F" (
        COPY "%source_dir%\%%F" "%dest_dir%\"
    ) ELSE (
        ECHO Warning: File pattern "%%F" not found in source directory.
    )
)

ECHO File copy operation complete.

:End
PAUSE
ENDLOCAL

