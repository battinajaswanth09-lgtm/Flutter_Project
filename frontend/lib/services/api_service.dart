import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import 'storage_service.dart';

class ApiService {
  // Can be configured at runtime or environment variable
  // Uses the deployed Render backend by default; falls back gracefully to mock data
  static String baseUrl = AppConstants.defaultApiUrl;

  static Future<Map<String, String>> _getHeaders() async {
    final token = await StorageService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<dynamic> get(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 8));

      return _processResponse(response);
    } catch (e) {
      throw Exception('Network error or server unreachable: $e');
    }
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 8));

      return _processResponse(response);
    } catch (e) {
      throw Exception('Network error or server unreachable: $e');
    }
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .put(uri, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 8));

      return _processResponse(response);
    } catch (e) {
      throw Exception('Network error or server unreachable: $e');
    }
  }

  static Future<dynamic> delete(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .delete(uri, headers: headers)
          .timeout(const Duration(seconds: 8));

      return _processResponse(response);
    } catch (e) {
      throw Exception('Network error or server unreachable: $e');
    }
  }

  static dynamic _processResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      final message = body['message'] ?? 'An error occurred. Status code: ${response.statusCode}';
      throw Exception(message);
    }
  }
}

