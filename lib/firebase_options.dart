import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      final String apiKey = const String.fromEnvironment('FIREBASE_WEB_API_KEY', defaultValue: '');
      final String appId = const String.fromEnvironment('FIREBASE_WEB_APP_ID', defaultValue: '');
      final String messagingSenderId = const String.fromEnvironment('FIREBASE_WEB_MESSAGING_SENDER_ID', defaultValue: '');
      final String projectId = const String.fromEnvironment('FIREBASE_WEB_PROJECT_ID', defaultValue: '');
      final String authDomain = const String.fromEnvironment('FIREBASE_WEB_AUTH_DOMAIN', defaultValue: '');
      final String storageBucket = const String.fromEnvironment('FIREBASE_WEB_STORAGE_BUCKET', defaultValue: '');

      if (apiKey.isEmpty || appId.isEmpty || messagingSenderId.isEmpty || projectId.isEmpty) {
        throw UnsupportedError(
          'Firebase 웹 설정이 없습니다. dart-define(FIREBASE_WEB_*) 값 설정이 필요합니다.',
        );
      }

      return FirebaseOptions(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        authDomain: authDomain.isEmpty ? null : authDomain,
        storageBucket: storageBucket.isEmpty ? null : storageBucket,
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          '현재 플랫폼 Firebase 설정이 없습니다. 웹 우선으로 FIREBASE_WEB_*를 설정해 주세요.',
        );
      case TargetPlatform.fuchsia:
        throw UnsupportedError('Fuchsia는 지원되지 않습니다.');
    }
  }
}
