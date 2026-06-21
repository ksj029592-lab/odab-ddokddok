import 'dart:convert';

import 'package:odab_ddokddok/features/auth/application/storage/auth_storage.dart';
import 'package:odab_ddokddok/features/auth/domain/auth_user.dart';

class AuthService {
  AuthService({AuthStorage? storage}) : _storage = storage ?? createAuthStorage();

  final AuthStorage _storage;

  static const String _usersKey = 'local_auth_users';
  static const String _currentUserIdKey = 'local_auth_current_user_id';
  static const String _legacyCurrentUserEmailKey = 'local_auth_current_email';

  Future<void> signUp({
    required String fullName,
    required String userId,
    required String password,
    required String phone,
    required String school,
    required String grade,
  }) async {
    final String normalizedUserId = userId.trim();
    if (normalizedUserId.isEmpty || password.isEmpty) {
      throw Exception('아이디와 비밀번호는 필수입니다.');
    }

    final List<AuthUser> users = await _readUsers();

    final bool exists = users.any((AuthUser u) => u.userId.toLowerCase() == normalizedUserId.toLowerCase());
    if (exists) {
      throw Exception('이미 존재하는 아이디입니다.');
    }

    users.add(
      AuthUser(
        fullName: fullName,
        userId: normalizedUserId,
        password: password,
        phone: phone,
        school: school,
        grade: grade,
      ),
    );

    await _writeUsers(users);
    await _storage.setString(_currentUserIdKey, normalizedUserId);
  }

  Future<void> signInWithIdPassword({
    required String userId,
    required String password,
  }) async {
    final String normalizedUserId = userId.trim();
    final List<AuthUser> users = await _readUsers();

    final AuthUser? found = users.where((AuthUser u) => u.userId.toLowerCase() == normalizedUserId.toLowerCase()).cast<AuthUser?>().firstWhere(
          (AuthUser? u) => u != null,
          orElse: () => null,
        );

    if (found == null || found.password != password) {
      throw Exception('아이디 또는 비밀번호가 올바르지 않습니다.');
    }

    await _storage.setString(_currentUserIdKey, found.userId);
  }

  Future<bool> isSignedIn() async {
    return await _getCurrentUserId() != null;
  }

  Future<AuthUser?> getCurrentUser() async {
    final String? currentUserId = await _getCurrentUserId();
    if (currentUserId == null) {
      return null;
    }

    final List<AuthUser> users = await _readUsers();
    for (final AuthUser u in users) {
      if (u.userId.toLowerCase() == currentUserId.toLowerCase()) {
        return u;
      }
    }
    return null;
  }

  Future<void> updateCurrentUser({
    required String fullName,
    required String phone,
    required String school,
    required String grade,
  }) async {
    final String? currentUserId = await _getCurrentUserId();
    if (currentUserId == null) {
      throw Exception('로그인 상태가 아닙니다.');
    }

    final List<AuthUser> users = await _readUsers();
    final List<AuthUser> updated = users
        .map(
          (AuthUser u) => u.userId.toLowerCase() == currentUserId.toLowerCase()
              ? u.copyWith(
                  fullName: fullName,
                  phone: phone,
                  school: school,
                  grade: grade,
                )
              : u,
        )
        .toList();

    await _writeUsers(updated);
  }

  Future<void> signOut() async {
    await _storage.remove(_currentUserIdKey);
    await _storage.remove(_legacyCurrentUserEmailKey);
  }

  Future<String?> _getCurrentUserId() async {
    final String? currentUserId = await _storage.getString(_currentUserIdKey);
    if (currentUserId != null) {
      return currentUserId;
    }

    // Migrate legacy key used by the previous email-based local auth flow.
    final String? legacyId = await _storage.getString(_legacyCurrentUserEmailKey);
    if (legacyId != null) {
      await _storage.setString(_currentUserIdKey, legacyId);
      await _storage.remove(_legacyCurrentUserEmailKey);
    }
    return legacyId;
  }

  Future<List<AuthUser>> _readUsers() async {
    final String raw = await _storage.getString(_usersKey) ?? '[]';
    final List<dynamic> data = jsonDecode(raw) as List<dynamic>;
    return data
        .map((dynamic e) => AuthUser.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _writeUsers(List<AuthUser> users) async {
    final String raw = jsonEncode(
      users.map((AuthUser u) => u.toJson()).toList(),
    );
    await _storage.setString(_usersKey, raw);
  }
}
