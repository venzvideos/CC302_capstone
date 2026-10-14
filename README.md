# MedReminder — Medication Schedule and Dose Tracking Application

MedReminder is a student-level, offline-first Flutter app for Android and Windows. It provides local demo accounts, medication CRUD, in-app dose schedules, dose status tracking, medication history, dashboard statistics, and light/dark themes.

## Features
- Local registration, login, logout, and demo account separation
- Medication create, read, update, archive/reactivate, and delete
- Validation for names, dosage, times, and date ranges
- Once daily, twice daily, three times daily, and custom schedules
- Today schedule with Pending, Taken, Skipped, and Missed states
- Duplicate dose-log prevention using a stable dose ID
- Dose action timestamps and historical records
- Search, active/archived filters, date/status history filters
- Dashboard counts and weekly summary
- Responsive navigation: bottom navigation on narrow screens, rail on wider screens
- Light/dark theme toggle
- Data persists after app restarts

## Technology
- Flutter + Dart
- Material 3 and Material Icons
- `shared_preferences` for small local JSON records
- No backend, no network API, and no image assets required

## Setup
1. Install Flutter and the required Android/Windows development tools.
   - Flutter SDK (version 3.47.7 or higher)
   - Dart SDK (version 3.13.5 or higher)
   - Android Studio with Android SDK and emulator setup (for Android)
   - Visual Studio with Desktop development with C++ workload (for Windows)
2. Extract this project.
3. Open a terminal in the `med_reminder` folder.
4. If the Android and Windows native folders are not present, generate them once:
   ```powershell
   flutter create --platforms=android,windows .
   ```
   This command creates the standard native runner files and preserves `lib/main.dart` and `pubspec.yaml`.
5. Install dependencies:
   ```powershell
   flutter pub get
   ```
6. Check available devices:
   ```powershell
   flutter devices
   ```
7. Run on Android (replace the ID with one shown by `flutter devices`):
   ```powershell
   flutter run -d <device-id>
   ```
8. Run on Windows:
   ```powershell
   flutter config --enable-windows-desktop
   flutter run -d windows
   ```
   Windows desktop requires Developer Mode to be enabled for symlink support. Enable Developer Mode in Windows Settings > Privacy & Security > For developers.

## Demo account
You can register your own local demo account from the Register screen. The app starts with no pre-created user account. For a quick demonstration, register using a name, email, and password, then log in.

## Project structure
```text
lib/
  main.dart          Main application, models, local repository, screens and widgets
test/
  widget_test.dart   Basic app startup test
android/
  Android project files
windows/
  Windows project files
```

The source is kept compact and student-presentable. If your instructor requires a multi-file architecture, the model and repository classes can be separated later without changing the app's behavior.

## Local data
All records are stored on the current device using SharedPreferences. Uninstalling the app or clearing app data may erase records. The local demo authentication is not production security; do not use real sensitive medical information.

## Limitations
- This is a medication organization and logging tool, **not** a medical device, prescribing system, or source of medical advice. It does not recommend medication or dosages.
- All sample medication records are illustrative.
- The app has in-app schedules only and does not send notifications while closed.
- Missed-dose status is refreshed when the app opens or the schedule is refreshed.
- SharedPreferences and the local demo login are for classroom demonstration, not secure storage for real medical records.
- Windows build requires Developer Mode to be enabled for symlink support.
- Android emulator requires a system image to be installed; see [Android emulator setup](https://developer.android.com/studio/run/emulator-manager) for details.

## Testing
Run unit and widget tests:
```powershell
flutter test
```
Run static analysis:
```powershell
flutter analyze
```

## Build
Build Android APK:
```powershell
flutter build apk --debug
```
Build Windows app:
```powershell
flutter build windows
```
Note: Windows build requires Developer Mode enabled.

## Known Issues
- Windows build and run require Developer Mode to be enabled for symlink support.
- Android emulator requires a system image installation; if not available, the app cannot be run on an emulator without setup.