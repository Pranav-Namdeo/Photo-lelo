# Face Capture System

A simple web application to capture face images with enrollment numbers using face detection.

## Setup

1. Install dependencies:
```
npm install
```

2. Start the server:
```
npm start
```

3. Open your browser and go to:
```
http://localhost:3000/imagecapture.html
```

## Usage

### Face Capture System
1. Open `http://localhost:3000/imagecapture.html`
2. Enter an enrollment number
3. Position your face in front of the camera
4. Wait for liveness detection (green box will appear)
5. Click "Save Image" button
6. Image will be saved as `enrollmentnumber.png` in the "Image save" folder

### Photo Manager
1. Open `http://localhost:3000/photomanager.html`
2. Login with password: `pranav`
3. View all captured photos with their enrollment numbers
4. Each user has:
   - Username: Enrollment number
   - Password: `pranav` (default for all users)
   - Profile image: Their captured photo

## Features

- Real-time face detection using face-api.js
- Face landmark detection (68 points)
- Texture-based liveness detection (anti-spoofing)
- Automatic face validation before saving
- Images saved with enrollment number as filename
- Photo manager panel to view all captured users
- Secure login for photo manager
- Mobile app for Android/iOS

## Mobile App

A React Native mobile application is available in the `mobile-app` folder.

### Quick Start

1. Navigate to mobile-app:
   ```bash
   cd mobile-app
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Update `config.js` with your server IP address

4. Start the app:
   ```bash
   npm start
   ```

See `mobile-app/README.md` for detailed instructions.

## Tech Stack

### Web Application
- HTML5, CSS3, JavaScript
- Face-api.js for face detection
- Node.js + Express for backend
- Multer for file uploads

### Mobile Application
- React Native
- Expo
- React Navigation
- Axios
