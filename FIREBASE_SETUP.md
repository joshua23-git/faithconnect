# Firebase Configuration Setup

This document explains where to add Firebase configuration files for the FaithConnect app.

## Required Firebase Services

1. **Firebase Authentication** (Email/Password enabled)
2. **Cloud Firestore** (Database)
3. **Firebase Storage** (File storage)

## Configuration Files Needed

### Android
- **File**: `android/app/google-services.json`
- **Location**: Download from Firebase Console > Project Settings > Your apps > Android app
- **Steps**:
  1. Go to Firebase Console (https://console.firebase.google.com)
  2. Select your project (or create a new one)
  3. Add an Android app to your project
  4. Download `google-services.json`
  5. Place it in `android/app/` directory

### iOS
- **File**: `ios/Runner/GoogleService-Info.plist`
- **Location**: Download from Firebase Console > Project Settings > Your apps > iOS app
- **Steps**:
  1. Go to Firebase Console
  2. Add an iOS app to your project
  3. Download `GoogleService-Info.plist`
  4. Place it in `ios/Runner/` directory

### Web
- **File**: `web/index.html`
- **Location**: Update the existing `web/index.html` file with Firebase config
- **Steps**:
  1. Go to Firebase Console
  2. Add a Web app to your project
  3. Copy the Firebase configuration object
  4. Add it to `web/index.html` in the script tags

## Firebase Console Setup

### 1. Enable Authentication
- Go to Authentication > Sign-in method
- Enable "Email/Password" provider

### 2. Create Firestore Database
- Go to Firestore Database
- Create database (start in test mode for development)
- Set security rules (adjust as needed for production)

### 3. Enable Storage
- Go to Storage
- Get started (start in test mode for development)
- Set security rules (adjust as needed for production)

## Using Firebase CLI (Recommended)

If you have Firebase CLI installed:
```bash
flutterfire configure
```

This command will:
- Detect your Flutter platforms
- Guide you through Firebase project setup
- Automatically add configuration files

## Security Rules (Development)

### Firestore Rules
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Storage Rules
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**Note**: These are development rules. Update for production with proper security.

## Testing

After adding configuration files:
1. Run `flutter pub get`
2. Run `flutter run`
3. The app should connect to Firebase

## Troubleshooting

- Make sure `google-services.json` is in the correct location
- Verify package names match in Firebase Console and `pubspec.yaml`
- Check that Firebase services are enabled in the console
- Ensure internet permission is added (AndroidManifest.xml for Android)
