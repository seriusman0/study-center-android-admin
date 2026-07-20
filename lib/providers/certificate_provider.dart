import 'package:flutter/material.dart';
import '../models/certificate_template_model.dart';
import '../models/issued_certificate_model.dart';
import '../services/api_service.dart';

class CertificateProvider extends ChangeNotifier {
  final ApiService apiService;
  CertificateProvider(this.apiService);

  List<CertificateTemplateModel> _templates = [];
  List<IssuedCertificateModel> _issued = [];
  bool _isLoading = false;
  String? _error;

  List<CertificateTemplateModel> get templates => _templates;
  List<IssuedCertificateModel> get issued => _issued;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTemplates() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.dio.get('/admin/certificates/templates');
      final data = response.data['data'] as List;
      _templates = data.map((e) => CertificateTemplateModel.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchIssued({String? search, int? templateId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiService.dio.get('/admin/certificates/issued', queryParameters: {
        if (search != null) 'search': search,
        if (templateId != null) 'template_id': templateId,
      });
      final data = response.data['data'] as List;
      _issued = data.map((e) => IssuedCertificateModel.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> issueCertificate(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.post('/admin/certificates/issued', data: data);
      await fetchIssued();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteIssuedCertificate(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await apiService.dio.delete('/admin/certificates/issued/$id');
      await fetchIssued();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
