import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const _storage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    aOptions: AndroidOptions(),
  );

  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';

  Future<void> saveTokens(String access, String? refresh) async {
    await _storage.write(key: keyAccessToken, value: access);
    if (refresh != null) {
      await _storage.write(key: keyRefreshToken, value: refresh);
    }
  }

  Future<String?> getAccessToken() async => await _storage.read(key: keyAccessToken);

  Future<String?> getRefreshToken() async => await _storage.read(key: keyRefreshToken);

  Future<void> deleteTokens() async {
    await _storage.delete(key: keyAccessToken);
    await _storage.delete(key: keyRefreshToken);
  }
}