import 'package:flutter/material.dart';
import '../models/cabang_model.dart';
import '../services/api_service.dart';

class CabangProvider extends ChangeNotifier {
  final ApiService _apiService;
  CabangProvider(this._apiService);
  
  List<CabangModel> _cabangs = [];
  bool _isLoading = false;
  String? _error;

  List<CabangModel> get cabangs => _cabangs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCabangs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.dio.get('/cabangs');
      final data = response.data as List;
      _cabangs = data.map((e) => CabangModel.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createCabang(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.dio.post('/admin/cabangs', data: data);
      await fetchCabangs();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCabang(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.dio.put('/admin/cabangs/$id', data: data);
      await fetchCabangs();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCabang(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.dio.delete('/admin/cabangs/$id');
      await fetchCabangs();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
