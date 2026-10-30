# CampusPulse - Flutter Frontend

Responsive College Management Web & Mobile Application built with Flutter & Dart, powered by Provider state management.

## Features
- **3 Role-Specific Workspaces**:
  - **Admin**: Dashboard metrics, Student Directory with CRUD, Faculty Roster, Attendance Shortage alerts (<75%), Department & Course Management, Fees Collection, Examinations & Report Card generation.
  - **Faculty**: Daily attendance marking sheet, student marks entry, coursework & assignment publishing, weekly lecture timetable.
  - **Student**: Grade sheet, attendance meter with shortage alerts, assignment submissions, class timetable, fee invoices with online payment simulation and downloadable receipts.
- **Responsive Layout**: Desktop sidebar navigation, collapsible tablet rail, mobile drawer.
- **Smart Fallback**: Includes instant demo login buttons (Admin, Faculty, Student) and offline mock data so the app runs smoothly with 100% of features even before configuring MongoDB Atlas.

## Getting Started

### 1. Install Flutter Dependencies
```bash
flutter pub get
```

### 2. Run Locally in Chrome
```bash
flutter run -d chrome
```

### 3. Build for Production Web (Render Deployment)
```bash
flutter build web --release
```
The production bundle will be generated in `build/web/`.
