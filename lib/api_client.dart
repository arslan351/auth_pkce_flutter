import 'package:auth_test_project/storage_service.dart';
import 'package:dio/dio.dart';
import 'AuthInterceptor.dart';
import 'auth_service.dart';


class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final Dio _dio = Dio();
  Dio get dio => _dio;

  // Initialize once in your app startup
  Future<void> init(AuthService authService) async {
    await StorageService().deleteTokens();
    _dio.interceptors.add(AuthInterceptor(_dio, authService));
  }
}