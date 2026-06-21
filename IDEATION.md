# 오답똑똑 — 기획 검토 & AI 교차검증 정리

> 작성일: 2026-06-06
> 검토 대상: 사용자의 오답노트 앱 기획서 "오답똑똑"
> 검토 관점: **앱 개발 관점만** (사업화/수익화 제외)
> 교차검증 모델: Gemini 2.5 Pro · Claude Sonnet 4.5 · GPT-5 mini

---

## 1. 원본 기획서 요약

- **프로젝트명**: 오답똑똑
- **문제 정의**: 오답을 옮겨 적는 시간이 다시 푸는 시간보다 길어 학습 효율 저하 + 노트를 다시 안 펼침
- **핵심 기능**
  1. AI 스캔 + 수식·도표·글씨체 자동 보정 + 낙서/풀이 흔적 제거 → "새 문제처럼" 만들기
  2. 키워드 자동 인식 → 단원/난이도 분류 + 망각곡선 기반 알림 복습
- **기대효과**: 옮겨 적기 시간 단축 / 약점 데이터 확인 / 자투리 시간 복습
- **핵심 화면**: 메인(대시보드) / 스캔(카메라+팝업+다중 문제 분리) / 라이브러리(과목 서랍 + 정렬)
- **타겟**: 고등학생 우선 가정
- **사용자 선택 MVP**: 중간형 (스캔 + OCR + 자동 분류(LLM) + 망각곡선 알림 + 약점 분석)
- **플랫폼**: iOS/Android 동시 (Flutter)

---

## 2. 강점

- 문제 정의가 구체적이고 학생 페인포인트와 정확히 일치
- 망각곡선(SRS) 활용 — Anki/SuperMemo가 학습 효과를 입증한 검증된 이론
- 화면 구성(메인/스캔/라이브러리)이 단순·명료
- 과목별 "서랍" 메타포가 학생에게 친숙
- Flutter 선택은 iOS/Android 동시 개발에 합리적

---

## 3. 약점·리스크 (개발 관점)

### A. AI 기능의 기술 난이도 과소평가
- "수식 자동 보정"은 단순 OCR이 아니라 Mathpix / pix2tex / TrOCR 등 별도 모델 필요
- "도표/그림 보정"의 정의가 모호 — 원근 보정/업스케일링 정도가 현실적 한계
- "낙서/풀이 흔적 제거"는 분할(SAM) + 인페인팅(LaMa/SD inpaint) 조합 필요, **원본 글씨 손상 위험 큼**

### B. "완전 새로운 문제처럼" 약속이 깨질 위험
- 인페인팅 품질이 들쭉날쭉하면 핵심 가치 제안이 무너짐
- 텍스트 위에 겹친 낙서를 깨끗이 지우는 건 사실상 불가능

### C. 누락된 화면·요소가 많음
- 문제 상세 화면 (재풀이, 정답 확인, 오답 이유 메모)
- 통계/약점 분석 화면 (기대효과에 있는데 화면이 없음)
- 온보딩 (학년·과목·목표 설정, 카메라 가이드)
- 설정 (알림 시간, 계정, 백업)
- 데이터 모델 정의 자체가 부재

### D. 모호한 정의들
- **"동일 문제 인식"**: 이미지 해시? OCR 텍스트 유사도? 임베딩 cosine?
- **"난이도 자동 판정 기준"**: LLM 추정? 사용자 입력? 정답률 기반?
- **"오답 횟수" 카운팅**: 다시 풀 때마다 +1? 사용자가 수동으로? 자동 감지?
- **"복습 달성률"**: 분자/분모 정의 (오늘 풀어야 할 / 실제 푼)

### E. 데이터 인프라 누락
- 오프라인 모드 지원 여부
- 데이터 백업/동기화 (기기 변경 시)
- 이미지 파일 크기 관리 (압축 전략)

---

## 4. AI 3-Way 교차검증 결과

### 4.1 만장일치 합의 사항

| 항목 | 세 모델 공통 결론 |
|---|---|
| 전체 방향성 | 컨셉은 타당. 학습 가치 명확 |
| **낙서/풀이 흔적 제거** | **v1에서 빼라** — 매우 어려움, ROI 낮음, 원본 텍스트 손상 위험 |
| **도표/그림 보정** | "보정" 정의가 모호. 원근 보정·업스케일링 정도가 한계 |
| **수식 인식** | Mathpix API(상용) 또는 pix2tex/LaTeX-OCR(오픈소스). 손글씨 정확도 60~70% |
| **자동 키워드 분류** | 가능. GPT-4o-mini / Gemini Flash / Claude Haiku로 문제당 $0.001~0.005 |
| **망각곡선 알림** | 가장 쉬움. `flutter_local_notifications` + SM-2 알고리즘 |
| **누락 화면** | 문제 상세 / 통계 / 온보딩 / 설정 모두 추가 필요 |
| **데이터 모델** | 코딩 전에 스키마 정의가 최우선 |
| **백엔드** | Firebase (Auth + Firestore + Storage) 압도적 추천 |
| **OCR(일반 텍스트)** | Google ML Kit (무료, 온디바이스) → 부족하면 PaddleOCR/CLOVA OCR |

