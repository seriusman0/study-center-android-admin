import 'package:flutter/material.dart';
import '../models/life_item_model.dart';
import '../services/api_service.dart';

class LifeItemProvider extends ChangeNotifier {
  final ApiService apiService;
  LifeItemProvider(this.apiService);
  
  List<LifeItemModel> _items = [];
  bool _isLoading = false;
  String? _error;

  List<LifeItemModel> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchLifeItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.dio.get('/admin/jurnal-college/items');
      final data = response.data['data'] as List;
      _items = data.map((e) => LifeItemModel.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createLifeItem(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.post('/admin/jurnal-college/items', data: data);
      await fetchLifeItems();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateLifeItem(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.put('/admin/jurnal-college/items/$id', data: data);
      await fetchLifeItems();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteLifeItem(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.delete('/admin/jurnal-college/items/$id');
      await fetchLifeItems();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<List<int>> fetchStudentAssignments(int studentId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiService.dio.get('/admin/jurnal/students/$studentId/life-items');
      final data = response.data['data'] as List;
      // data contains list of assigned item ids
      _isLoading = false;
      notifyListeners();
      return data.map((e) => e as int).toList();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  Future<bool> syncStudentAssignments(int studentId, List<int> itemIds) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.post('/admin/jurnal/students/$studentId/life-items', data: {
        'items': itemIds,
      });
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
