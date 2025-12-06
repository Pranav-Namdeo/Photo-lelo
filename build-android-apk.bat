@echo off
echo ========================================
echo Photo Lelo - Android APK Builder
echo ========================================
echo.

REM Check if React Native project exists
if not exist "PhotoLeloApp\android" (
    echo ERROR: React Native project not found!
    echo.
    echo Please run these commands first:
    echo 1. npx react-native init PhotoLeloApp
    echo 2. Copy app files to PhotoLeloApp folder
    echo 3. Run this script again
    echo.
    pause
    exit /b 1
)

echo Step 1: Navigating to Android directory...
cd PhotoLeloApp\android

echo.
echo Step 2: Cleaning previous builds...
call gradlew clean

echo.
echo Step 3: Building Release APK...
echo This may take 5-10 minutes...
call gradlew assembleRelease

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo BUILD SUCCESSFUL!
    echo ========================================
    echo.
    echo APK Location:
    echo %CD%\app\build\outputs\apk\release\app-release.apk
    echo.
    echo File size:
    dir app\build\outputs\apk\release\app-release.apk | find "app-release.apk"
    echo.
    echo To install on device:
    echo adb install app\build\outputs\apk\release\app-release.apk
    echo.
) else (
    echo.
    echo ========================================
    echo BUILD FAILED!
    echo ========================================
    echo.
    echo Please check the error messages above.
    echo Common fixes:
    echo 1. Make sure JAVA_HOME is set
    echo 2. Make sure ANDROID_HOME is set
    echo 3. Run: gradlew clean
    echo.
)

cd ..\..
pause
