# Firebase Storage CORS Configuration

## Problem
When uploading images from Flutter Web, you may encounter CORS (Cross-Origin Resource Sharing) errors like:
```
Access to XMLHttpRequest at 'https://firebasestorage.googleapis.com/...' from origin 'http://localhost:55180' has been blocked by CORS policy
```

## Solution: Configure CORS in Firebase Storage

You need to configure CORS for your Firebase Storage bucket to allow uploads from your web app.

### Step 1: Create a CORS Configuration File

Create a file named `cors.json` with the following content:

```json
[
  {
    "origin": ["*"],
    "method": ["GET", "HEAD", "PUT", "POST", "DELETE"],
    "maxAgeSeconds": 3600,
    "responseHeader": ["Content-Type", "Authorization", "Content-Length", "User-Agent", "x-goog-resumable"]
  }
]
```

**For production, replace `"*"` with your specific domain:**
```json
[
  {
    "origin": ["https://yourdomain.com", "https://www.yourdomain.com"],
    "method": ["GET", "HEAD", "PUT", "POST", "DELETE"],
    "maxAgeSeconds": 3600,
    "responseHeader": ["Content-Type", "Authorization", "Content-Length", "User-Agent", "x-goog-resumable"]
  }
]
```

### Step 2: Install Google Cloud SDK (if not already installed)

1. Download and install from: https://cloud.google.com/sdk/docs/install
2. Or use the installer for your operating system

### Step 3: Authenticate with Google Cloud

Open terminal/command prompt and run:
```bash
gcloud auth login
```

### Step 4: Set Your Firebase Project

```bash
gcloud config set project dishesondemandv2
```

(Replace `dishesondemandv2` with your actual Firebase project ID)

### Step 5: Apply CORS Configuration

Run this command (replace `dishesondemandv2` with your project ID):
```bash
gsutil cors set cors.json gs://dishesondemandv2.firebasestorage.app
```

### Step 6: Verify CORS Configuration

To verify the CORS configuration was applied:
```bash
gsutil cors get gs://dishesondemandv2.firebasestorage.app
```

### Alternative: Using Firebase Console (Limited)

Unfortunately, Firebase Console doesn't provide a direct UI for CORS configuration. You must use the `gsutil` command-line tool as described above.

## Quick Setup Script

Save this as `setup-cors.sh` (Linux/Mac) or `setup-cors.bat` (Windows):

**Linux/Mac:**
```bash
#!/bin/bash
echo '[{"origin":["*"],"method":["GET","HEAD","PUT","POST","DELETE"],"maxAgeSeconds":3600,"responseHeader":["Content-Type","Authorization","Content-Length","User-Agent","x-goog-resumable"]}]' > cors.json
gcloud config set project dishesondemandv2
gsutil cors set cors.json gs://dishesondemandv2.firebasestorage.app
echo "CORS configuration applied!"
```

**Windows (setup-cors.bat):**
```batch
@echo off
echo [{"origin":["*"],"method":["GET","HEAD","PUT","POST","DELETE"],"maxAgeSeconds":3600,"responseHeader":["Content-Type","Authorization","Content-Length","User-Agent","x-goog-resumable"]}] > cors.json
gcloud config set project dishesondemandv2
gsutil cors set cors.json gs://dishesondemandv2.firebasestorage.app
echo CORS configuration applied!
```

## Important Notes

1. **For Development**: Using `"origin": ["*"]` allows all origins (localhost, etc.)
2. **For Production**: Replace `"*"` with your specific domain for security
3. **Firebase Storage Rules**: Make sure your Storage Security Rules allow uploads:
   ```javascript
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /{allPaths=**} {
         allow read: if true;
         allow write: if request.auth != null;
       }
     }
   }
   ```

## Troubleshooting

- **"Command not found: gsutil"**: Install Google Cloud SDK
- **"Permission denied"**: Make sure you're authenticated with `gcloud auth login`
- **"Project not found"**: Verify your Firebase project ID in Firebase Console

## After Configuration

Once CORS is configured, restart your Flutter web app and try uploading images again. The CORS error should be resolved.


