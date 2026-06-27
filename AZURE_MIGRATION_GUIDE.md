# Firebase → Azure 마이그레이션 가이드

## ✅ 완료된 작업

### 1. **패키지 변경**
- ❌ **제거됨**: firebase_core, firebase_auth, cloud_firestore
- ✅ **추가됨**: dio (HTTP 클라이언트), permission_handler

### 2. **파일 삭제**
- ❌ `lib/firebase_options.dart` (Firebase 설정)
- ❌ `lib/features/auth/application/cloud_auth_service.dart` (Firebase 인증)

### 3. **새 파일 추가**
- ✅ `lib/core/config/azure_config.dart` (Azure API 설정)
- ✅ `lib/features/auth/application/azure_auth_service.dart` (Azure 인증 서비스)

### 4. **Provider 업데이트**
- `auth_providers.dart`: `azureAuthServiceProvider` 추가

---

## 🚀 **구현 단계**

### **Step 1: Azure 리소스 생성** (Azure Portal)

```bash
# 1. 리소스 그룹 생성
rg-odab-ddokddok

# 2. App Service 생성 (Node.js)
odab-ddokddok-api (eastasia)

# 3. Cosmos DB 또는 SQL Database 생성
- Database: user_db
- Collections: users

# 4. App Service에 환경 변수 설정
AZURE_API_BASE_URL=https://odab-ddokddok-api.azurewebsites.net
JWT_SECRET=<your-secret-key>
DATABASE_CONNECTION_STRING=<your-db-connection>
```

### **Step 2: Node.js 백엔드 배포**

```bash
# backend 디렉토리 생성
mkdir backend
cd backend

# 프로젝트 초기화
npm init -y
npm install express cors dotenv bcrypt jsonwebtoken mongodb

# server.js 작성 (AZURE_BACKEND_EXAMPLE.js 참고)
# ...

# Azure App Service에 배포
az webapp deployment source config-zip \
  --resource-group rg-odab-ddokddok \
  --name odab-ddokddok-api \
  --src-path app.zip
```

### **Step 3: Flutter 앱 설정**

```dart
// 1. azure_config.dart에서 API URL 설정
static const String apiBaseUrl = 'https://odab-ddokddok-api.azurewebsites.net';

// 2. 회원 관리 화면에서 사용
final authService = ref.read(azureAuthServiceProvider);

// 3. 회원 가입
await authService.signUp(
  fullName: 'John Doe',
  userId: 'john_doe',
  password: 'password123',
  phone: '010-1234-5678',
  school: 'High School',
  grade: '1',
);

// 4. 로그인
await authService.signInWithIdPassword(
  userId: 'john_doe',
  password: 'password123',
);

// 5. 현재 사용자 조회
final user = await authService.getCurrentUser();

// 6. 프로필 업데이트
await authService.updateCurrentUser(
  fullName: 'Jane Doe',
  phone: '010-9876-5432',
  school: 'University',
  grade: '4',
);

// 7. 로그아웃
await authService.signOut();
```

---

## 📊 **아키텍처**

```
Flutter App (스캔/인증)
    ↓
Azure API Gateway (권장: API Management)
    ↓
Azure App Service (Node.js 백엔드)
    ↓
Azure Cosmos DB / SQL Database (사용자 데이터)
    ↓
Azure Storage (이미지 저장)
```

---

## 🔐 **보안 고려사항**

### 1. **JWT 토큰**
- 만료 시간: 7일 (설정 가능)
- 로컬 스토리지에 저장 (shared_preferences)
- 요청 헤더에 `Authorization: Bearer <token>` 포함

### 2. **CORS 설정**
```javascript
// backend에서 CORS 설정
app.use(cors({
  origin: ['https://odab-ddokddok-web.azurestaticapps.net'],
  credentials: true
}));
```

### 3. **환경 변수**
- `.env` 파일 사용 (git에 커밋 금지)
- Azure Key Vault에 저장 (권장)

### 4. **데이터베이스 보안**
```sql
-- SQL Server 방화벽 설정
-- 승인된 IP만 접근 허용
```

---

## 📈 **마이그레이션 체크리스트**

- [ ] Azure 리소스 생성
- [ ] Node.js 백엔드 배포
- [ ] JWT 토큰 검증 테스트
- [ ] API 엔드포인트 테스트
- [ ] iOS/Android 권한 설정
- [ ] 오류 처리 및 로깅
- [ ] 보안 감사
- [ ] 성능 최적화

---

## 🆘 **문제 해결**

### **에러: "연결 시간 초과"**
```dart
// azure_config.dart에서 타임아웃 증가
static const int requestTimeoutSeconds = 60;
```

### **에러: "401 Unauthorized"**
```dart
// 토큰이 만료되었을 수 있음
// 다시 로그인 필요
await authService.signInWithIdPassword(...);
```

### **에러: "CORS policy"**
```javascript
// backend에서 CORS 헤더 확인
app.use(cors({
  origin: '*', // 개발 중에만 사용
  credentials: true
}));
```

---

## 📞 **지원**

- [Azure App Service 문서](https://docs.microsoft.com/azure/app-service)
- [Cosmos DB 문서](https://docs.microsoft.com/azure/cosmos-db)
- [Flutter Dio 패키지](https://pub.dev/packages/dio)

---

**마이그레이션 완료!** 이제 Azure 백엔드 배포만 남겼습니다. 🎉
