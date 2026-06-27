# Azure Table Storage 마이그레이션 가이드

## ✅ 완료된 작업

### 1. **패키지 변경**
- ❌ **제거됨**: `dio`, `firebase_core`, `firebase_auth`, `cloud_firestore`
- ✅ **추가됨**: `http`, `crypto` (Azure Table Storage 인증)

### 2. **새 파일 생성**
- ✅ `lib/core/config/azure_config.dart` (Table Storage 설정)
- ✅ `lib/features/auth/application/azure_table_storage_auth_service.dart` (Table Storage 인증)

### 3. **파일 삭제**
- ❌ `lib/features/auth/application/azure_auth_service.dart` (REST API 기반)

### 4. **Provider 업데이트**
- `auth_providers.dart`: `azureTableStorageAuthServiceProvider` 추가

---

## 🚀 **Azure Table Storage 설정**

### **Step 1: Azure Storage Account 생성** (Azure Portal)

```bash
# 1. 리소스 그룹 생성
rg-odab-ddokddok

# 2. Storage Account 생성
odabddokddok (eastasia)

# 3. Access Key 복사
Settings → Access Keys → Copy Connection String or Account Key
```

### **Step 2: 환경 변수 설정**

Flutter 실행 시 다음 환경 변수를 전달:

```bash
# Windows PowerShell
puro flutter run -d web \
  --dart-define=AZURE_STORAGE_ACCOUNT_NAME=odabddokddok \
  --dart-define=AZURE_STORAGE_ACCOUNT_KEY=<your-account-key>

# macOS/Linux
puro flutter run -d web \
  --dart-define=AZURE_STORAGE_ACCOUNT_NAME=odabddokddok \
  --dart-define=AZURE_STORAGE_ACCOUNT_KEY=<your-account-key>

# 또는 .env 파일 사용
# .env (git에 커밋 금지)
AZURE_STORAGE_ACCOUNT_NAME=odabddokddok
AZURE_STORAGE_ACCOUNT_KEY=<your-account-key>
```

### **Step 3: Flutter 앱에서 사용**

```dart
import 'package:odab_ddokddok/features/auth/application/auth_providers.dart';

// 1. Provider에서 서비스 가져오기
final authService = ref.read(azureTableStorageAuthServiceProvider);

// 2. 회원 가입
await authService.signUp(
  fullName: 'John Doe',
  userId: 'john_doe',
  password: 'password123',
  phone: '010-1234-5678',
  school: 'High School',
  grade: '1',
);

// 3. 로그인
await authService.signInWithIdPassword(
  userId: 'john_doe',
  password: 'password123',
);

// 4. 현재 사용자 조회
final user = await authService.getCurrentUser();
print('로그인 사용자: ${user?.fullName}');

// 5. 프로필 업데이트
await authService.updateCurrentUser(
  fullName: 'Jane Doe',
  phone: '010-9876-5432',
  school: 'University',
  grade: '4',
);

// 6. 로그아웃
await authService.signOut();

// 7. 로그인 상태 확인
final isSignedIn = await authService.isSignedIn();
```

---

## 📊 **데이터 구조**

### **Users 테이블**

| PartitionKey | RowKey | 필드 | 타입 |
|---|---|---|---|
| users | {userId} | uid | String |
| | | fullName | String |
| | | password | String (SHA-256 해시) |
| | | phone | String |
| | | school | String |
| | | grade | String |
| | | createdAt | DateTime (ISO 8601) |
| | | updatedAt | DateTime (ISO 8601) |

**예시:**
```
PartitionKey: "users"
RowKey: "john_doe"
uid: "uid_1719489600000_5234"
fullName: "John Doe"
password: "abc123def456..." (SHA-256 해시)
phone: "010-1234-5678"
school: "High School"
grade: "1"
createdAt: "2026-06-27T10:00:00.000Z"
updatedAt: "2026-06-27T10:00:00.000Z"
```

---

## 🔐 **보안 고려사항**

### 1. **Access Key 관리**
```dart
// ❌ 나쁜 예: 하드코딩
static const String storageAccountKey = 'abc123def456...';

// ✅ 좋은 예: 환경 변수
static const String storageAccountKey = String.fromEnvironment(
  'AZURE_STORAGE_ACCOUNT_KEY',
  defaultValue: '',
);

// ✅ 최고의 예: Azure Key Vault
// (별도 백엔드 API를 통해 토큰 발급)
```

### 2. **비밀번호 저장**
- SHA-256 해싱 사용
- 솔트(Salt) 추가 권장 (향후)

### 3. **CORS 설정**
Azure Portal → Storage Account → CORS 설정:
```
Allowed origins: https://odab-ddokddok-web.azurestaticapps.net
Allowed methods: GET, POST, PUT, DELETE, OPTIONS
Allowed headers: *
Exposed headers: x-ms-error-code
Max age: 86400
```

### 4. **인증 서명**
- 모든 요청에 `SharedKey` 인증 사용
- 요청 서명: HMAC-SHA256

---

## 🏗️ **아키텍처**

```
Flutter App
    ↓
Azure Table Storage (User 데이터)
    ↓
SharedPreferences (로컬 토큰 캐시)
```

---

## 📈 **마이그레이션 체크리스트**

- [ ] Azure Storage Account 생성
- [ ] Access Key 복사
- [ ] 환경 변수 설정
- [ ] CORS 설정
- [ ] 회원 가입 테스트
- [ ] 로그인 테스트
- [ ] 프로필 업데이트 테스트
- [ ] 로그아웃 테스트
- [ ] 보안 감사

---

## 🆘 **문제 해결**

### **에러: "400 Bad Request"**
- CORS 설정 확인
- 요청 헤더의 `x-ms-date` 형식 확인 (RFC 1123)
- Account Key 유효성 확인

### **에러: "401 Unauthorized"**
- Account Key가 올바른지 확인
- Account Name 확인
- 서명 생성 로직 확인

### **에러: "404 Not Found"**
- Table 이름 확인 (Users, Problems)
- PartitionKey와 RowKey 확인

### **에러: "중복 아이디"**
```dart
try {
  await authService.signUp(...);
} on Exception catch (e) {
  print('에러: ${e.toString()}');
  // "이미 존재하는 아이디입니다."
}
```

---

## 💰 **비용 추정**

| 작업 | 월간 비용 |
|------|---------|
| Storage Account (첫 5GB) | $0.50 |
| 100,000 읽기 작업 | $0.05 |
| 100,000 쓰기 작업 | $0.05 |
| **총합** | **~$1/월** |

---

## 📚 **참고 자료**

- [Azure Table Storage 문서](https://docs.microsoft.com/azure/storage/tables)
- [Table Storage REST API](https://docs.microsoft.com/rest/api/storageservices/table-service-rest-api)
- [Azure Storage 가격](https://azure.microsoft.com/pricing/details/storage/tables)

---

**마이그레이션 완료!** 이제 Azure Table Storage를 사용한 클라우드 기반 사용자 관리가 준비되었습니다. 🎉
