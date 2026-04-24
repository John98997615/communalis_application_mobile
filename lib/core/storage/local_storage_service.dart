import 'package:shared_preferences/shared_preferences.dart';

import 'storage_keys.dart';

class LocalStorageService {
  LocalStorageService._();

  static final LocalStorageService instance = LocalStorageService._();

  Future<void> saveSelectedChildId(String childId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.selectedChildId, childId);
  }

  Future<String?> getSelectedChildId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.selectedChildId);
  }

  Future<void> saveHasSeenOnboarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.hasSeenOnboarding, value);
  }

  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(StorageKeys.hasSeenOnboarding) ?? false;
  }

  Future<void> removeSelectedChildId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.selectedChildId);
  }
}