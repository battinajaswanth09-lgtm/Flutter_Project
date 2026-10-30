# CampusPulse — Complete College Management System

An enterprise-grade, responsive **College Management System** developed with **Flutter** for the frontend, **Node.js & Express.js** for the backend REST API, and **MongoDB Atlas** for database management. Ready for one-click production deployment on **Render**.

---

## 🌟 System Overview & Architecture

CampusPulse delivers an end-to-end institutional workflow connecting **Admins**, **Faculty**, and **Students** with role-based access control, real-time analytics, responsive layouts, and academic management tools.

```
                              ┌────────────────────────────────────────┐
                              │  Flutter Web / Mobile App Client       │
                              │  (Provider State Management)           │
                              └──────────────────┬─────────────────────┘
                                                 │ HTTPS / JSON (JWT)
                                                 ▼
                              ┌────────────────────────────────────────┐
                              │  Node.js + Express.js REST API Server  │
                              │  (Auth, Rate Limit, Helmet, Mongoose)  │
                              └──────────────────┬─────────────────────┘
                                                 │ Mongoose Connection
                                                 ▼
                              ┌────────────────────────────────────────┐
                              │  MongoDB Atlas Cloud Database          │
                              │  (12 Normalized & Indexed Collections) │
                              └────────────────────────────────────────┘
```

---

## 🚀 Key Feature Matrix by User Role

### 1. 🛡️ Admin Dashboard & Controls
- **Executive Metric Cards**: Total students, active faculty, departments, courses, tuition fees collected vs outstanding dues.
- **Student Directory**: Full CRUD with instant search, department/semester filters, and confirmation dialogs.
- **Faculty Directory**: Academic staff roster with employee IDs, designations, experience, and assigned courses.
- **Department & Course Management**: Department cards, course specifications, credit requirements.
- **Campus Attendance Oversight**: Live monitoring with automated **Attendance Shortage Alerts (< 75%)**.
- **Fee Management**: Invoice generation, filter by Paid/Pending/Partial/Overdue status, payment audit trail.
- **Examinations & Results**: Examination scheduling and publishing.
- **Campus Timetables**: Master lecture schedules and classroom allotments.
- **Public Announcements**: Broadcast announcements tailored to students, faculty, or all campus.
- **Institutional Reports**: Exportable academic summaries and student performance metrics.

### 2. 👨‍🏫 Faculty Dashboard & Instructional Tools
- **Instruction Portal**: Daily schedule, assigned subjects, and enrolled class rosters.
- **Interactive Daily Attendance**: Mark **Present**, **Absent**, or **Late** per student with one-tap status toggling.
- **Marks & Grading Entry**: Upload mid-term and final examination scores with auto letter grade calculation (`A+`, `A`, `B`, `C`, `F`).
- **Coursework & Assignment Manager**: Publish assignments, set deadlines, and inspect student submissions.
- **Weekly Schedule**: Personalized lecture room timetable.

### 3. 🎓 Student Dashboard & Academic Portal
- **Academic Dashboard**: Current semester status, enrolled courses, attendance progress bar, CGPA tracker.
- **Attendance Monitor**: Overall percentage meter, subject-wise attendance breakdown, and shortage warnings.
- **Grade Cards & Transcripts**: Examination results, marks breakdown, letter grades, and official grade card download.
- **Daily Class Timetable**: Lecture periods, timings, professors, and classroom room numbers.
- **Fee Invoices & Online Payment**: View pending dues, pay online via simulated secure payment gateway, and download official receipts.
- **Assignments & Coursework**: View active homework, submit GitHub/drive links and notes.

---

## 🛠️ Technology Stack

| Layer | Technologies |
|---|---|
| **Frontend** | Flutter 3.x, Dart, Provider State Management, Google Fonts, Material 3 Design |
| **Backend** | Node.js (v18+), Express.js, Helmet, CORS, Morgan, Express-Rate-Limit |
| **Database** | MongoDB Atlas / Mongoose ODM |
| **Authentication** | JSON Web Tokens (JWT) + Bcrypt Password Hashing |
| **Hosting & CI/CD** | Render (Static Site for Flutter Web, Web Service for Node.js API) |

---

## 🔐 Default Demo Credentials