### 4.2 기능별 난이도 평가 종합

| 기능 | Gemini 2.5 Pro | Claude Sonnet 4.5 | GPT-5 mini | 종합 |
|---|---|---|---|---|
| 일반 텍스트 OCR | 쉬움 | 중간 | 중간 | **쉬움~중간** |
| 수식 자동 보정 | 어려움 | 중간~어려움 | 매우 어려움 | **어려움** |
| 도표/그림 보정 | 매우 어려움 | 모호(쉬움~불가능) | 중간(부분) | **모호, 정의 필요** |
| 낙서/풀이 제거 | 어려움 | 매우 어려움 | 어려움~매우 어려움 | **매우 어려움** |
| 자동 키워드 분류 | 중간 | 중간 | 중간 | **중간** |
| 난이도 자동 판정 | 명시 없음 | 어려움 | 어려움(주관성) | **어려움** |
| 망각곡선 알림 | 쉬움 | 쉬움 | 쉬움~중간 | **쉬움** |
| 약점 데이터 분석 | 명시 없음 | 중간 | 명시 없음 | **중간** |

### 4.3 모델 간 차이점

| 쟁점 | Gemini 2.5 Pro | Claude Sonnet 4.5 | GPT-5 mini |
|---|---|---|---|
| 사용자 선택 "중간형 MVP" 평가 | 적절 (AI 보정만 v2로) | **사실상 고급형, 더 줄여야** | 좁히되 수식 OCR은 Mathpix로 초기 포함 가능 |
| 자동 분류(LLM) Phase | v1 OK | **v2로 미루기** | v1 MVP 포함 OK (수동 수정 허용 전제) |
| 상태관리 | 언급 없음 | **Riverpod 2.x** | 언급 없음 |
| 로컬 DB | Firestore | Hive 또는 Drift | Drift(SQLite) 또는 sembast |
| 동일 문제 인식 | 이미지 유사도(pHash) 또는 OCR 비교 | 이미지 해시 / OCR 유사도 | **텍스트 정규화 + LaTeX 정규화 + 이미지 임베딩 cosine > 0.9 조합** |
| 인페인팅 도구 | OpenCV + SAM | LaMa, ClipDrop (비추천) | SAM + LaMa/SD inpaint |
| 백엔드 | Firebase | Firebase 우선, Supabase 대안 | Firebase or Supabase, **벡터 DB(Qdrant/FAISS)** 추가 제안 |

---

## 5. 종합 권장 MVP 로드맵

### Phase 1 — 진짜 MVP (목표 3개월)
세 모델 모두 동의한 **현실적 최소 범위**

```
스캔
├─ 카메라 촬영 (image_picker / camera)
├─ 원근 보정·크롭·선명화 (OpenCV)
└─ 이미지 자르기로 "필요한 문제만 선택" UX

OCR (텍스트 검색용)
└─ Google ML Kit Text Recognition (무료, 온디바이스)

기록·분류
├─ 사용자 수동 과목 분류 (국·영·수·사·과)
├─ 사용자 수동 태그 (난이도/단원)
└─ 사용자 오답 이유 메모

라이브러리
├─ 과목별 서랍 뷰
├─ 정렬 (최신순, 오답횟수순)
└─ 문제 상세 화면 (이미지 + OCR 텍스트 + 메모)

복습 루프
├─ 망각곡선 스케줄 (SM-2 또는 1·3·7·14·30일)
├─ flutter_local_notifications 푸시
└─ 메인 대시보드 (오늘 복습할 문제 수)

데이터
└─ 로컬 저장 (Hive 또는 Drift/SQLite)
```

### Phase 2 — 기획서의 "중간형" (+6개월)

```
+ Firebase Auth + Storage + Firestore (계정/동기화/백업)
+ LLM 자동 분류 (GPT-4o-mini / Gemini Flash / Claude Haiku)
+ Mathpix 또는 pix2tex 수식 인식
+ 약점 분석 차트 (fl_chart) — 과목별/단원별 오답률
+ 동일 문제 인식 (텍스트 + 임베딩 유사도)
```

### Phase 3 — 야심찬 부분 (사용자 검증 후 선택)

```
? 낙서/풀이 흔적 제거 (SAM + LaMa or ClipDrop API)
? 도표 의미적 보정
? 난이도 자동 판정 (정답률 기반 + LLM 보조)
※ 실 사용자가 진짜 원하는지 확인 후에만 진행
```

---

## 6. 데이터 모델 (Problem 스키마)

