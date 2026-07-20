import 'package:flutter/material.dart';
import '../models/college_bible_model.dart';
import '../models/college_item_model.dart';
import '../services/api_service.dart';

class CollegeJurnalProvider extends ChangeNotifier {
  final ApiService apiService;
  CollegeJurnalProvider(this.apiService);

  List<CollegeBibleModel> _bibles = [];
  List<CollegeItemModel> _items = [];
  bool _isLoading = false;
  String? _error;

  List<CollegeBibleModel> get bibles => _bibles;
  List<CollegeItemModel> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBibles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.dio.get('/admin/jurnal-college/bible');
      // CollegeBibleApiController returns 'items' which is paginated, so it has 'data'
      final data = response.data['items']['data'] as List;
      _bibles = data.map((e) => CollegeBibleModel.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.dio.get('/admin/jurnal-college/items');
      // CollegeItemApiController returns 'items' directly as an array
      final data = response.data['items'] as List;
      _items = data.map((e) => CollegeItemModel.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAll() async {
    await Future.wait([fetchBibles(), fetchItems()]);
  }
}
