@echo off
echo ========================================
echo Photo Lelo - React Native Setup
echo ========================================
echo.

echo This script will:
echo 1. Create a new React Native project
echo 2. Install required dependencies
echo 3. Copy app files
echo 4. Configure for building
echo.
echo This will take 10-15 minutes...
echo.
pause

echo.
echo Step 1: Creating React Native project...
call npx react-native init PhotoLeloApp

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to create React Native project
    pause
    exit /b 1
)

echo.
echo Step 2: Installing dependencies...
cd PhotoLeloApp
call npm install @react-navigation/native @react-navigation/stack
call npm install react-native-screens react-native-safe-area-context
call npm install react-native-gesture-handler react-native-reanimated
call npm install axios

echo.
echo Step 3: Copying app files...
xcopy /Y /I ..\mobile-app\App.js .
xcopy /Y /I ..\mobile-app\config.js .
xcopy /Y /I /E ..\mobile-app\screens screens\

echo.
echo Step 4: Configuring babel.config.js...
(
echo module.exports = {
echo   presets: ['module:metro-react-native-babel-preset'],
echo   plugins: ['react-native-reanimated/plugin'],
echo };
) > babel.config.js

echo.
echo ========================================
echo SETUP COMPLETE!
echo ========================================
echo.
echo Next steps:
echo 1. Update config.js with your server IP
echo 2. Run: build-android-apk.bat
echo.
cd ..
pause
