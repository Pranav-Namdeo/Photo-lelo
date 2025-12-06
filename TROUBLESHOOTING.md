# 🔧 Troubleshooting Guide - Photo Lelo App

## ✅ What Has Been Fixed

1. **Server Configuration**
   - ✅ Server now listens on `0.0.0.0` (all network interfaces)
   - ✅ CORS headers added for mobile app access
   - ✅ Test endpoint added at `/api/test`
   - ✅ Request logging enabled

2. **Android App Configuration**
   - ✅ `usesCleartextTraffic=true` in gradle.properties
   - ✅ Network security config added (allows HTTP)
   - ✅ AndroidManifest.xml updated with security config
   - ✅ Better error logging in LoginScreen
   - ✅ 10-second timeout for API requests

3. **Current Configuration**
   - IP Address: **192.168.1.2**
   - Port: **3000**
   - API URL: **http://192.168.1.2:3000**

## 📱 Step-by-Step Testing

### Step 1: Test from Computer Browser

Open in your computer browser:
```
http://192.168.1.2:3000/test-connection.html
```

Click all three test buttons. All should show ✅ SUCCESS.

**If this fails:** Server is not running or configured incorrectly.

### Step 2: Test from Phone Browser

1. Make sure phone is on **same WiFi** as computer
2. Open phone browser
3. Visit: `http://192.168.1.2:3000/test-connection.html`
4. Click all three test buttons

**If computer works but phone doesn't:**
- Phone is on different network (check WiFi name)
- Router has AP Isolation enabled
- Phone is using mobile data instead of WiFi

### Step 3: Test the App

1. Open PhotoLeloApp on phone
2. Enter enrollment number: `0246AL231072`
3. Enter password: `pranav`
4. Click Login

**If browser tests work but app doesn't:**
- App needs to be uninstalled and reinstalled
- App cache needs to be cleared
- Check app logs with `adb logcat`

## 🔍 Detailed Diagnostics

### Check 1: Is Server Running?

```bash
# Check if node process is running
Get-Process -Name node

# Should show server output
```

**Expected:** Server running at http://192.168.1.2:3000

### Check 2: Is Port 3000 Open?

```bash
Test-NetConnection -ComputerName 192.168.1.2 -Port 3000
```

**Expected:** TcpTestSucceeded : True

### Check 3: Can Computer Access Server?

```bash
curl http://192.168.1.2:3000/api/test
```

**Expected:** JSON response with status "ok"

### Check 4: What's Your IP?

```bash
ipconfig
```

Look for "IPv4 Address" under "Wireless LAN adapter Wi-Fi"

**Current IP:** 192.168.1.2

**If IP changed:**
1. Update `PhotoLeloApp/config.js`
2. Rebuild app: `cd PhotoLeloApp/android && ./gradlew assembleRelease`
3. Reinstall: `adb install -r app/build/outputs/apk/release/app-release.apk`

### Check 5: Is Phone on Same Network?

**Computer WiFi:** Check with `ipconfig`
**Phone WiFi:** Settings → WiFi → Check connected network name

**They must match!**

**Computer IP:** 192.168.1.x
**Phone IP:** 192.168.1.y (different last number)

### Check 6: View App Logs

Connect phone via USB and run:

```bash
adb logcat | findstr "ReactNative"
```

Or more detailed:

```bash
adb logcat | findstr "PhotoLelo"
```

Look for error messages when you try to login.

## 🚨 Common Issues and Solutions

### Issue 1: "Connection Error" in App

**Symptoms:** App shows "Unable to connect to server"

**Causes:**
1. Server not running
2. Wrong IP address
3. Phone on different network
4. Firewall blocking

**Solutions:**

**A. Restart Server**
```bash
# Stop any running node processes
Stop-Process -Name node -Force

# Start server
npm start
```

**B. Verify IP and Update Config**
```bash
# Check IP
ipconfig

# If IP changed, update PhotoLeloApp/config.js
# Then rebuild and reinstall app
```

**C. Check Same Network**
- Computer and phone must be on same WiFi
- Check WiFi name on both devices

**D. Test with Browser First**
- Open `http://192.168.1.2:3000/test-connection.html` on phone browser
- If this works, app should work too

### Issue 2: Server Not Accessible from Phone

**Symptoms:** Browser test works on computer but not on phone

**Causes:**
1. Router AP Isolation enabled
2. Phone on mobile data
3. Different WiFi networks
4. Firewall blocking external connections

**Solutions:**

**A. Check Router Settings**
- Log into router admin panel
- Look for "AP Isolation" or "Client Isolation"
- Disable it
- Restart router

**B. Verify Phone WiFi**
- Settings → WiFi
- Make sure connected to correct network
- Turn off mobile data temporarily
- Check IP address (should be 192.168.1.x)

**C. Try Mobile Hotspot**
- Enable hotspot on phone
- Connect computer to phone's hotspot
- Check new IP with `ipconfig`
- Update config.js with new IP
- Rebuild and reinstall app

