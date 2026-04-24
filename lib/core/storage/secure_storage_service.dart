import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage_keys.dart';

class SecureStorageService {
  SecureStorageService._();

  static final SecureStorageService instance = SecureStorageService._();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveAccessToken(String token) async {
    await _storage.write(
      key: StorageKeys.accessToken,
      value: token,
    );
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: StorageKeys.accessToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(
      key: StorageKeys.refreshToken,
      value: token,
    );
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: StorageKeys.refreshToken);
  }

  Future<void> saveUserId(String userId) async {
    await _storage.write(
      key: StorageKeys.userId,
      value: userId,
    );
  }

  Future<String?> getUserId() async {
    return _storage.read(key: StorageKeys.userId);
  }

  Future<void> saveUserEmail(String email) async {
    await _storage.write(
      key: StorageKeys.userEmail,
      value: email,
    );
  }

  Future<String?> getUserEmail() async {
    return _storage.read(key: StorageKeys.userEmail);
  }

  Future<void> saveUserRole(String role) async {
    await _storage.write(
      key: StorageKeys.userRole,
      value: role,
    );
  }

  Future<String?> getUserRole() async {
    return _storage.read(key: StorageKeys.userRole);
  }

  Future<void> clearSession() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
    await _storage.delete(key: StorageKeys.userId);
    await _storage.delete(key: StorageKeys.userEmail);
    await _storage.delete(key: StorageKeys.userRole);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}