import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:odab_ddokddok/core/config/azure_config.dart';
import 'package:odab_ddokddok/features/auth/application/storage/auth_storage.dart';
import 'package:odab_ddokddok/features/auth/domain/auth_user.dart';
import 'package:http/http.dart' as http;

/// Azure Table Storage를 사용한 인증 서비스
class AzureTableStorageAuthService {
  AzureTableStorageAuthService({
    AuthStorage? storage,
    http.Client? httpClient,
  })  : _storage = storage ?? createAuthStorage(),
        _httpClient = httpClient ?? http.Client();

  final AuthStorage _storage;
  final http.Client _httpClient;

  static const String _tokenKey = 'auth_token';
  static const String _currentUserKey = 'auth_current_user';
  static const String _usersTable = AzureConfig.usersTableName;

  /// 회원 가입
  Future<void> signUp({
    required String fullName,
    required String userId,
    required String password,
    required String phone,
    required String school,
    required String grade,
  }) async {
    try {
      // 1. 중복 체크
      final AuthUser? existing = await _getUserByUserId(userId);
      if (existing != null) {
        throw Exception('이미 존재하는 아이디입니다.');
      }

      // 2. Table Storage에 사용자 저장
      final String uid = _generateUID();
      final Map<String, dynamic> userData = <String, dynamic>{
        'PartitionKey': 'users',
        'RowKey': userId,
        'uid': uid,
        'fullName': fullName,
        'userId': userId,
        'password': _hashPassword(password), // 해시 저장
        'phone': phone,
        'school': school,
        'grade': grade,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await _insertEntity(_usersTable, userData);

      // 3. 토큰 생성 및 로컬 저장
      final String token = _generateToken(uid, userId);
      await _storage.setString(_tokenKey, token);
      await _storage.setString(
        _currentUserKey,
        jsonEncode(<String, dynamic>{
          'uid': uid,
          'fullName': fullName,
          'userId': userId,
          'phone': phone,
          'school': school,
          'grade': grade,
        }),
      );
    } catch (e) {
      throw Exception('회원 가입 실패: $e');
    }
  }

  /// 로그인
  Future<void> signInWithIdPassword({
    required String userId,
    required String password,
  }) async {
    try {
      // 1. 사용자 조회
      final AuthUser? user = await _getUserByUserId(userId);
      if (user == null) {
        throw Exception('아이디 또는 비밀번호가 올바르지 않습니다.');
      }

      // 2. 비밀번호 확인
      if (!_verifyPassword(password, user.password)) {
        throw Exception('아이디 또는 비밀번호가 올바르지 않습니다.');
      }

      // 3. 토큰 생성 및 로컬 저장
      final String token = _generateToken('uid', userId);
      await _storage.setString(_tokenKey, token);
      await _storage.setString(
        _currentUserKey,
        jsonEncode(user.toJson()),
      );
    } catch (e) {
      throw Exception('로그인 실패: $e');
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    await _storage.remove(_tokenKey);
    await _storage.remove(_currentUserKey);
  }

  /// 로그인 여부 확인
  Future<bool> isSignedIn() async {
    final String? token = await _storage.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// 현재 사용자 조회
  Future<AuthUser?> getCurrentUser() async {
    final String? userJson = await _storage.getString(_currentUserKey);
    if (userJson == null) {
      return null;
    }

    try {
      return AuthUser.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// 사용자 정보 업데이트
  Future<void> updateCurrentUser({
    required String fullName,
    required String phone,
    required String school,
    required String grade,
  }) async {
    final AuthUser? currentUser = await getCurrentUser();
    if (currentUser == null) {
      throw Exception('로그인 상태가 아닙니다.');
    }

    try {
      // 1. Table Storage 업데이트
      final Map<String, dynamic> userData = <String, dynamic>{
        'PartitionKey': 'users',
        'RowKey': currentUser.userId,
        'uid': currentUser.userId,
        'fullName': fullName,
        'userId': currentUser.userId,
        'password': currentUser.password,
        'phone': phone,
        'school': school,
        'grade': grade,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await _updateEntity(_usersTable, userData);

      // 2. 로컬 저장소 업데이트
      await _storage.setString(
        _currentUserKey,
        jsonEncode(<String, dynamic>{
          'fullName': fullName,
          'userId': currentUser.userId,
          'phone': phone,
          'school': school,
          'grade': grade,
        }),
      );
    } catch (e) {
      throw Exception('프로필 업데이트 실패: $e');
    }
  }

  // ==================== Table Storage 헬퍼 메서드 ====================

  /// 사용자 ID로 사용자 조회
  Future<AuthUser?> _getUserByUserId(String userId) async {
    try {
      final String url =
          '${AzureConfig.tableServiceEndpoint}/$_usersTable(PartitionKey=\'users\',RowKey=\'$userId\')';

      final Map<String, String> headers = _generateAuthHeaders('GET', url);

      final http.Response response = await _httpClient.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        return AuthUser.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 엔티티 삽입
  Future<void> _insertEntity(
    String tableName,
    Map<String, dynamic> entity,
  ) async {
    try {
      final String url = '${AzureConfig.tableServiceEndpoint}/$tableName';

      final Map<String, String> headers = _generateAuthHeaders('POST', url);
      headers['Content-Type'] = 'application/json';

      final String body = jsonEncode(entity);

      final http.Response response = await _httpClient.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode != 201) {
        throw Exception('Table Storage 삽입 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('엔티티 삽입 오류: $e');
    }
  }

  /// 엔티티 업데이트
  Future<void> _updateEntity(
    String tableName,
    Map<String, dynamic> entity,
  ) async {
    try {
      final String partitionKey = entity['PartitionKey'] as String;
      final String rowKey = entity['RowKey'] as String;

      final String url =
          '${AzureConfig.tableServiceEndpoint}/$tableName(PartitionKey=\'$partitionKey\',RowKey=\'$rowKey\')';

      final Map<String, String> headers = _generateAuthHeaders('PUT', url);
      headers['Content-Type'] = 'application/json';

      final String body = jsonEncode(entity);

      final http.Response response = await _httpClient.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode != 204) {
        throw Exception('Table Storage 업데이트 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('엔티티 업데이트 오류: $e');
    }
  }

  // ==================== 인증 헬퍼 메서드 ====================

  /// Azure Storage 요청 서명
  Map<String, String> _generateAuthHeaders(String method, String url) {
    final String date = _formatDateForStorage();
    final String stringToSign =
        '$method\n\n\n$date\n/$_getCanonicalUrl(url)';

    final String signature = _generateSignature(stringToSign);

    return <String, String>{
      'Authorization':
          'SharedKey ${AzureConfig.storageAccountName}:$signature',
      'x-ms-date': date,
      'x-ms-version': '2020-08-04',
    };
  }

  /// 서명 생성
  String _generateSignature(String stringToSign) {
    final List<int> keyBytes =
        base64Decode(AzureConfig.storageAccountKey);
    final Hmac hmacSha256 = Hmac(sha256, keyBytes);
    final Digest digest =
        hmacSha256.convert(utf8.encode(stringToSign));
    return base64Encode(digest.bytes);
  }

  /// 날짜 포맷 (RFC 1123)
  String _formatDateForStorage() {
    final DateTime now = DateTime.now().toUtc();
    // RFC 1123 형식: "Fri, 27 Jun 2026 10:00:00 GMT"
    final List<String> days = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return '${days[now.weekday - 1]}, ${now.day.toString().padLeft(2, '0')} '
        '${months[now.month - 1]} ${now.year} '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')} GMT';
  }

  /// 정규화된 리소스 경로
  String _getCanonicalUrl(String url) {
    final Uri uri = Uri.parse(url);
    final String path = uri.path.split('/').skip(1).join('/');
    return path;
  }

  // ==================== 암호 헬퍼 메서드 ====================

  /// 비밀번호 해싱
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  /// 비밀번호 검증
  bool _verifyPassword(String password, String hash) {
    return _hashPassword(password) == hash;
  }

  // ==================== 기타 헬퍼 메서드 ====================

  /// UID 생성
  String _generateUID() {
    return 'uid_${DateTime.now().millisecondsSinceEpoch}_${(Math.random() * 10000).toInt()}';
  }

  /// 토큰 생성 (간단한 JWT 형태)
  String _generateToken(String uid, String userId) {
    final Map<String, dynamic> payload = <String, dynamic>{
      'uid': uid,
      'userId': userId,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': (DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch ~/
          1000),
    };

    return base64Encode(utf8.encode(jsonEncode(payload)));
  }
}

// crypto 패키지 없을 때의 간단한 난수 생성
class Math {
  static final DateTime _last = DateTime.now();

  static double random() {
    final DateTime now = DateTime.now();
    return (now.microsecond % 10000) / 10000;
  }
}
