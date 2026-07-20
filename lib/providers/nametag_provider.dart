import 'package:flutter/material.dart';
import '../models/nametag_model.dart';
import '../services/api_service.dart';

class NametagProvider extends ChangeNotifier {
  final ApiService apiService;
  NametagProvider(this.apiService);
  
  List<NametagModel> _nametags = [];
  bool _isLoading = false;
  String? _error;

  List<NametagModel> get nametags => _nametags;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchNametags() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.dio.get('/admin/nametags');
      final data = response.data['data'] as List;
      _nametags = data.map((e) => NametagModel.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> generateNametags(List<int> userIds) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.post('/admin/nametags/generate', data: {
        'user_ids': userIds,
      });
      await fetchNametags();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
