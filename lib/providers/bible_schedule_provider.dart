import 'package:flutter/material.dart';
import '../models/bible_schedule_model.dart';
import '../services/api_service.dart';

class BibleScheduleProvider extends ChangeNotifier {
  final ApiService apiService;
  BibleScheduleProvider(this.apiService);
  
  List<BibleScheduleModel> _schedules = [];
  bool _isLoading = false;
  String? _error;

  List<BibleScheduleModel> get schedules => _schedules;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSchedules() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.dio.get('/admin/jurnal/bible-schedules');
      final data = response.data['data'] as List;
      _schedules = data.map((e) => BibleScheduleModel.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createSchedule(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.post('/admin/jurnal/bible-schedules', data: data);
      await fetchSchedules();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateSchedule(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.put('/admin/jurnal/bible-schedules/$id', data: data);
      await fetchSchedules();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteSchedule(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.delete('/admin/jurnal/bible-schedules/$id');
      await fetchSchedules();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
