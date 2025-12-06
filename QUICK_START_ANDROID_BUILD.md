# Quick Start: Build Android APK

## Prerequisites Check

Run these commands to verify your setup:

```bash
node --version        # Should be v16 or higher
npm --version         # Should be 8 or higher
java -version         # Should be Java 11 or higher
```

If any are missing, install them first.

## Method 1: Automated Setup (Recommended)

### Step 1: Run Setup Script

```bash
setup-react-native-project.bat
```

This will:
- Create React Native project
- Install all dependencies
- Copy app files
- Configure the project

### Step 2: Update Server IP

Edit `PhotoLeloApp/config.js`:
```javascript
export const API_BASE_URL = 'http://YOUR_COMPUTER_IP:3000';
```

Find your IP: Run `ipconfig` and look for IPv4 Address

### Step 3: Build APK

```bash
build-android-apk.bat
```

The APK will be at:
`PhotoLeloApp/android/app/build/outputs/apk/release/app-release.apk`

## Method 2: Manual Setup

### Step 1: Create Project

```bash
npx react-native init PhotoLeloApp
cd PhotoLeloApp
```

### Step 2: Install Dependencies

```bash
npm install @react-navigation/native @react-navigation/stack
npm install react-native-screens react-native-safe-area-context  
npm install react-native-gesture-handler react-native-reanimated
npm install axios
```

### Step 3: Copy Files

Copy these files from `mobile-app` to `PhotoLeloApp`:
- `App.js`
- `config.js`
- `screens/` folder

### Step 4: Update babel.config.js

```javascript
module.exports = {
  presets: ['module:metro-react-native-babel-preset'],
  plugins: ['react-native-reanimated/plugin'],
};
```

### Step 5: Build APK

```bash
cd android
gradlew assembleRelease
```

## Install APK on Phone

### Option 1: USB Cable

```bash
adb devices
adb install PhotoLeloApp/android/app/build/outputs/apk/release/app-release.apk
```

### Option 2: File Transfer

1. Copy APK to phone
2. Enable "Install from Unknown Sources"
3. Tap APK file to install

## Testing

1. Make sure server is running: `npm start`
2. Phone and computer on same WiFi
3. Open app
4. Login with enrollment number
5. Password: `pranav`

## Troubleshooting

### "SDK location not found"

Create `PhotoLeloApp/android/local.properties`:
```
sdk.dir=C:\\Users\\YOUR_USERNAME\\AppData\\Local\\Android\\Sdk
```

### "JAVA_HOME not set"

```bash
setx JAVA_HOME "C:\Program Files\Java\jdk-11"
```

### Build fails

```bash
cd PhotoLeloApp/android
gradlew clean
gradlew assembleRelease
```

### Can't connect to server

1. Check server is running
2. Verify IP in config.js
3. Check firewall allows port 3000
4. Both devices on same network

## Build Variants

### Debug APK (Faster, Larger)
```bash
gradlew assembleDebug
```
Output: `app/build/outputs/apk/debug/app-debug.apk`

### Release APK (Slower, Optimized)
```bash
gradlew assembleRelease
```
Output: `app/build/outputs/apk/release/app-release.apk`

### AAB for Play Store
```bash
gradlew bundleRelease
```
Output: `app/build/outputs/bundle/release/app-release.aab`

## Expected Build Time

- First build: 10-15 minutes
- Subsequent builds: 3-5 minutes
- Clean build: 5-8 minutes

## APK Size

- Debug: ~50-70 MB
- Release: ~25-35 MB

## What's Next?

After successful build:
1. ✅ Test on multiple Android devices
2. ✅ Add app icon (optional)
3. ✅ Add splash screen (optional)
4. ✅ Optimize performance
5. ✅ Submit to Play Store (optional)

## Support

If you encounter issues:
1. Check BUILD_APK_GUIDE.md for detailed instructions
2. Verify all prerequisites are installed
3. Make sure Android SDK is properly configured
4. Check Java and Node versions
