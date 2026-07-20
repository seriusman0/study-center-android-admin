import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://studycenter.seriusman.shop/api',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Accept': 'application/json',
    },
  ));

  final _storage = const FlutterSecureStorage();

  ApiService() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // Global error logging/intercepting if needed
        return handler.next(e);
      },
    ));
  }
}
