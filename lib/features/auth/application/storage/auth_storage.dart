import 'auth_storage_stub.dart'
    if (dart.library.html) 'auth_storage_web.dart'
    if (dart.library.io) 'auth_storage_io.dart';

abstract class AuthStorage {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
  Future<void> remove(String key);
}

AuthStorage createAuthStorage() => createAuthStorageImpl();
