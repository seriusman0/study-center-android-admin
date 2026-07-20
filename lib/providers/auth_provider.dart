import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  final _storage = const FlutterSecureStorage();

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider(this._apiService);

  Future<bool> checkAuthStatus() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) return false;

    try {
      final response = await _apiService.dio.get('/me');
      final Map<String, dynamic> data = response.data;
      final roles = data['role_names'] as List<dynamic>? ?? [];
      
      if (roles.contains('admin')) {
        _user = UserModel.fromJson(data);
        notifyListeners();
        return true;
      } else {
        await logout();
        return false;
      }
    } catch (e) {
      await logout();
      return false;
    }
  }

  Future<bool> login(String loginIdentifier, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.dio.post('/auth/login', data: {
        'login': loginIdentifier,
        'password': password,
      });

      final Map<String, dynamic> responseData = response.data;
      final Map<String, dynamic> userJson = responseData['user'];
      final List<dynamic> roles = userJson['roles'] ?? [];
      
      bool isAdmin = roles.any((role) => role['name'] == 'admin');

      if (!isAdmin) {
        _errorMessage = 'Akses ditolak: Anda bukan Admin';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final token = responseData['token'];
      await _storage.write(key: 'auth_token', value: token);
      
      _user = UserModel.fromJson(userJson);
      _isLoading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        final data = e.response!.data;
        if (data is Map && data.containsKey('message')) {
          _errorMessage = data['message'];
        } else {
          _errorMessage = 'Username/email atau password salah.';
        }
      } else {
        _errorMessage = 'Gagal terhubung ke server. Periksa koneksi Tailscale Anda.';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan sistem.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.dio.post('/auth/logout');
    } catch (_) {}
    await _storage.delete(key: 'auth_token');
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }
}
