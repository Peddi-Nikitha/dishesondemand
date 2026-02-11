# Firebase Storage Security Rules Setup

## Problem: 403 Forbidden Error

When uploading images, you may encounter:
```
POST https://firebasestorage.googleapis.com/... 403 (Forbidden)
```

This means your Firebase Storage Security Rules are blocking the upload.

## Solution: Update Storage Rules in Firebase Console

### Step 1: Open Firebase Console

1. Go to https://console.firebase.google.com/
2. Select your project: `dishesondemandv2`
3. Click on **Storage** in the left sidebar
4. Click on the **Rules** tab

### Step 2: Update the Rules

Copy and paste the following rules:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Allow read access to all files
    match /{allPaths=**} {
      allow read: if true;
    }
    
    // Products - allow authenticated users to upload
    match /products/{productId}/{fileName} {
      allow write: if request.auth != null;
      allow read: if true;
    }
    
    // Restaurant logo - allow authenticated users to upload
    match /restaurant/logo/{fileName} {
      allow write: if request.auth != null;
      allow read: if true;
    }
    
    // User profile images - allow authenticated users to upload their own
    match /users/{userId}/profile/{fileName} {
      allow write: if request.auth != null && request.auth.uid == userId;
      allow read: if true;
    }
    
    // Delivery boy documents - allow authenticated users to upload
    match /deliveryBoys/{deliveryBoyId}/documents/{fileName} {
      allow write: if request.auth != null;
      allow read: if request.auth != null;
    }
    
    // Default: deny all other writes
    match /{allPaths=**} {
      allow write: if false;
    }
  }
}
```

### Step 3: Publish the Rules

1. Click the **Publish** button
2. Wait for confirmation that rules are published

### Step 4: Verify Authentication

Make sure you're logged in as an admin user:
- Email: `admin@restaurant.com`
- Password: `password123`

## Important Notes

1. **Authentication Required**: The rules require `request.auth != null`, meaning users must be logged in to upload
2. **Read Access**: All files can be read by anyone (public read access)
3. **Write Access**: Only authenticated users can upload files
4. **User Profiles**: Users can only upload to their own profile folder

## Alternative: Temporary Development Rules (Less Secure)

If you need to test without authentication, you can temporarily use:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if true;
    }
  }
}
```

**⚠️ WARNING**: This allows anyone to upload/delete files. Only use for development and change back before production!

## Troubleshooting

- **Still getting 403**: Make sure you're logged in and the rules are published
- **Rules not saving**: Check that you have proper permissions in Firebase Console
- **Upload works but can't read**: Check the read rules match your file paths

## After Configuration

Once rules are updated:
1. Refresh your Flutter web app
2. Make sure you're logged in as admin
3. Try uploading an image again

The 403 error should be resolved!
























