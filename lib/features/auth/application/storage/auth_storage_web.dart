// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

import 'auth_storage.dart';

class _WebAuthStorage implements AuthStorage {
  @override
  Future<String?> getString(String key) async {
    return html.window.localStorage[key];
  }

  @override
  Future<void> setString(String key, String value) async {
    html.window.localStorage[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    html.window.localStorage.remove(key);
  }
}

AuthStorage createAuthStorageImpl() => _WebAuthStorage();