**D. Temporarily Disable Firewall (Testing Only)**
```bash
# Windows Firewall
# Control Panel → Windows Defender Firewall
# Turn off for Private networks
# TEST APP
# Turn firewall back on!
```

### Issue 3: App Crashes on Startup

**Symptoms:** App closes immediately after opening

**Causes:**
1. Build error
2. Missing dependencies
3. Corrupted installation

**Solutions:**

**A. Reinstall App**
```bash
# Uninstall from phone
adb uninstall com.photoleloapp

# Reinstall
adb install PhotoLeloApp/android/app/build/outputs/apk/release/app-release.apk
```

**B. Check Logs**
```bash
adb logcat | findstr "AndroidRuntime"
```

**C. Rebuild from Scratch**
```bash
cd PhotoLeloApp/android
./gradlew clean
./gradlew assembleRelease
adb install -r app/build/outputs/apk/release/app-release.apk
```

### Issue 4: Login Fails with Correct Credentials

**Symptoms:** "Enrollment number not found" or "Incorrect password"

**Causes:**
1. User doesn't exist
2. Typo in enrollment number
3. API not returning users

**Solutions:**

**A. Verify User Exists**
- Check "Image save" folder
- Filename should match enrollment number
- Example: 0246AL231072.jpg

**B. Test API**
```bash
curl http://192.168.1.2:3000/api/users
```

Should return list of 59 users.

**C. Check Server Logs**
- Look at terminal running `npm start`
- Should show "Users endpoint hit from: ..."
- Should show "Returning 59 users"

**D. Try Different User**
- 0246AL231072
- 0246CD241002
- 0246CD241005

All use password: `pranav`

### Issue 5: Profile Image Not Loading

**Symptoms:** Login works but image doesn't show

**Causes:**
1. Image file missing
2. Wrong file path
3. Server not serving static files

**Solutions:**

**A. Verify Image Exists**
- Check "Image save" folder
- File should exist with correct name

**B. Test Image URL**
Open in browser:
```
http://192.168.1.2:3000/Image%20save/0246AL231072.jpg
```

Should show the image.

**C. Check Server Static Files**
Server.js should have:
```javascript
app.use(express.static(__dirname));
```

## 📊 Current System Status

### Server Status
- **Running:** Yes (Process ID: 5)
- **IP:** 192.168.1.2
- **Port:** 3000
- **CORS:** Enabled
- **Static Files:** Enabled

### App Status
- **Installed:** Yes
- **Version:** 0.0.1
- **Package:** com.photoleloapp
- **APK Size:** 56.6 MB
- **Config IP:** 192.168.1.2:3000

### Network Status
- **Computer IP:** 192.168.1.2
- **Network:** Wi-Fi
- **Port 3000:** Open
- **Firewall:** Node.js allowed

### Database Status
- **Users:** 59
- **Images:** 59 (PNG and JPG)
- **Default Password:** pranav

## 🎯 Quick Fixes

### Fix 1: Complete Reset

```bash
# Stop server
Stop-Process -Name node -Force

# Start server
npm start

# Uninstall app
adb uninstall com.photoleloapp

# Reinstall app
adb install PhotoLeloApp/android/app/build/outputs/apk/release/app-release.apk

# Test
```

### Fix 2: IP Address Changed

```bash
# Check new IP
ipconfig

# Update config (replace with your new IP)
# Edit PhotoLeloApp/config.js

# Rebuild
cd PhotoLeloApp/android
./gradlew assembleRelease

# Reinstall
adb install -r app/build/outputs/apk/release/app-release.apk
```

### Fix 3: Network Issues

```bash
# Use mobile hotspot
# 1. Enable hotspot on phone
# 2. Connect computer to hotspot
# 3. Check new IP: ipconfig
# 4. Update config.js
# 5. Rebuild and reinstall app
```

## 📞 Getting Help

If still not working, provide:

1. **Browser test results**
   - Computer: http://192.168.1.2:3000/test-connection.html
   - Phone: http://192.168.1.2:3000/test-connection.html

2. **Network info**
   ```bash
   ipconfig
   ```

3. **Server logs**
   - Copy output from terminal running `npm start`

4. **App logs**
   ```bash
   adb logcat | findstr "ReactNative" > app-logs.txt
   ```

5. **Phone info**
   - WiFi network name
   - Phone IP address (Settings → WiFi → Connected network)

## ✨ Success Checklist

- [ ] Server running on 192.168.1.2:3000
- [ ] Computer browser test passes
- [ ] Phone browser test passes
- [ ] Phone and computer on same WiFi
- [ ] App installed on phone
- [ ] Can login with test user (0246AL231072 / pranav)
- [ ] Profile image loads
- [ ] Can navigate between screens
- [ ] Can logout

Once all checked, app is fully functional! 🎉
