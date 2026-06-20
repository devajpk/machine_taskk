import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_config.dart';

class SecureTokenService {
  final FlutterSecureStorage _storage;

  const SecureTokenService(this._storage);

  /// Save authentication token
  Future<void> saveAuthToken(String token) async {
    await _storage.write(
      key: SecureStorageKeys.authToken,
      value: token,
    );
  }

  /// Get authentication token
  Future<String?> getAuthToken() async {
    return _storage.read(
      key: SecureStorageKeys.authToken,
    );
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(
      key: SecureStorageKeys.refreshToken,
      value: token,
    );
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return _storage.read(
      key: SecureStorageKeys.refreshToken,
    );
  }

  /// Save user id
  Future<void> saveUserId(String userId) async {
    await _storage.write(
      key: SecureStorageKeys.userId,
      value: userId,
    );
  }

  /// Get user id
  Future<String?> getUserId() async {
    return _storage.read(
      key: SecureStorageKeys.userId,
    );
  }

  /// Remove auth token
  Future<void> deleteAuthToken() async {
    await _storage.delete(
      key: SecureStorageKeys.authToken,
    );
  }

  /// Remove refresh token
  Future<void> deleteRefreshToken() async {
    await _storage.delete(
      key: SecureStorageKeys.refreshToken,
    );
  }

  /// Clear all secure data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Check authentication state
  Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }
}