import 'package:flutter/material.dart';
import '../models/mentor_presensi_model.dart';
import '../services/api_service.dart';

class MentorPresensiProvider extends ChangeNotifier {
  final ApiService apiService;
  MentorPresensiProvider(this.apiService);
  
  List<MentorPresensiModel> _presensiList = [];
  bool _isLoading = false;
  String? _error;
  String? _from;
  String? _to;

  List<MentorPresensiModel> get presensiList => _presensiList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get fromDate => _from;
  String? get toDate => _to;

  Future<void> fetchPresensi() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.dio.get('/admin/mentor-presensi');
      final data = response.data['data']['data'] as List? ?? response.data['data'] as List; // handle pagination vs normal list just in case
      _presensiList = data.map((e) => MentorPresensiModel.fromJson(e)).toList();
      _from = response.data['from'];
      _to = response.data['to'];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
