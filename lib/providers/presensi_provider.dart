import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/presensi_model.dart';
import '../services/api_service.dart';

class PresensiProvider extends ChangeNotifier {
  final ApiService apiService;
  PresensiProvider(this.apiService);
  
  List<PresensiModel> _presensiList = [];
  bool _isLoading = false;
  String? _error;

  List<PresensiModel> get presensiList => _presensiList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPresensi() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.dio.get('/presensi');
      final data = response.data['data'] as List;
      _presensiList = data.map((e) => PresensiModel.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createPresensi(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final fotoPath = data['foto_path'] as String?;
      final sendData = Map<String, dynamic>.from(data)..remove('foto_path');
      final formData = FormData.fromMap(sendData);
      if (fotoPath != null) {
        formData.files.add(MapEntry(
          'foto',
          await MultipartFile.fromFile(fotoPath),
        ));
      }
      await apiService.dio.post('/presensi', data: formData);
      await fetchPresensi();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deletePresensi(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.delete('/presensi/$id');
      await fetchPresensi();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
