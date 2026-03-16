import 'package:dio/dio.dart';

class ApiClient {
  // Static instance (Singleton)
  static final Dio _dio = Dio();

  static Dio get dio => _dio;

  // Call this immediately after getting the token in your Auth flow
  static void setToken(String token) {
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
    ));
  }
}