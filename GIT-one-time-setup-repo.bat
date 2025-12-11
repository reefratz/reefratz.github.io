@echo off
setlocal enabledelayedexpansion

:: ============================================
:: GitHub Private Repo Setup Script
:: Usage: setup-repo.bat <repo-name> <github-username>
:: ============================================

:: Check if parameters were provided
if "%~1"=="" (
    echo.
    echo Usage: setup-repo.bat ^<repo-name^> ^<github-username^>
    echo Example: setup-repo.bat my-awesome-project jvv0
    echo.
    pause
    exit /b 1
)

if "%~2"=="" (
    echo.
    echo Usage: setup-repo.bat ^<repo-name^> ^<github-username^>
    echo Example: setup-repo.bat my-awesome-project jvv0
    echo.
    pause
    exit /b 1
)

set "REPO_NAME=%~1"
set "GITHUB_USER=%~2"
set "CURRENT_DIR=%CD%"

echo.
echo ========================================
echo  GitHub Private Repo Setup Wizard
echo ========================================
echo.
echo Repository Name: %REPO_NAME%
echo GitHub User:     %GITHUB_USER%
echo Directory:       %CURRENT_DIR%
echo.
echo This wizard will walk you through:
echo   1. Creating .gitignore file
echo   2. Creating the repo on GitHub.com
echo   3. Initializing git locally
echo   4. Pushing your code
echo.
echo ----------------------------------------
echo  SECURITY WARNING
echo ----------------------------------------
echo.
echo BEFORE PROCEEDING, make sure this folder does NOT contain:
echo   - Passwords or API keys in code files
echo   - .env files with secrets
echo   - Private keys (.pem, .key files)
echo   - Database connection strings with passwords
echo.
echo The .gitignore will help, but double-check sensitive files!
echo.
pause

:: ==========================================
:: STEP 1: CREATE .GITIGNORE
:: ==========================================
cls
echo.
echo ========================================
echo  STEP 1 of 4: Create .gitignore
echo ========================================
echo.

if exist .gitignore (
    echo A .gitignore file already exists in this folder.
    echo.
    set /p OVERWRITE="Overwrite with new .gitignore? (Y/N): "
    if /i not "!OVERWRITE!"=="Y" (
        echo.
        echo Keeping existing .gitignore
        echo.
        pause
        goto :step2
    )
)

echo Creating .gitignore file...
echo.

(
echo # Excluded file types
echo *.zip
echo *.7z
echo *.exe
echo *.dll
echo *.so
echo *.dylib
echo *.jpg
echo *.png
echo *.txt
echo.
echo # Node.js
echo node_modules/
echo npm-debug.log*
echo yarn-debug.log*
echo yarn-error.log*
echo .npm
echo .yarn
echo package-lock.json
echo yarn.lock
echo.
echo # Go
echo *.exe~
echo bin/
echo vendor/
echo go.work
echo.
echo # IDE and Editor
echo .idea/
echo .vscode/
echo *.swp
echo *.swo
echo *~
echo.
echo # OS Generated
echo .DS_Store
echo Thumbs.db
echo Desktop.ini
echo.
echo # Environment and secrets - NEVER COMMIT THESE
echo .env
echo .env.local
echo .env.*.local
echo .env.development
echo .env.production
echo *.pem
echo *.key
echo *.p12
echo *.pfx
echo secrets.json
echo config.local.*
echo credentials.*
echo.
echo # Build outputs
echo dist/
echo build/
echo out/
echo.
echo # Logs and temp
echo logs/
echo *.log
echo tmp/
echo temp/
echo .cache/
) > .gitignore

echo [SUCCESS] .gitignore created!
echo.
echo The following will be excluded from your repo:
echo   - *.zip and *.exe files
echo   - node_modules/ folder
echo   - Go binaries and vendor/
echo   - IDE settings (.idea/, .vscode/)
echo   - Environment files (.env)
echo   - OS junk files (Thumbs.db, .DS_Store)
echo.
pause

:: ==========================================
:: STEP 2: CREATE REPO ON GITHUB.COM
:: ==========================================
:step2
cls
echo.
echo ========================================
echo  STEP 2 of 4: Create Repo on GitHub
echo ========================================
echo.
echo I will now open GitHub in your browser.
echo.
echo FOLLOW THESE STEPS CAREFULLY:
echo.
echo   1. Sign in to GitHub if needed
echo.
echo   2. For "Repository name" enter EXACTLY:
echo      %REPO_NAME%
echo.
echo   3. For "Description" enter whatever you like
echo      (or leave blank)
echo.
echo   4. Select: (*) PRIVATE  ^<^<^< IMPORTANT!
echo.
echo   5. IMPORTANT - Leave these UNCHECKED:
echo      [ ] Add a README file
echo      [ ] Add .gitignore
echo      [ ] Choose a license
echo.
echo   6. Click the green "Create repository" button
echo.
echo ----------------------------------------
echo  SECURITY REMINDER
echo ----------------------------------------
echo.
echo While you're on GitHub, verify these settings:
echo.
echo   Settings ^> Emails:
echo     [x] Keep my email addresses private
echo     [x] Block command line pushes that expose my email
echo.
echo   Settings ^> Code security and analysis:
echo     [x] Push protection (blocks secrets from being pushed)
echo.
echo ----------------------------------------
echo.
set /p OPEN_BROWSER="Ready to open GitHub? (Y/N): "
if /i not "%OPEN_BROWSER%"=="Y" (
    echo.
    echo Please open this URL manually:
    echo https://github.com/new
    echo.
) else (
    start https://github.com/new
)

