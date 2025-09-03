# QwikTest Mobile

A simplified Flutter mobile application for online exam management and testing.

## Features

- **Authentication**: User login, registration, and password reset
- **Dashboard**: Overview of user stats and recent activities
- **Exam Management**: Take exams with multiple choice questions
- **Profile Management**: View and edit user profile information
- **Settings**: Basic app settings including theme and language preferences
- **Analytics & Monitoring**: Firebase integration for crash reporting, performance monitoring, and user analytics

## Architecture

This app follows Clean Architecture principles with:
- **BLoC Pattern** for state management
- **Feature-based** folder structure
- **Dependency Injection** using GetIt
- **Go Router** for navigation

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure Firebase (optional for development):
   - For production builds, ensure Firebase project is properly configured
   - Development builds can run without Firebase configuration (services are conditionally initialized)
4. Run the app:
   ```bash
   flutter run
   ```

### Firebase Configuration

The app includes Firebase services for analytics, crash reporting, and performance monitoring:

- **Firebase Analytics**: Enabled in production and staging environments
- **Firebase Crashlytics**: Enabled only in production builds
- **Firebase Performance**: Enabled in production and staging environments

Firebase initialization is controlled by `EnvironmentConfig` flags:
- Services are only initialized when `EnvironmentConfig.isProduction` or staging conditions are met
- Development builds can run without Firebase configuration
- Debug logging shows Firebase initialization status when `EnvironmentConfig.enableDebugLogging` is true

To disable Firebase services entirely, remove the packages from `pubspec.yaml` and update `main.dart` initialization.

## Project Structure

```
lib/
├── core/                 # Core functionality
│   ├── constants/        # App constants
│   ├── di/              # Dependency injection
│   └── router/          # App routing
├── features/            # Feature modules
│   ├── authentication/ # Login, register, forgot password
│   ├── dashboard/       # Main dashboard
│   ├── exam_session/    # Exam taking functionality
│   ├── profile/         # User profile management
│   └── settings/        # App settings
└── shared/              # Shared components
    └── navigation/      # Navigation destinations
```
