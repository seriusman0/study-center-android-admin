import 'package:flutter/material.dart';
import '../models/role_model.dart';
import '../services/api_service.dart';

class RoleProvider extends ChangeNotifier {
  final ApiService apiService;
  RoleProvider(this.apiService);
  
  List<RoleModel> _roles = [];
  bool _isLoading = false;
  String? _error;

  List<RoleModel> get roles => _roles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRoles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.dio.get('/admin/roles');
      final data = response.data['data'] as List;
      _roles = data.map((e) => RoleModel.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createRole(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.post('/admin/roles', data: data);
      await fetchRoles();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateRole(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.put('/admin/roles/$id', data: data);
      await fetchRoles();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteRole(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.delete('/admin/roles/$id');
      await fetchRoles();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
