import 'package:shared_preferences/shared_preferences.dart';

import 'auth_storage.dart';

class _IoAuthStorage implements AuthStorage {
  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  @override
  Future<String?> getString(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(key);
  }
}

AuthStorage createAuthStorageImpl() => _IoAuthStorage();
