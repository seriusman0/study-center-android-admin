import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class PendaftaranProvider extends ChangeNotifier {
  final ApiService apiService;
  PendaftaranProvider(this.apiService);

  List<UserModel> _pendaftarList = [];
  bool _isLoading = false;
  String? _error;

  List<UserModel> get pendaftarList => _pendaftarList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPendaftar({String status = 'semua'}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.dio.get('/admin/pendaftaran', queryParameters: {
        'status': status,
      });
      final data = response.data['data'] as List;
      _pendaftarList = data.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> validasiPendaftar(int userId, String status, {String? catatanAdmin, int? cabangId}) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.patch('/admin/pendaftaran/$userId/validasi', data: {
        'status': status,
        'catatan_admin': catatanAdmin,
        'cabang_id': cabangId,
      });
      await fetchPendaftar();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<String?> generateUpdateLink(int userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiService.dio.post('/admin/pendaftaran/$userId/generate-update-link');
      _isLoading = false;
      notifyListeners();
      return response.data['url'] as String?;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
