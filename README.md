# 🩸 Blood Management App

A comprehensive Flutter application for managing blood bank operations, inventory, and donor/recipient communications. The app provides seamless blood bank management with cross-platform support including mobile (Android/iOS) and desktop (Windows/Linux/macOS).

**Language:** Dart (Flutter)  
**Repository:** [AvaniPatel75/Blood_Management_App](https://github.com/AvaniPatel75/Blood_Management_App)  
**License:** MIT  
**Version:** 1.0.0

---

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Screenshots](#screenshots)
- [Installation & Setup](#installation--setup)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Usage](#usage)
- [Database & Backend](#database--backend)
- [Contributing](#contributing)
- [License](#license)

---

## ✨ Features

### Core Features
- **Blood Bank Management**
  - Manage multiple blood banks with location-based services
  - Track working hours and availability
  - Real-time blood stock inventory management

- **Blood Inventory System**
  - Monitor blood stock by type (A+, A-, B+, B-, O+, O-, AB+, AB-)
  - Real-time inventory updates
  - Low stock alerts and notifications

- **User Management**
  - Multi-role authentication (Admin, Staff, Donor, Recipient)
  - Secure Google Sign-In integration
  - Firebase Authentication
  - User profile management

- **Donor Management**
  - Donor registration and history tracking
  - Donation schedule management
  - Health questionnaire validation

- **Request Management**
  - Blood request creation and tracking
  - Real-time notification system
  - Request status monitoring
  - Nearby blood bank search

- **Location Services**
  - GPS-based location tracking
  - Google Maps integration
  - Find nearby blood banks
  - Geocoding support

- **Push Notifications**
  - Firebase Cloud Messaging (FCM)
  - Real-time alerts for blood requests
  - Donation reminders

- **Cross-Platform Support**
  - Android
  - iOS
  - Windows (Desktop)
  - Linux (Desktop)
  - macOS (Desktop)
  - Web

### Advanced Features
- SQLite local database with FFI support for desktop platforms
- Cloud Firestore synchronization
- Offline capability with automatic sync
- State management using GetX

---

## 🛠 Tech Stack

### Frontend
- **Framework:** Flutter 3.10.3+
- **Language:** Dart
- **State Management:** GetX 4.7.3
- **UI Components:** Material Design

### Backend & Database
- **Backend:** Firebase
  - Firebase Core 3.6.0
  - Cloud Firestore 5.4.4
  - Firebase Authentication 5.0.0
  - Firebase Messaging 15.2.10
- **Local Database:** SQLite 2.3.3
- **FFI Support:** sqflite_common_ffi 2.4.0+2

### Location & Maps
- **Google Maps Flutter:** 2.14.0
- **Geolocator:** 12.0.0
- **Geocoding:** 4.0.0

### Authentication
- **Google Sign-In:** 6.2.2

### Utilities
- **UUID:** 4.3.3 (for unique identifiers)
- **Path:** 1.9.0

---

## 📸 Screenshots

### Authentication & Onboarding
- Login/Sign-Up Screen
- Google Sign-In Integration
- User Role Selection

### Dashboard
- Home Dashboard with Stats
- Quick Action Buttons
- Recent Notifications

### Blood Bank Management
- Blood Banks List View
- Blood Bank Details
- Inventory Dashboard
- Stock Status Indicators

### Donation Management
- Donation History
- Schedule New Donation
- Donation Eligibility Check
- Health Questionnaire

### Blood Requests
- Create New Request
- View Available Blood Banks
- Request Status Tracking
- Nearby Blood Banks Map

### Maps & Location
- Google Maps Integration
- Blood Bank Locations
- Navigation to Blood Bank
- Search by Location

### User Profiles
- User Profile Page
- Edit Profile Information
- Donation History
- Request History

### Notifications
- Notification Center
- Real-time Updates
- Push Notifications
- Request Alerts

*Note: Add actual screenshots by uploading images to your repository's assets or screenshots folder and updating these references.*

---

## 💻 Installation & Setup

### Prerequisites
- Flutter SDK (3.10.3 or higher)
- Dart SDK
- Android SDK (for Android development)
- Xcode (for iOS development)
- Git

### Step 1: Clone Repository
```bash
git clone https://github.com/AvaniPatel75/Blood_Management_App.git
cd Blood_Management_App
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Firebase Configuration
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Add Android, iOS, and Web apps to your Firebase project
3. Download configuration files:
   - `google-services.json` (Android)
   - `GoogleService-Info.plist` (iOS)
4. Place them in the appropriate directories:
   - Android: `android/app/`
   - iOS: `ios/Runner/`

### Step 4: Configure Firebase Credentials
Update the `.firebaserc` file with your Firebase project configuration:
```json
{
  "projects": {
    "default": "your-firebase-project-id"
  }
}
```

### Step 5: Run the App

**Development (Android/iOS)**
```bash
flutter run
```

**Specific Platform**
```bash
# Android
flutter run -d android

# iOS
flutter run -d iphone

# Windows
flutter run -d windows

# Linux
flutter run -d linux

# macOS
flutter run -d macos

# Web
flutter run -d chrome
```

**Build Release**
```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Windows
flutter build windows --release

# Linux
flutter build linux --release

# macOS
flutter build macos --release

# Web
flutter build web --release
```

---

## 📁 Project Structure

```
Blood_Management_App/
├── android/                      # Android native configuration
├── ios/                          # iOS native configuration
├── linux/                        # Linux desktop configuration
├── macos/                        # macOS desktop configuration
├── windows/                      # Windows desktop configuration
├── web/                          # Web configuration
├── lib/                          # Main application code
│   ├── main.dart                # Application entry point
│   ├── models/                  # Data models
│   │   └── blood_bank_model.dart
│   ├── screens/                 # UI screens
│   ├── controllers/             # GetX controllers
│   ├── services/                # Business logic & services
│   ├── widgets/                 # Reusable widgets
│   ├── utils/                   # Utility functions
│   └── theme/                   # App theming
├── assets/                       # Images and static assets
├── functions/                    # Firebase Cloud Functions
├── pubspec.yaml                 # Project dependencies
├── pubspec.lock                 # Locked dependency versions
├── analysis_options.yaml        # Dart analysis rules
├── firebase.json                # Firebase configuration
├── .firebaserc                  # Firebase project reference
├── changes_log.txt              # Development change log
└── README.md                    # This file
```

---

## ⚙️ Configuration

### Firebase Configuration
The app uses Firebase for backend services. Configure the following:

1. **Firestore Database**
   - Collections: `blood_banks`, `donations`, `requests`, `users`
   - Enable Firestore in your Firebase project

2. **Authentication**
   - Enable Email/Password authentication
   - Enable Google Sign-In
   - Configure OAuth consent screen

3. **Cloud Messaging**
   - Enable Firebase Cloud Messaging (FCM)
   - Configure server key in Firebase Console

4. **Storage Rules**
   - Set appropriate Firestore security rules for your use case

### SQLite Configuration
The app automatically initializes SQLite for desktop platforms:
- Windows: Uses `sqflite_common_ffi`
- Linux: Uses `sqflite_common_ffi`
- macOS: Uses `sqflite_common_ffi`

### Google Maps API
1. Generate API key from [Google Cloud Console](https://console.cloud.google.com)
2. Enable Maps SDK and Geocoding API
3. Add API key to:
   - `android/app/AndroidManifest.xml`
   - `ios/Runner/Info.plist`

---

## 🚀 Usage

### User Roles & Workflows

**Blood Bank Staff**
- Log in with credentials
- Manage blood inventory
- Accept/reject donation requests
- View donation appointments

**Donor**
- Register and create profile
- Schedule donations
- Check eligibility
- View donation history

**Recipient/Emergency Contact**
- Search for nearby blood banks
- Create blood requests
- Track request status
- View available blood stock

---

## 🗄 Database & Backend

### Firestore Collections

**Users Collection**
```
{
  uid: string,
  name: string,
  email: string,
  role: string (admin/staff/donor/recipient),
  phone: string,
  bloodType: string,
  location: geopoint,
  createdAt: timestamp
}
```

**Blood Banks Collection**
```
{
  id: string,
  name: string,
  address: string,
  location: geopoint,
  phone: string,
  email: string,
  workingDays: array,
  workingHours: {start, end},
  bloodStock: {A+, A-, B+, B-, O+, O-, AB+, AB-},
  verified: boolean,
  createdAt: timestamp
}
```

**Donations Collection**
```
{
  id: string,
  donorId: string,
  bloodBankId: string,
  donatedBloodType: string,
  quantity: number,
  date: timestamp,
  status: string
}
```

### SQLite Tables
- `blood_banks`: Local cache of blood bank data
- `donations`: Local donation history
- `users`: Local user information

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style
- Follow Dart style guide: https://dart.dev/guides/language/effective-dart/style
- Use meaningful variable and function names
- Add comments for complex logic
- Run `flutter analyze` before committing

---

## 📝 Change Log

Latest changes include:
- SQLite & Desktop Support Integration
- FFI (Foreign Function Interface) database factory initialization
- Multi-platform desktop support (Windows, Linux, macOS)
- JSON serialization for complex data types in SQLite

See [changes_log.txt](changes_log.txt) for detailed version history.

---

## 📞 Support & Contact

For questions, issues, or suggestions:
- Open an [Issue](https://github.com/AvaniPatel75/Blood_Management_App/issues)
- Contact: [AvaniPatel75](https://github.com/AvaniPatel75)

---

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 🙏 Acknowledgments

- Flutter documentation and community
- Firebase for backend services
- Google Maps API
- Open-source contributors

---

**Made with ❤️ by Avani Patel**

Last Updated: May 2026
