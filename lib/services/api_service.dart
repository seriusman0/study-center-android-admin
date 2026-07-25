import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:io';
import 'package:dio/io.dart';

class ApiService {
  late Dio dio;
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  ApiService() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://studycenter.overcomer.my.id/api',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
      },
    ));
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token;
        try {
          token = await _storage.read(key: 'auth_token');
        } catch (_) {}
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
