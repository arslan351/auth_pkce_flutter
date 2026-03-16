import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:dio/dio.dart';

import 'api_client.dart';

class AuthService {
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final Dio dio = Dio();

  // Configuration Constants
  static const String clientId = 'djezzy-student-campuce-mobile';
  static const String redirectUri = 'myapp://auth/callback';
  static const String issuer = 'http://192.168.73.169:8080/auth';

  /*Future<void> login() async {
    try {
      // 1. Perform discovery, authorize, and exchange in one go
      final AuthorizationTokenResponse? result =
      await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUri,
          issuer: issuer,
          scopes: ['openid'],
          allowInsecureConnections: true,
        ),
      );

      if (result != null) {
        print('Token Received: ${result.accessToken}');

        // 2. Add an Interceptor to your Dio instance to automatically
        // attach the token to future API calls
        dio.interceptors.add(InterceptorsWrapper(
          onRequest: (options, handler) {
            options.headers['Authorization'] = 'Bearer ${result.accessToken}';
            return handler.next(options);
          },
        ));
      }
    } catch (e) {
      print('Auth Error: $e');
    }
  }
*/



  Future<String?> login() async {
    try {
      // Manually define the configuration to bypass discovery completely
      final serviceConfiguration = AuthorizationServiceConfiguration(
        authorizationEndpoint: 'http://192.168.73.169:8080/auth/oauth2/authorize',
        tokenEndpoint: 'http://192.168.73.169:8080/auth/oauth2/token',
        endSessionEndpoint: 'http://192.168.73.169:8080/auth/connect/logout',
      );

      final AuthorizationTokenResponse? result =
      await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUri,
          serviceConfiguration: serviceConfiguration, // Use manual config
          scopes: ['openid','offline_access'],
          allowInsecureConnections: true, // Keep this
        ),
      );

      if (result != null) {
        print('Login Success: ${result.accessToken}');
        ApiClient.setToken(result.accessToken!);
        return result.accessToken; // RETURN THE TOKEN HERE
      }
    } catch (e) {
      print('Auth Error: $e');
    }
    return null; // Return null only if something failed
  }


}