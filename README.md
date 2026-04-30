DarzeeBook
A professional Flutter application for tailor and garment business management. Manage customers, take orders, track measurements, and organize your tailoring business all in one place.

Features
Customer Management - Add, view, and manage customer profiles with contact information
Order Tracking - Create and track orders with detailed status management
Measurement System - Dynamic custom measurements for each customer with unlimited fields
Bilingual Support - Full support for English and Urdu languages
Material Design 3 - Modern, professional UI with Material You design system
Offline First - All data stored locally using SharedPreferences (web-compatible)
Search Functionality - Quickly find customers and orders by name
Getting Started
Prerequisites
Flutter 3.41.8 or higher
Dart 3.11.5 or higher
Android SDK (for Android builds)
Xcode (for iOS builds on macOS)
Installation
Clone the repository:

git clone https://github.com/yourusername/darzee_book.gitcd darzee_book
Get dependencies:

flutter pub get
Run the app:

flutter run
Project Structure

lib/├── main.dart                 # App entry point with localization setup├── screens/                  # UI screens (customers, orders, measurements)├── services/│   └── db_service.dart      # Local data storage with SharedPreferences├── utils/│   ├── app_strings.dart     # Bilingual strings (English/Urdu)│   └── theme.dart           # Material 3 theme configuration└── models/                  # Data models (Customer, Order, Measurement)
Building for Production
Android Release Build

flutter build appbundle --release
Output: app-release.aab

iOS Release Build

flutter build ios --release
Key Technologies
Flutter - UI Framework
Material 3 - Design System
SharedPreferences - Local Data Storage
Intl - Internationalization (i18n)
Languages Supported
English (en)
Urdu (ur)
License
This project is licensed under the MIT License.

Support
For issues, questions, or feature requests, please open an issue on GitHub or contact the development team.

Version: 1.0.0
Status: Ready for Production