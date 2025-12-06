# Build React Native APK Guide

## Prerequisites

1. **Install Node.js** (v16 or higher)
   - Download from: https://nodejs.org/

2. **Install Java JDK 11**
   - Download from: https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html
   - Set JAVA_HOME environment variable

3. **Install Android Studio**
   - Download from: https://developer.android.com/studio
   - Install Android SDK (API 31 or higher)
   - Set ANDROID_HOME environment variable

4. **Install React Native CLI**
   ```bash
   npm install -g react-native-cli
   ```

## Step 1: Initialize React Native Project

```bash
npx react-native init PhotoLeloApp
cd PhotoLeloApp
```

## Step 2: Install Dependencies

```bash
npm install @react-navigation/native @react-navigation/stack
npm install react-native-screens react-native-safe-area-context
npm install react-native-gesture-handler react-native-reanimated
npm install axios
```

## Step 3: Copy App Files

Copy the following files from the `mobile-app` folder to your new project:

- `App.js` → `PhotoLeloApp/App.js`
- `config.js` → `PhotoLeloApp/config.js`
- `screens/` folder → `PhotoLeloApp/screens/`

## Step 4: Configure Android for Release Build

### 4.1 Generate Signing Key

```bash
cd android/app
keytool -genkeypair -v -storetype PKCS12 -keystore photolelo-release-key.keystore -alias photolelo-key-alias -keyalg RSA -keysize 2048 -validity 10000
```

Enter password: `pranav123` (or your choice)

### 4.2 Configure Gradle

Edit `android/gradle.properties` and add:

```properties
MYAPP_RELEASE_STORE_FILE=photolelo-release-key.keystore
MYAPP_RELEASE_KEY_ALIAS=photolelo-key-alias
MYAPP_RELEASE_STORE_PASSWORD=pranav123
MYAPP_RELEASE_KEY_PASSWORD=pranav123
```

### 4.3 Edit android/app/build.gradle

Add this inside `android` block:

```gradle
signingConfigs {
    release {
        if (project.hasProperty('MYAPP_RELEASE_STORE_FILE')) {
            storeFile file(MYAPP_RELEASE_STORE_FILE)
            storePassword MYAPP_RELEASE_STORE_PASSWORD
            keyAlias MYAPP_RELEASE_KEY_ALIAS
            keyPassword MYAPP_RELEASE_KEY_PASSWORD
        }
    }
}
buildTypes {
    release {
        signingConfig signingConfigs.release
        minifyEnabled enableProguardInReleaseBuilds
        proguardFiles getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro"
    }
}
```

## Step 5: Build Release APK

### Option 1: Build Release APK (Recommended)

```bash
cd android
./gradlew assembleRelease
```

The APK will be at:
`android/app/build/outputs/apk/release/app-release.apk`

### Option 2: Build Debug APK (Faster)

```bash
cd android
./gradlew assembleDebug
```

The APK will be at:
`android/app/build/outputs/apk/debug/app-debug.apk`

### Option 3: Build AAB (For Play Store)

```bash
cd android
./gradlew bundleRelease
```

The AAB will be at:
`android/app/build/outputs/bundle/release/app-release.aab`

## Step 6: Install APK on Device

### Via USB:

```bash
adb install android/app/build/outputs/apk/release/app-release.apk
```

### Via File Transfer:

1. Copy the APK to your phone
2. Enable "Install from Unknown Sources" in Settings
3. Open the APK file and install

## Troubleshooting

### Error: SDK location not found

Create `android/local.properties`:
```
sdk.dir=C:\\Users\\YourUsername\\AppData\\Local\\Android\\Sdk
```

### Error: JAVA_HOME not set

Set environment variable:
```bash
setx JAVA_HOME "C:\Program Files\Java\jdk-11.0.x"
```

### Error: Gradle build failed

Clean and rebuild:
```bash
cd android
./gradlew clean
./gradlew assembleRelease
```

### Error: Metro bundler issues

```bash
npx react-native start --reset-cache
```

## Quick Build Script (Windows)

Save as `build-apk.bat`:

```batch
@echo off
echo Building Photo Lelo APK...
cd android
call gradlew clean
call gradlew assembleRelease
echo.
echo APK built successfully!
echo Location: android\app\build\outputs\apk\release\app-release.apk
pause
```

## App Configuration

Before building, update `config.js` with your server IP:

```javascript
export const API_BASE_URL = 'http://YOUR_IP:3000';
```

## Testing the APK

1. Install the APK on your Android device
2. Make sure your server is running: `npm start`
3. Ensure your phone and server are on the same network
4. Open the app and login with any enrollment number
5. Password: `pranav`

## File Sizes

- Debug APK: ~50-70 MB
- Release APK: ~25-35 MB (optimized)
- AAB: ~20-30 MB (for Play Store)

## Next Steps

After successful build:
1. Test the APK on multiple devices
2. Optimize app size if needed
3. Add app icon and splash screen
4. Submit to Play Store (if desired)
