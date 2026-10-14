# PROJECT_PRESENTATION.md

## MedReminder — Presentation Notes

### 1. Short project introduction
MedReminder is a Flutter-based mobile and desktop application designed to help users manage their medication schedules and track doses. It allows users to register, log in, add medications with schedules, record doses as taken or skipped, and view historical data.

### 2. Problem and proposed solution
**Problem:** Patients often struggle to remember to take their medications on time, leading to missed doses and reduced treatment effectiveness. Existing solutions may be complex, require internet connectivity, or lack simplicity for everyday use.

**Solution:** MedReminder provides an offline-first, easy-to-use interface for managing medication schedules. It focuses on core functionality: scheduling doses, tracking adherence, and reviewing history—all without requiring an internet connection.

### 3. Main features
- **User Management:** Local registration, login, logout, and session persistence.
- **Medication CRUD:** Create, read, update, archive/reactivate, and delete medications with validation.
- **Dose Scheduling:** Support for once, twice, three times daily, and custom schedules. Stable dose IDs prevent duplicate logs.
- **Dose Tracking:** Mark doses as taken, skipped, or missed. Missed doses are automatically detected on schedule refresh.
- **History and Reports:** View past doses, filter by date and status, see dashboard statistics (active medications, today's doses, taken/pending/missed counts, weekly summary).
- **UI/UX:** Material 3 design, light/dark theme toggle, responsive layout (bottom navigation on phones, navigation rail on desktop), empty states, and feedback snackbars.
- **Data Persistence:** All data stored locally using SharedPreferences, surviving app restarts.

### 4. Technologies used
- **Framework:** Flutter 3.47.7
- **Language:** Dart 3.13.5
- **UI:** Material 3
- **State Management:** StatefulWidget and setState (appropriate for student project)
- **Local Storage:** shared_preferences plugin (version 2.5.6)
- **Validation:** Custom form validation
- **Date/Time Handling:** DateTime utilities
- **Icons:** Material Icons

### 5. Explanation of local storage
MedReminder uses the `shared_preferences` plugin to store data as JSON strings in the device's local storage. Each data type (users, medications, dose logs) is stored under a distinct key. The app employs a simple repository pattern within `main.dart` to handle reading, writing, and parsing. Data is not encrypted, as this is a demonstration app; however, the structure is clear and suitable for learning purposes.

### 6. Explanation of CRUD
- **Create:** User fills a form with medication details (name, dosage, frequency, times, start/end dates). Validation ensures required fields are present and values are valid (e.g., no blank names, at least one time, start date before end date). On submit, a new medication object is created with a unique ID and saved to SharedPreferences.
- **Read:** Medications are retrieved from SharedPreferences, parsed into a list, and displayed in a list view. Active and archived medications are separated based on the `active` flag.
- **Update:** User edits an existing medication via a pre-filled form. On save, the medication object is updated in SharedPreferences. The app ensures that schedule changes do not create duplicate dose logs for past dates.
- **Delete:** User confirms deletion via a dialog. The medication is removed from SharedPreferences. For safety, the app encourages archiving over deletion to preserve historical dose logs.
- **Archive/Reactivate:** Toggling the `active` flag of a medication moves it between active and archived lists. Archived medications do not generate new schedule entries.

### 7. Explanation of dose tracking
Each dose is uniquely identified by a combination of user ID, medication ID, and date/time (formatted as `YYYY-MM-DD HH:mm`). This ID is stable and generated consistently whenever the schedule is built. The app follows this process for each scheduled time:
1. Check if medication is active and if the date falls within its start/end range.
2. Generate the dose ID.
3. Look up any existing dose log with that ID in SharedPreferences.
4. If found, display the saved status (Taken, Skipped, Missed); otherwise, show Pending.
5. When the user taps Taken or Skipped, the app saves or updates the dose log with a timestamp.
6. Missed doses are detected automatically: any pending dose whose scheduled time has passed is updated to Missed when the schedule is refreshed (on app resume or manual refresh).
7. The app prevents changing a dose status without explicit user action (i.e., a Taken dose cannot become Missed without user intervention).

### 8. Explanation of the app's limitations
- **Offline-only:** No cloud sync or backup; data is device-local.
- **No medical advice:** The app does not recommend medications, dosages, or timing changes.
- **In-app schedules only:** No background notifications or alarms; users must open the app to see schedules and record doses.
- **Demo authentication:** Registration and login are local and not secure; passwords are stored in plain text (though this could be improved with hashing, it is kept simple for learning).
- **Windows symlink requirement:** Building and running the Windows app requires Developer Mode to be enabled for symlink support (a Flutter limitation with plugins).
- **Android emulator setup:** Requires a system image installation; without it, the app cannot be run on an emulator.
- **No image assets:** The app relies solely on icons and colors; no custom images are used.

### 9. A short demo sequence
1. **Launch:** App opens to login screen (no saved session).
2. **Register:** Tap "Create account", enter name, email, password, confirm, and submit. Navigates to login.
3. **Login:** Enter credentials, tap "Log in". Navigates to home dashboard.
4. **Add Medication:** Tap "+" button, fill in medication name (e.g., "Vitamin C"), dosage ("500mg"), frequency ("Twice daily"), times ("08:00", "20:00"), start date (today), and tap "Save".
5. **View Schedule:** Go to "Today's Schedule" tab. See two doses for today at 08:00 and 20:00, both marked Pending.
6. **Record Dose:** Tap the 08:00 dose, select "Taken". Dose status changes to Taken, timestamp shown.
7. **Skip Dose:** Tap the 20:00 dose, select "Skipped". Dose status changes to Skipped.
8. **History:** Go to "History" tab. See the two doses with their statuses and timestamps.
9. **Dashboard:** Return to home; see active medications: 1, today's doses: 2, taken: 1, pending: 0, skipped: 1, missed: 0.
10. **Theme:** Go to Profile, toggle dark mode; app switches to dark theme.
11. **Logout:** Go to Profile, tap "Log out", confirm. Returns to login screen.

### 10. Likely instructor questions with concise answers
- **Q: How is data stored locally?**  
  A: Using the `shared_preferences` plugin, which writes JSON strings to platform-specific storage locations. Each data type (user, insulin, dose logs) has its own key.

- **Q: How does the app prevent duplicate dose logs?**  
  A: Each dose has a unique ID based on user ID, medication ID, and date/time. Before saving a dose log, the app checks if a log with that ID already exists; if so, it updates it rather than creating a new one.

- **Q: How are missed doses detected?**  
  A: When the schedule is built or refreshed, any pending dose whose scheduled time is in the past is automatically updated to Missed, unless the user has already marked it as Taken or Skipped.

- **Q: Why archiving instead of deleting?**  
  A: Archiving preserves historical dose logs for reporting, while deletion would remove them. The app allows permanent deletion with confirmation, but archiving is the default for removing a medication from the active schedule.

- **Q: Is the authentication secure?**  
  A: No. This is a demo app for learning; passwords are stored in plain text. In a real app, you would use secure storage and hashing.

- **Q: Can the app send reminders when closed?**  
  A: No. MedReminder uses in-app schedules only and does not run background services or send notifications.

- **Q: How does the app handle time zones or daylight saving changes?**  
  A: All date/time comparisons are done using local date-only values (ignoring time zone shifts) for simplicity. For a production app, UTC storage and proper time zone handling would be needed.

- **Q: What happens if the device date is changed manually?**  
  A: The app uses the device's current date for schedule generation. Changing the device date may affect which doses are considered today or past; this is a limitation of relying on device time.

- **Q: How tested is the app?**  
  A: The app includes automated widget tests for startup and manual tests for core features. Static analysis passes with no errors. Builds succeed for Android and Windows (with Developer Mode enabled).

- **Q: Can I use this app for real medication management?**  
  A: No. This is a learning project. It lacks security, backup, and medical validation. Consult a healthcare provider for medical advice.