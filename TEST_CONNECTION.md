# Connection Troubleshooting Guide

## Current Status

✅ **Server is running** on http://192.168.1.2:3000  
✅ **CORS enabled** for mobile app access  
✅ **API endpoints working** (/api/users returns 59 users)  
✅ **Firewall allows Node.js**

## Test from Your Phone

### Step 1: Test Server Connection

Open your phone's browser and visit:
```
http://192.168.1.2:3000/api/test
```

**Expected Result:**
```json
{
  "status": "ok",
  "message": "Server is running!",
  "timestamp": "2025-12-06T..."
}
```

If this works, the server is accessible from your phone.

### Step 2: Test Users Endpoint

Open your phone's browser and visit:
```
http://192.168.1.2:3000/api/users
```

**Expected Result:** A long JSON list of 59 users with usernames and passwords.

If this works, the API is working correctly.

### Step 3: Test Photo Manager

Open your phone's browser and visit:
```
http://192.168.1.2:3000/photomanager.html
```

Login with password: `pranav`

If this works, your phone can access the web interface.

## If Browser Tests Work But App Doesn't

This means the issue is in the app configuration. Try these:

### Option 1: Clear App Data

1. Go to Settings → Apps → PhotoLeloApp
2. Clear Storage/Cache
3. Open app again

### Option 2: Reinstall App

The app might have cached the old IP. Let me rebuild it:

```bash
cd PhotoLeloApp/android
./gradlew assembleRelease
adb install -r app/build/outputs/apk/release/app-release.apk
```

### Option 3: Check App Logs

Connect phone via USB and run:
```bash
adb logcat | grep -i "react"
```

This will show any error messages from the app.

## If Browser Tests Don't Work

### Check 1: Same Network?

**Computer WiFi:** Run `ipconfig` and check WiFi adapter
**Phone WiFi:** Check WiFi settings

They must be on the **same network** (same WiFi name).

### Check 2: Phone's IP Range

Your computer is on 192.168.1.2
Your phone should be on 192.168.1.x (where x is different number)

To check phone's IP:
- Settings → WiFi → Tap connected network → View IP address

### Check 3: Router Settings

Some routers have "AP Isolation" or "Client Isolation" enabled.
This prevents devices from talking to each other.

**Fix:** Log into your router and disable AP Isolation.

### Check 4: Mobile Data

Make sure your phone is using **WiFi**, not mobile data!

## Quick Fixes

### Fix 1: Restart Everything

1. Stop server (Ctrl+C)
2. Restart server: `npm start`
3. Restart phone WiFi (turn off/on)
4. Try app again

### Fix 2: Use Different Port

If port 3000 is blocked, try port 8080:

1. Edit `server.js`: Change `PORT = 3000` to `PORT = 8080`
2. Edit `PhotoLeloApp/config.js`: Change `:3000` to `:8080`
3. Rebuild app
4. Restart server

### Fix 3: Disable Windows Firewall Temporarily

**WARNING:** Only for testing!

1. Windows Security → Firewall & network protection
2. Turn off for Private networks
3. Test app
4. Turn firewall back on

If this works, add a firewall rule for Node.js.

## Current Server Configuration

**IP Address:** 192.168.1.2  
**Port:** 3000  
**CORS:** Enabled (allows all origins)  
**Endpoints:**
- GET /api/test - Test connection
- GET /api/users - Get all users (59 users)
- POST /save-image - Save captured image

## App Configuration

**File:** `PhotoLeloApp/config.js`
```javascript
export const API_BASE_URL = 'http://192.168.1.2:3000';
```

**Login Screen:** Calls `GET /api/users` to validate credentials

## Next Steps

1. **Test in phone browser first** - This confirms network connectivity
2. **If browser works, reinstall app** - This ensures app has latest config
3. **Check app logs** - Use `adb logcat` to see actual error
4. **Try different network** - Test on different WiFi to rule out router issues

## Contact Info

If still not working, provide:
1. Result of browser test (http://192.168.1.2:3000/api/test)
2. Phone's IP address (from WiFi settings)
3. Computer's IP address (from ipconfig)
4. WiFi network name (both devices)
5. Any error messages from app

This will help diagnose the exact issue!
