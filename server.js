const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = 3000;

// Enable CORS for mobile app
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
    next();
});

// Parse JSON bodies
app.use(express.json());

// Ensure Image save folder exists
const imageSaveDir = path.join(__dirname, 'Image save');
if (!fs.existsSync(imageSaveDir)) {
    fs.mkdirSync(imageSaveDir, { recursive: true });
}

// Configure multer to store file temporarily
const upload = multer({ 
    storage: multer.memoryStorage()
});

// Serve static files
app.use(express.static(__dirname));

// Handle image upload
app.post('/save-image', upload.single('image'), (req, res) => {
    if (!req.file) {
        return res.status(400).json({ error: 'No image uploaded' });
    }
    
    const enrollmentNumber = req.body.enrollmentNumber;
    
    if (!enrollmentNumber) {
        return res.status(400).json({ error: 'Enrollment number is required' });
    }
    
    const filename = `${enrollmentNumber}.png`;
    const filepath = path.join(imageSaveDir, filename);
    
    // Write the file from memory to disk
    fs.writeFileSync(filepath, req.file.buffer);
    
    console.log(`Image saved: ${filename}`);
    res.json({ 
        success: true, 
        message: 'Image saved successfully',
        filename: filename 
    });
});

// Test endpoint
app.get('/api/test', (req, res) => {
    console.log('Test endpoint hit from:', req.ip);
    res.json({ 
        status: 'ok', 
        message: 'Server is running!',
        timestamp: new Date().toISOString()
    });
});

// API endpoint to get all users
app.get('/api/users', (req, res) => {
    console.log('Users endpoint hit from:', req.ip);
    try {
        // Read all files from Image save directory
        const files = fs.readdirSync(imageSaveDir);
        
        // Filter PNG and JPG files and create user objects
        const users = files
            .filter(file => file.endsWith('.png') || file.endsWith('.jpg') || file.endsWith('.jpeg'))
            .map(file => {
                // Remove file extension to get username
                const username = file.replace(/\.(png|jpg|jpeg)$/i, '');
                return {
                    username: username,
                    filename: file,
                    password: 'pranav' // Default password for all users
                };
            });
        
        console.log(`Returning ${users.length} users`);
        res.json(users);
    } catch (error) {
        console.error('Error reading users:', error);
        res.status(500).json({ error: 'Failed to load users' });
    }
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running at http://localhost:${PORT}`);
    console.log(`Also accessible at http://192.168.1.2:${PORT}`);
    console.log(`Open http://localhost:${PORT}/imagecapture.html in your browser`);
});
