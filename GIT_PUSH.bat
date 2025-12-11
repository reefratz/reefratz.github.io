@echo off
REM Git Push Script
REM Double-click to run

echo ========================================
echo JVV0 Git Push
echo ========================================
echo.

REM Prompt user for commit message
set /p commit_msg="Enter commit message: "

REM Check if message was provided
if "%commit_msg%"=="" (
    echo ERROR: Commit message cannot be empty
    pause
    exit /b 1
)

echo.
echo Adding all changes...
git add .

echo.
echo Committing with message: %commit_msg%
git commit -m "%commit_msg%"

echo.
echo Pushing to GitHub...
git push origin main

echo.
echo ========================================
echo Done! Check: https://github.com/jvv0
echo ========================================
echo.
pause