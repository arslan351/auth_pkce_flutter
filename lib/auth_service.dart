import 'package:auth_test_project/storage_service.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:dio/dio.dart';

import 'api_client.dart';

class AuthService {
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final Dio dio = Dio();

  final ApiClient _apiClient = ApiClient();

  // Configuration Constants
  static const String _clientId = 'djezzy-student-campuce-mobile';
  static const String _redirectUri = 'myapp://auth/callback';
  static const String _issuer = 'http://192.168.73.169:8080/auth';

  // Manually define the configuration to bypass discovery completely
  static const _serviceConfig = AuthorizationServiceConfiguration(
    authorizationEndpoint: 'http://192.168.73.169:8080/auth/oauth2/authorize',
    tokenEndpoint: 'http://192.168.73.169:8080/auth/oauth2/token',
    endSessionEndpoint: 'http://192.168.73.169:8080/auth/connect/logout',
  );

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
      final AuthorizationTokenResponse? result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUri,
          serviceConfiguration: _serviceConfig,
          scopes: ['openid', 'offline_access'],
          allowInsecureConnections: true,
        ),
      );

      if (result != null) {
        // Save to Secure Storage immediately
        await StorageService().saveTokens(result.accessToken!, result.refreshToken);
        return result.accessToken;
      }
    } catch (e) {
      print('Auth Error: $e');
    }
    return null;
  }


  Future<TokenResponse?> refreshAccessToken(String oldRefreshToken) async {
    try {
      final TokenResponse? response = await _appAuth.token(
        TokenRequest(
          _clientId,
          _redirectUri,
          serviceConfiguration: _serviceConfig,
          refreshToken: oldRefreshToken,
          scopes: ['openid', 'offline_access'],
          allowInsecureConnections: true,
        ),
      );

      if (response != null && response.accessToken != null) {
        // ROTATION: The server gives us a new access token AND a new refresh token
        await StorageService().saveTokens(
            response.accessToken!,
            response.refreshToken // This could be the same or a new rotated one
        );

        print("Tokens rotated and saved successfully.");
        return response;
      }
    } catch (e) {
      print('Token refresh failed: $e');
      // If the refresh token is rejected, the session is dead.
      await StorageService().deleteTokens();
    }
    return null;
  }


}