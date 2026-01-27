#!/bin/bash

echo "========================================"
echo "Firebase Storage CORS Setup Script"
echo "========================================"
echo ""

# Check if gsutil is installed
if ! command -v gsutil &> /dev/null; then
    echo "ERROR: gsutil command not found!"
    echo ""
    echo "Please install Google Cloud SDK first:"
    echo "https://cloud.google.com/sdk/docs/install"
    echo ""
    exit 1
fi

echo "Step 1: Creating CORS configuration file..."
echo '[{"origin":["*"],"method":["GET","HEAD","PUT","POST","DELETE"],"maxAgeSeconds":3600,"responseHeader":["Content-Type","Authorization","Content-Length","User-Agent","x-goog-resumable"]}]' > cors.json
echo "CORS configuration file created: cors.json"
echo ""

echo "Step 2: Setting Firebase project..."
gcloud config set project dishesondemandv2
if [ $? -ne 0 ]; then
    echo ""
    echo "ERROR: Failed to set project. Make sure you're logged in:"
    echo "Run: gcloud auth login"
    echo ""
    exit 1
fi
echo "Project set successfully!"
echo ""

echo "Step 3: Applying CORS configuration to Firebase Storage..."
gsutil cors set cors.json gs://dishesondemandv2.firebasestorage.app
if [ $? -ne 0 ]; then
    echo ""
    echo "ERROR: Failed to apply CORS configuration."
    echo "Make sure you have proper permissions and are authenticated."
    echo ""
    exit 1
fi
echo "CORS configuration applied successfully!"
echo ""

echo "Step 4: Verifying CORS configuration..."
gsutil cors get gs://dishesondemandv2.firebasestorage.app
echo ""

echo "========================================"
echo "CORS Setup Complete!"
echo "========================================"
echo ""
echo "Please restart your Flutter web app and try uploading images again."
echo ""


