import 'auth_storage.dart';

class _InMemoryAuthStorage implements AuthStorage {
  final Map<String, String> _store = <String, String>{};

  @override
  Future<String?> getString(String key) async => _store[key];

  @override
  Future<void> setString(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _store.remove(key);
  }
}

AuthStorage createAuthStorageImpl() => _InMemoryAuthStorage();
