import 'package:auth_test_project/storage_service.dart';
import 'package:dio/dio.dart';
import 'auth_service.dart';

class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  final AuthService authService;

  AuthInterceptor(this.dio, this.authService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print("--- REQUEST OUTGOING ---");
    print("Path: ${options.path}");

    final token = await StorageService().getAccessToken();
    print("INTERCEPTOR DEBUG: Token is ${token == null ? 'MISSING' : 'PRESENT'}");

    if (token == null || token.isEmpty) {
      print("ERR: Interceptor found NO token in storage!");
    } else {
      // 2. Log a snippet of the token to verify it's not "null" (as a string)
      print("SUCCESS: Token found. Starts with: ${token.substring(0, 10)}...");
      options.headers['Authorization'] = 'Bearer $token';
    }

    print("Headers: ${options.headers}");
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // 1. Try to refresh
      final storage = StorageService();
      final refreshToken = await storage.getRefreshToken();

      if (refreshToken != null) {
        // Call the rotation-aware refresh function
        final newTokens = await authService.refreshAccessToken(refreshToken);

        if (newTokens != null) {
          // Retry the original request with the new Access Token
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';

          // Execute the original request again
          final response = await dio.fetch(opts);
          return handler.resolve(response);
        }
      }
    }
    // If we couldn't refresh, let the error propagate
    return handler.next(err);
  }
}