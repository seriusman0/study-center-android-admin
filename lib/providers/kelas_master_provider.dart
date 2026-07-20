import 'package:flutter/material.dart';
import '../models/kelas_master_model.dart';
import '../services/api_service.dart';

class KelasMasterProvider extends ChangeNotifier {
  final ApiService apiService;
  KelasMasterProvider(this.apiService);
  
  List<KelasMasterModel> _kelas = [];
  bool _isLoading = false;
  String? _error;

  List<KelasMasterModel> get kelas => _kelas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchKelasMaster() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.dio.get('/kelas-master');
      final data = response.data['data'] as List;
      _kelas = data.map((e) => KelasMasterModel.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createKelasMaster(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.post('/kelas-master', data: data);
      await fetchKelasMaster();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateKelasMaster(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.put('/kelas-master/$id', data: data);
      await fetchKelasMaster();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteKelasMaster(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.delete('/kelas-master/$id');
      await fetchKelasMaster();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