```text
Problem {
  id                  : string (UUID)
  originalImageUrl    : string                 // 원본 사진
  processedImageUrl   : string?                // 보정 후 (Phase 2)
  ocrText             : string?                // OCR 결과
  latex               : string?                // 수식 (Phase 2, Mathpix)
  subject             : enum (국|영|수|사|과)
  unit                : string?                // 단원
  tags                : string[]               // 자유 태그
  difficulty          : enum (상|중|하)?       // Phase 1은 사용자 입력
  wrongCount          : int                    // 다시 풀어 틀린 횟수
  userNote            : string?                // 오답 이유 메모
  createdAt           : datetime
  lastReviewedAt      : datetime?
  nextReviewAt        : datetime               // 망각곡선 계산 결과
  reviewInterval      : int (days)             // SM-2 결과 간격
  easeFactor          : float                  // SM-2 ease factor
  contentHash         : string                 // 동일 문제 인식용 (Phase 2)
  embedding           : float[]?               // 의미 유사도 (Phase 2)
}
```

---

## 7. 권장 기술 스택

### Frontend
- **Flutter 3.x** (iOS/Android 단일 코드베이스)
- **Riverpod 2.x** (상태관리)
- 화면 패키지: `flutter_math_fork` (LaTeX 렌더링), `fl_chart` (통계)

### 카메라·이미지
- `camera`, `image_picker`, `image_cropper`
- `opencv_dart` (원근 보정, 선명화)

### OCR
- **Phase 1**: `google_mlkit_text_recognition` (무료, 온디바이스)
- **Phase 2 수식**: Mathpix API (유료, 정확도↑) 또는 pix2tex 자체 호스팅

### LLM (Phase 2)
- GPT-4o-mini / Gemini 1.5 Flash / Claude 3.5 Haiku
- 문제당 $0.001~0.005 예상

### 로컬 DB
- **Hive** (경량, NoSQL 스타일) 또는 **Drift** (SQLite, 복잡 쿼리)

### 백엔드 (Phase 2)
- **Firebase** (Auth + Firestore + Storage + Functions + FCM)
- 대안: Supabase (PostgreSQL 기반)

### 알림
- `flutter_local_notifications` + 플랫폼별 백그라운드 스케줄링

### Phase 3 (선택)
- 인페인팅: SAM + LaMa, ClipDrop API
- 벡터 DB: Qdrant, FAISS, Pinecone (동일 문제 인식·유사 문제 추천)

---

## 8. 우선 해결해야 할 결정 사항

기획서를 코딩 단계로 넘기기 전 반드시 명확히 정의할 항목:

| 항목 | 권장 정의 |
|---|---|
| **동일 문제 인식** | Phase 1은 무시(중복 허용). Phase 2에서 OCR 텍스트 정규화 + 이미지 임베딩 cosine ≥ 0.9 |
| **난이도 자동 판정** | Phase 1은 사용자가 상/중/하 선택. Phase 3에서 정답률 기반 자동화 |
| **오답 횟수 카운팅** | 문제 상세 화면에 "다시 풀기" 세션 → "맞음/틀림" 버튼 → 틀림 시 +1 |
| **복습 달성률** | (오늘 알림 받은 문제 중 사용자가 "복습 완료" 표시한 수) / (오늘 알림 받은 총 문제 수) |
| **"보정"의 범위 정의** | Phase 1: 원근 보정 + 선명화만. "새 문제처럼"이라는 표현은 v2 이후로 표시 변경 |
| **낙서 제거 정책** | v1에서 제외. 대신 **이미지 크롭**으로 필요한 부분만 잘라 저장 |

---

## 9. 핵심 권고 3가지 (모델 종합)

1. **"낙서 제거"는 v1에서 완전히 빼라.** 개인 개발자가 만들 수 있는 가장 어려운 기능이며 만족도 보장이 어려움. 대신 "이미지 크롭"으로 대체.
2. **데이터 모델 + 6개 화면 와이어프레임 먼저.** 코드 한 줄 쓰기 전에 Problem 스키마, 동일 문제 인식 규칙, 오답 횟수 카운팅 정책을 확정해야 한다.
3. **3개월 안에 작동하는 진짜 MVP**를 만들고, 본인이 직접 1~2달 사용해본 뒤 LLM 자동 분류·인페인팅 추가 여부를 결정하라. AI 마법보다 **복습 경험**이 핵심.

---

## 10. 다음 단계 후보

- [ ] Problem 데이터 모델 + 6개 화면 와이어프레임 상세 설계
- [ ] Phase 1 MVP 화면별 기능 명세서 작성
- [ ] Flutter 프로젝트 골격(폴더 구조 + `pubspec.yaml` 의존성) 셋업
- [ ] SM-2 망각곡선 알고리즘 의사코드 정리
- [ ] OCR 비교 PoC (Google ML Kit vs PaddleOCR) 후보 선정
