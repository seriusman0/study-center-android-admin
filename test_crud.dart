import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://studycenter.seriusman.shop/api',
    headers: {
      'Accept': 'application/json',
    }
  ));

  try {
    // We need auth token. Let's just login
    final loginRes = await dio.post('/auth/login', data: {
      'login': 'admin@studycenter.com',
      'password': 'password'
    });
    
    final token = loginRes.data['token'];
    dio.options.headers['Authorization'] = 'Bearer $token';

    final res = await dio.post('/admin/cabangs', data: {
      'nama': 'Cabang Test API',
      'alamat': 'Test Alamat',
      'kontak': '08123456789',
    });
    
    print('CREATE SUCCESS: \${res.data}');
    
    // Test delete
    final id = res.data['id'];
    await dio.delete('/admin/cabangs/$id');
    print('DELETE SUCCESS');
    
  } on DioException catch (e) {
    print('ERROR: ${e.response?.statusCode}');
    print('BODY: ${e.response?.data}');
  }
}
