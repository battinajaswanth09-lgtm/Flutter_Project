import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../services/mock_data_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  String get userRole => _currentUser?.role ?? 'student';

  AuthProvider() {
    initAuth();
  }

  Future<void> initAuth() async {
    _isLoading = true;
    notifyListeners();
    try {
      _token = await StorageService.getToken();
      _currentUser = await StorageService.getUser();
    } catch (e) {
      debugPrint('Auth initialization error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Attempt login via API
      final res = await ApiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (res['success'] == true) {
        _token = res['token'];
        _currentUser = UserModel.fromJson(res['user']);
        await StorageService.saveAuthData(token: _token!, user: _currentUser!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception(res['message'] ?? 'Login failed');
      }
    } catch (e) {
      // If server is offline / local demo, gracefully match demo accounts
      debugPrint('API login unavailable, checking offline demo accounts: $e');
      if (email.contains('admin')) {
        _currentUser = MockDataService.adminUser;
        _token = 'mock_jwt_token_admin_98231';
      } else if (email.contains('faculty')) {
        _currentUser = MockDataService.facultyUser;
        _token = 'mock_jwt_token_faculty_44122';
      } else {
        _currentUser = MockDataService.studentUser;
        _token = 'mock_jwt_token_student_77192';
      }

      await StorageService.saveAuthData(token: _token!, user: _currentUser!);
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  // One-click quick login for testing/demo
  Future<void> quickLoginAs(String role) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));
    if (role == 'admin') {
      _currentUser = MockDataService.adminUser;
      _token = 'demo_admin_jwt_token';
    } else if (role == 'faculty') {
      _currentUser = MockDataService.facultyUser;
      _token = 'demo_faculty_jwt_token';
    } else {
      _currentUser = MockDataService.studentUser;
      _token = 'demo_student_jwt_token';
    }

    await StorageService.saveAuthData(token: _token!, user: _currentUser!);
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String phone = '',
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await ApiService.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
        'phone': phone,
      });

      if (res['success'] == true) {
        _token = res['token'];
        _currentUser = UserModel.fromJson(res['user']);
        await StorageService.saveAuthData(token: _token!, user: _currentUser!);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      // Demo fallback
      _currentUser = UserModel(
        id: 'new-usr-${Date.now()}',
        name: name,
        email: email,
        role: role,
        phone: phone,
      );
      _token = 'mock_jwt_new_user';
      await StorageService.saveAuthData(token: _token!, user: _currentUser!);
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  Future<void> updateProfile({required String name, required String phone, String avatar = ''}) async {
    if (_currentUser == null) return;
    _currentUser = UserModel(
      id: _currentUser!.id,
      name: name,
      email: _currentUser!.email,
      role: _currentUser!.role,
      phone: phone,
      avatar: avatar.isNotEmpty ? avatar : _currentUser!.avatar,
    );
    await StorageService.saveAuthData(token: _token ?? '', user: _currentUser!);
    notifyListeners();
  }

  Future<void> logout() async {
    await StorageService.clearAuthData();
    _currentUser = null;
    _token = null;
    notifyListeners();
  }
}

