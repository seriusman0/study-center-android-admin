import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../models/dashboard_stats.dart';

class UserProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<UserModel> _users = [];
  DashboardStats? _stats;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  
  // Pagination info
  int _currentPage = 1;
  int _lastPage = 1;
  int _totalUsersCount = 0;

  List<UserModel> get users => _users;
  DashboardStats? get stats => _stats;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get totalUsersCount => _totalUsersCount;

  UserProvider(this._apiService);

  Future<void> fetchDashboardStats() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.dio.get('/admin/dashboard');
      _stats = DashboardStats.fromJson(response.data);
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUsers({
    int page = 1,
    String? query,
    String? role,
    int? cabangId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final queryParams = {
        'page': page,
        if (query != null && query.isNotEmpty) 'q': query,
        if (role != null && role != 'Semua') 'role': role.toLowerCase(),
        if (cabangId != null) 'cabang_id': cabangId,
      };

      final response = await _apiService.dio.get('/admin/users', queryParameters: queryParams);
      final List<dynamic> data = response.data['data'] ?? [];
      
      if (page == 1) {
        _users = data.map((u) => UserModel.fromJson(u)).toList();
      } else {
        _users.addAll(data.map((u) => UserModel.fromJson(u)));
      }

      _currentPage = response.data['current_page'] ?? 1;
      _lastPage = response.data['last_page'] ?? 1;
      _totalUsersCount = response.data['total'] ?? 0;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat data user.';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createUser({
    required String name,
    required String? email,
    required String password,
    required int? cabangId,
    required List<String> roleNames,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.dio.post('/admin/users', data: {
        'name': name,
        if (email != null && email.isNotEmpty) 'email': email,
        'password': password,
        if (cabangId != null) 'cabang_id': cabangId,
        'role_names': roleNames,
      });
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal membuat user baru.';
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUser(
    int userId, {
    required String name,
    required String username,
    required String? email,
    String? password,
    required int? cabangId,
    required bool isActive,
    required List<String> roleNames,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = {
        'name': name,
        'username': username,
        'email': email,
        if (password != null && password.isNotEmpty) 'password': password,
        'cabang_id': cabangId,
        'is_active': isActive,
        'role_names': roleNames,
      };

      final response = await _apiService.dio.put('/admin/users/$userId', data: data);
      final updatedUser = UserModel.fromJson(response.data);
      
      final index = _users.indexWhere((u) => u.id == userId);
      if (index != -1) {
        _users[index] = updatedUser;
      }
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui data user.';
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<UserModel?> fetchUserDetail(int userId) async {
    try {
      final response = await _apiService.dio.get('/admin/users/$userId');
      final user = UserModel.fromJson(response.data);
      final index = _users.indexWhere((u) => u.id == userId);
      if (index != -1) {
        _users[index] = user;
        notifyListeners();
      }
      return user;
    } catch (_) {
      return null;
    }
  }

  Future<bool> updateUserRole(int userId, List<String> roles) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.dio.patch(
        '/admin/users/$userId/role',
        data: {'roles': roles},
      );
      final updatedUser = UserModel.fromJson(response.data);
      final index = _users.indexWhere((u) => u.id == userId);
      if (index != -1) {
        _users[index] = updatedUser;
      }
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui role user.';
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleUserActive(int userId) async {
    try {
      final response = await _apiService.dio.patch('/admin/users/$userId/toggle-active');
      final newIsActive = response.data['is_active'] == true || response.data['is_active'] == 1;
      final index = _users.indexWhere((u) => u.id == userId);
      if (index != -1) {
        _users[index] = _users[index].copyWith(isActive: newIsActive);
      }
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteUser(int userId) async {
    try {
      await _apiService.dio.delete('/admin/users/$userId');
      _users.removeWhere((u) => u.id == userId);
      _totalUsersCount--;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }
}