CampusPulse includes instant one-click login buttons on the login screen for testing, as well as the following seed credentials:

| Role | Email Address | Password | Permissions |
|---|---|---|---|
| **Admin** | `admin@college.edu` | `AdminPassword123!` | Full System Administration |
| **Faculty** | `faculty@college.edu` | `FacultyPassword123!` | Attendance, Marks, Assignments |
| **Student** | `student@college.edu` | `StudentPassword123!` | Attendance, Results, Fees, Timetable |

---

## 💻 Local Development Setup

### 1. Backend Setup
```bash
cd backend
npm install

# Copy environment variables and adjust your MongoDB URI
cp .env.example .env

# Populate initial seed data (departments, courses, faculty, students, exams)
npm run seed

# Start API server (runs on http://localhost:5000)
npm run dev
```

### 2. Frontend Setup
```bash
cd frontend
flutter pub get

# Run on Chrome
flutter run -d chrome
```

---

## 🌐 Render Deployment Walkthrough

CampusPulse includes pre-configured deployment blueprints: `render.yaml`, `Dockerfile`, and `nginx.conf`.

### Option A: Automatic Blueprint Deployment (`render.yaml`)
1. Push this repository to **GitHub**.
2. Log in to [Render](https://render.com) and go to **Blueprints**.
3. Connect your repository. Render automatically reads `render.yaml` and deploys:
   - **`college-api`** (Node.js Web Service)
   - **`college-web`** (Flutter Web Static Site)
4. Add your **`MONGODB_URI`** connection string in the Render Dashboard under `college-api` environment variables.

### Option B: Manual Service Deployment

#### 1. Deploy the Backend (Render Web Service)
- **Environment**: Node
- **Root Directory**: `backend`
- **Build Command**: `npm install`
- **Start Command**: `npm start`
- **Environment Variables**:
  - `NODE_ENV`: `production`
  - `PORT`: `5000`
  - `MONGODB_URI`: `mongodb+srv://<user>:<pwd>@cluster0.mongodb.net/college_db?retryWrites=true&w=majority`
  - `JWT_SECRET`: `<any_secure_random_key>`
  - `CLIENT_URL`: `*`

#### 2. Deploy Flutter Web (Render Static Site)
- **Root Directory**: `frontend`
- **Build Command**:
  ```bash
  if [ ! -d "$HOME/flutter" ]; then git clone https://github.com/flutter/flutter.git -b stable $HOME/flutter; fi; export PATH="$PATH:$HOME/flutter/bin"; flutter config --enable-web; flutter pub get; flutter build web --release
  ```
- **Publish Directory**: `frontend/build/web`
- **Rewrite Rule**:
  - Source: `/*`
  - Destination: `/index.html`

---

## 📁 Repository Directory Structure

```
Flutter_Project/
├── backend/
│   ├── src/
│   │   ├── config/db.js               # MongoDB connection handler
│   │   ├── models/                    # 12 Mongoose data models
│   │   ├── controllers/               # Express route business logic
│   │   ├── routes/                    # API route definitions
│   │   ├── middleware/                # JWT verification & role protection
│   │   ├── seed/seeder.js             # Realistic test database populator
│   │   └── server.js                  # Express application entry point
│   ├── package.json
│   ├── .env.example
│   └── README.md
│
├── frontend/
│   ├── pubspec.yaml
│   ├── web/
│   │   ├── index.html                 # Web entry with custom spinner
│   │   └── manifest.json
│   ├── lib/
│   │   ├── constants/                 # Colors, typography, themes
│   │   ├── models/                    # Dart data models
│   │   ├── services/                  # HTTP client, token storage & mock fallback
│   │   ├── providers/                 # State management (Provider)
│   │   ├── widgets/                   # Responsive scaffold, stat cards, badges
│   │   ├── screens/                   # Admin, Faculty, Student, and Auth screens
│   │   └── main.dart                  # Flutter application root
│   └── README.md
│
├── render.yaml                        # Render deployment specification
├── Dockerfile                         # Production multi-stage Docker build
├── nginx.conf                         # High-performance web server config
├── .gitignore
└── README.md
```

---

## 📄 License
This project is licensed under the MIT License.
