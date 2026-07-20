import 'package:flutter/material.dart';
import '../models/weekly_verse_model.dart';
import '../services/api_service.dart';

class WeeklyVerseProvider extends ChangeNotifier {
  final ApiService apiService;
  WeeklyVerseProvider(this.apiService);
  
  List<WeeklyVerseModel> _verses = [];
  bool _isLoading = false;
  String? _error;

  List<WeeklyVerseModel> get verses => _verses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchVerses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.dio.get('/admin/jurnal/weekly-verses');
      final data = response.data['data'] as List;
      _verses = data.map((e) => WeeklyVerseModel.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createVerse(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.post('/admin/jurnal/weekly-verses', data: data);
      await fetchVerses();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateVerse(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.put('/admin/jurnal/weekly-verses/$id', data: data);
      await fetchVerses();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteVerse(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.delete('/admin/jurnal/weekly-verses/$id');
      await fetchVerses();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
