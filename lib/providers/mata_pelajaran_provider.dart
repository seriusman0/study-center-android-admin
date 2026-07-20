import 'package:flutter/material.dart';
import '../models/mata_pelajaran_model.dart';
import '../services/api_service.dart';

class MataPelajaranProvider extends ChangeNotifier {
  final ApiService apiService;
  MataPelajaranProvider(this.apiService);
  
  List<MataPelajaranModel> _mapels = [];
  bool _isLoading = false;
  String? _error;

  List<MataPelajaranModel> get mapels => _mapels;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMataPelajaran() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.dio.get('/admin/mata-pelajaran');
      final data = response.data as List;
      _mapels = data.map((e) => MataPelajaranModel.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createMataPelajaran(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.post('/admin/mata-pelajaran', data: data);
      await fetchMataPelajaran();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateMataPelajaran(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.put('/admin/mata-pelajaran/$id', data: data);
      await fetchMataPelajaran();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteMataPelajaran(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.delete('/admin/mata-pelajaran/$id');
      await fetchMataPelajaran();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