echo.
echo ----------------------------------------
echo.
echo After you've created the repo on GitHub,
echo come back here and continue.
echo.
pause

:: Verify they created it
echo.
set /p CREATED="Did you create the repo on GitHub? (Y/N): "
if /i not "%CREATED%"=="Y" (
    echo.
    echo Please create the repo first, then run this script again.
    echo.
    pause
    exit /b 0
)

:: Double-check repo name
echo.
echo You said the repo name is: %REPO_NAME%
set /p NAME_CORRECT="Is this EXACTLY what you named it on GitHub? (Y/N): "
if /i not "%NAME_CORRECT%"=="Y" (
    echo.
    set /p REPO_NAME="Enter the correct repo name: "
    echo.
    echo Updated repo name to: !REPO_NAME!
)

echo.
pause

:: ==========================================
:: STEP 3: INITIALIZE LOCAL GIT
:: ==========================================
:step3
cls
echo.
echo ========================================
echo  STEP 3 of 4: Initialize Local Git
echo ========================================
echo.

if exist .git (
    echo Git is already initialized in this folder.
    echo.
    :: Check for existing remote
    git remote get-url origin >nul 2>nul
    if !ERRORLEVEL! equ 0 (
        echo Current remote origin:
        git remote get-url origin
        echo.
        set /p REMOVE_REMOTE="Remove and replace with new repo? (Y/N): "
        if /i "!REMOVE_REMOTE!"=="Y" (
            git remote remove origin
            echo Removed old remote.
        ) else (
            echo.
            echo Keeping existing remote. Skipping to push step.
            pause
            goto :step4
        )
    )
) else (
    echo Initializing git repository...
    git init
    echo.
    echo [SUCCESS] Git initialized!
)

echo.
echo Adding remote origin...
echo https://github.com/%GITHUB_USER%/%REPO_NAME%.git
echo.
git remote add origin https://github.com/%GITHUB_USER%/%REPO_NAME%.git

if %ERRORLEVEL% equ 0 (
    echo [SUCCESS] Remote added!
) else (
    echo [ERROR] Failed to add remote. It may already exist.
)

echo.
pause

:: ==========================================
:: STEP 4: COMMIT AND PUSH
:: ==========================================
:step4
cls
echo.
echo ========================================
echo  STEP 4 of 4: Commit and Push
echo ========================================
echo.

echo Adding all files to git...
git add .
echo.

:: Show what will be committed
echo Files staged for commit:
echo ----------------------------------------
git status --short
echo ----------------------------------------
echo.

:: Prompt for commit message
set /p COMMIT_MSG="Enter commit message (or Enter for 'Initial commit'): "
if "%COMMIT_MSG%"=="" set "COMMIT_MSG=Initial commit"

echo.
echo Committing with message: %COMMIT_MSG%
git commit -m "%COMMIT_MSG%"

echo.
echo Setting branch to 'main' and pushing to GitHub...
echo (You may be prompted for GitHub credentials)
echo.
git branch -M main
git push -u origin main

if %ERRORLEVEL% equ 0 (
    echo.
    echo ========================================
    echo  SUCCESS! Your repo is ready!
    echo ========================================
    echo.
    echo View your repo at:
    echo https://github.com/%GITHUB_USER%/%REPO_NAME%
    echo.
    echo ----------------------------------------
    echo  SECURITY CHECKLIST
    echo ----------------------------------------
    echo.
    echo Make sure you've done these ONE-TIME setups:
    echo.
    echo   [x] Enable Two-Factor Authentication ^(2FA^)
    echo       Settings ^> Password and authentication ^> 2FA
    echo.
    echo   [x] Make profile private
    echo       Settings ^> Public profile:
    echo       [x] Make profile private and hide activity
    echo       [ ] Include private contributions ^(leave UNCHECKED^)
    echo.
    echo   [x] Hide your email
    echo       Settings ^> Emails:
    echo       [x] Keep my email addresses private
    echo       [x] Block command line pushes that expose my email
    echo.
    echo   [x] Enable push protection
    echo       Settings ^> Code security and analysis:
    echo       [x] Push protection
    echo.
    echo ----------------------------------------
    echo.
    set /p OPEN_REPO="Open repo in browser? (Y/N): "
    if /i "!OPEN_REPO!"=="Y" (
        start https://github.com/%GITHUB_USER%/%REPO_NAME%
    )
) else (
    echo.
    echo ========================================
    echo  PUSH FAILED
    echo ========================================
    echo.
    echo Common issues:
    echo   - Repo name doesn't match what's on GitHub
    echo   - Repo wasn't created as empty (has README)
    echo   - Authentication issue
    echo.
    echo Try:
    echo   git push -u origin main
    echo.
)

echo.
pause
endlocal
