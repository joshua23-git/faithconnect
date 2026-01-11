# FaithConnect

A production-ready Flutter app where worshippers connect with religious leaders.

## Features

- **Authentication**: Email/password login and signup with role selection (Worshipper/Religious Leader)
- **Worshipper Flow**: 
  - Explore feed showing posts from followed leaders
  - Browse and follow religious leaders
  - 1-to-1 messaging with leaders
  - Profile management
- **Religious Leader Flow**:
  - Dashboard to view own posts
  - Create posts with text and images
  - Profile management
- **Messaging**: Simple 1-to-1 chat between users

## Tech Stack

- Flutter (latest stable)
- Firebase Authentication (email/password)
- Cloud Firestore (database)
- Firebase Storage (file storage)
- Provider (state management)
- Material 3 (UI design)
- Clean Architecture

## Setup

1. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

2. **Firebase Configuration**:
   - See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for detailed instructions
   - Add Firebase configuration files:
     - `android/app/google-services.json` (Android)
     - `ios/Runner/GoogleService-Info.plist` (iOS)
     - Update `web/index.html` (Web)

3. **Enable Firebase Services**:
   - Authentication: Enable Email/Password sign-in method
   - Firestore: Create database
   - Storage: Enable Firebase Storage

4. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/              # Constants, theme, utilities
├── data/              # Data layer (models, repositories, services)
├── domain/            # Domain layer (entities, repositories interfaces)
└── presentation/      # UI layer (screens, widgets, providers)
```

## Architecture

This app follows Clean Architecture principles:
- **Domain Layer**: Business entities and repository interfaces
- **Data Layer**: Firebase services, models, and repository implementations
- **Presentation Layer**: UI screens, widgets, and state management (Provider)

## Getting Started

1. Clone the repository
2. Run `flutter pub get`
3. Set up Firebase (see FIREBASE_SETUP.md)
4. Run the app on your preferred platform
