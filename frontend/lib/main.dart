import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/student_provider.dart';
import 'providers/faculty_provider.dart';
import 'providers/academic_provider.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/profile/user_profile_screen.dart';

// Admin Screens
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_students_screen.dart';
import 'screens/admin/admin_faculty_screen.dart';
import 'screens/admin/admin_departments_screen.dart';
import 'screens/admin/admin_attendance_screen.dart';
import 'screens/admin/admin_exams_screen.dart';
import 'screens/admin/admin_fees_screen.dart';
import 'screens/admin/admin_timetables_screen.dart';
import 'screens/admin/admin_announcements_screen.dart';
import 'screens/admin/admin_reports_screen.dart';

// Faculty Screens
import 'screens/faculty/faculty_dashboard_screen.dart';
import 'screens/faculty/faculty_attendance_screen.dart';
import 'screens/faculty/faculty_marks_screen.dart';
import 'screens/faculty/faculty_assignments_screen.dart';
import 'screens/faculty/faculty_timetable_screen.dart';

// Student Screens
import 'screens/student/student_dashboard_screen.dart';
import 'screens/student/student_attendance_screen.dart';
import 'screens/student/student_results_screen.dart';
import 'screens/student/student_timetable_screen.dart';
import 'screens/student/student_fees_screen.dart';
import 'screens/student/student_assignments_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CollegeManagementApp());
}

class CollegeManagementApp extends StatelessWidget {
  const CollegeManagementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => FacultyProvider()),
        ChangeNotifierProvider(create: (_) => AcademicProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'CampusPulse | College Management System',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: _getInitialScreen(auth),
            routes: {
              '/login': (_) => const LoginScreen(),
              '/register': (_) => const RegisterScreen(),
              '/forgot-password': (_) => const ForgotPasswordScreen(),
              '/profile': (_) => const UserProfileScreen(),

              // Admin Routes
              '/admin/dashboard': (_) => const AdminDashboardScreen(),
              '/admin/students': (_) => const AdminStudentsScreen(),
              '/admin/faculty': (_) => const AdminFacultyScreen(),
              '/admin/departments': (_) => const AdminDepartmentsScreen(),
              '/admin/attendance': (_) => const AdminAttendanceScreen(),
              '/admin/exams': (_) => const AdminExamsScreen(),
              '/admin/fees': (_) => const AdminFeesScreen(),
              '/admin/timetables': (_) => const AdminTimetablesScreen(),
              '/admin/announcements': (_) => const AdminAnnouncementsScreen(),
              '/admin/reports': (_) => const AdminReportsScreen(),

              // Faculty Routes
              '/faculty/dashboard': (_) => const FacultyDashboardScreen(),
              '/faculty/attendance': (_) => const FacultyAttendanceScreen(),
              '/faculty/marks': (_) => const FacultyMarksScreen(),
              '/faculty/assignments': (_) => const FacultyAssignmentsScreen(),
              '/faculty/timetable': (_) => const FacultyTimetableScreen(),

              // Student Routes
              '/student/dashboard': (_) => const StudentDashboardScreen(),
              '/student/attendance': (_) => const StudentAttendanceScreen(),
              '/student/results': (_) => const StudentResultsScreen(),
              '/student/timetable': (_) => const StudentTimetableScreen(),
              '/student/fees': (_) => const StudentFeesScreen(),
              '/student/assignments': (_) => const StudentAssignmentsScreen(),
            },
          );
        },
      ),
    );
  }

  Widget _getInitialScreen(AuthProvider auth) {
    if (auth.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (!auth.isAuthenticated) {
      return const LoginScreen();
    }

    switch (auth.userRole) {
      case 'admin':
        return const AdminDashboardScreen();
      case 'faculty':
        return const FacultyDashboardScreen();
      case 'student':
      default:
        return const StudentDashboardScreen();
    }
  }
}

