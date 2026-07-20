import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../models/blog_model.dart';
import '../models/cabang_model.dart';
import 'package:image_picker/image_picker.dart';

class BlogProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<BlogModel> _blogs = [];
  List<CabangModel> _cabangs = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  List<BlogModel> get blogs => _blogs;
  List<CabangModel> get cabangs => _cabangs;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  BlogProvider(this._apiService);

  Future<void> fetchCabangs() async {
    try {
      final response = await _apiService.dio.get('/cabangs');
      final List<dynamic> data = response.data;
      _cabangs = data.map((c) => CabangModel.fromJson(c)).toList();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> fetchBlogs({String? search, String? cabangSlug}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.dio.get('/blogs', queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (cabangSlug != null) 'cabang': cabangSlug,
      });

      final List<dynamic> data = response.data['data'] ?? [];
      _blogs = data.map((b) => BlogModel.fromJson(b)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat daftar blog.';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBlog({
    required String title,
    required String content,
    required int cabangId,
    required List<String> tags,
    XFile? image,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      Map<String, dynamic> formDataMap = {
        'title': title,
        'content': content,
        'cabang_id': cabangId,
      };

      for (int i = 0; i < tags.length; i++) {
        formDataMap['tags[$i]'] = tags[i];
      }

      if (image != null) {
        formDataMap['image'] = await MultipartFile.fromFile(
          image.path,
          filename: image.name,
        );
      }

      FormData formData = FormData.fromMap(formDataMap);

      await _apiService.dio.post('/blogs', data: formData);
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menyimpan blog. Pastikan form terisi dengan benar.';
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<String?> uploadImageInline(XFile image) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path, filename: image.name),
      });

      final response = await _apiService.dio.post('/blogs/upload-image', data: formData);
      return response.data['url'] as String?;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteBlog(int blogId) async {
    try {
      await _apiService.dio.delete('/blogs/$blogId');
      _blogs.removeWhere((b) => b.id == blogId);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }
}
