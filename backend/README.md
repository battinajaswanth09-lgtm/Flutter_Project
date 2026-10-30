# College Management System - Backend API

Production-ready REST API built with Node.js, Express.js, and MongoDB Atlas.

## Tech Stack
- **Runtime**: Node.js (v18+)
- **Framework**: Express.js
- **Database**: MongoDB Atlas / Mongoose
- **Security**: JWT, bcryptjs, Helmet, Express-Rate-Limit, CORS
- **Logging**: Morgan

## Getting Started

### 1. Install Dependencies
```bash
npm install
```

### 2. Configure Environment Variables
Copy `.env.example` to `.env` and fill in your MongoDB Atlas connection string:
```bash
MONGODB_URI=mongodb+srv://<username>:<password>@cluster0.mongodb.net/college_db?retryWrites=true&w=majority
JWT_SECRET=your_secure_jwt_secret_key
PORT=5000
```

### 3. Seed Initial Demo Data
Populate the database with realistic departments, courses, faculty, students, announcements, timetables, and sample credentials:
```bash
npm run seed
```

### 4. Start Server
```bash
# Development mode
npm run dev

# Production mode
npm start
```

## Sample Demo Accounts
| Role | Email | Password |
|---|---|---|
| **Admin** | `admin@college.edu` | `AdminPassword123!` |
| **Faculty** | `faculty@college.edu` | `FacultyPassword123!` |
| **Student** | `student@college.edu` | `StudentPassword123!` |

## Key API Endpoints
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `GET /api/auth/me` - Authenticated user info
- `GET /api/admin/dashboard-stats` - Admin metrics & analytics
- `GET /api/students` - Paginated & searchable student list
- `GET /api/faculty` - Faculty list & assigned courses
- `GET /api/departments` - Department listings
- `GET /api/courses` - Courses & subjects
- `POST /api/attendance` - Mark daily attendance
- `GET /api/attendance/student/:id` - Attendance percentages & shortage alerts
- `GET /api/exams` & `POST /api/exams/results` - Examination records
- `GET /api/timetables` - Class schedules
- `GET /api/fees` & `POST /api/fees/:id/pay` - Fees management
- `GET /api/announcements` - College announcements
