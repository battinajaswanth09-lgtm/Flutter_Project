class AppConstants {
  static const String appName = 'CampusPulse';
  static const String appSubtitle = 'College Management System';
  static const String appVersion = '1.0.0';

  // API Base URL - Configurable for Render deployment or local development
  // In Flutter web on Render, this points to the hosted Render backend API
  static const String defaultApiUrl = 'https://college-management-backend.onrender.com/api';
  static const String localApiUrl = 'http://localhost:5000/api';

  // Breakpoints
  static const double mobileBreakpoint = 650;
  static const double tabletBreakpoint = 1100;

  // Storage Keys
  static const String tokenKey = 'campus_auth_token';
  static const String userKey = 'campus_user_data';
  static const String roleKey = 'campus_user_role';

  // Demo Credentials for quick testing
  static const String demoAdminEmail = 'admin@college.edu';
  static const String demoAdminPassword = 'AdminPassword123!';

  static const String demoFacultyEmail = 'faculty@college.edu';
  static const String demoFacultyPassword = 'FacultyPassword123!';

  static const String demoStudentEmail = 'student@college.edu';
  static const String demoStudentPassword = 'StudentPassword123!';
}

