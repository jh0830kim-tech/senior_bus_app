# 어르신 버스도우미 🚌

어르신이 버튼 하나로 가까운 정류장과 버스 노선을 확인하는 쉬운 버스 앱.

## 핵심 기능
- F1 가까운 정류장 찾기 (검색 버튼 하나)
- F2 길찾기: 빠른 길(환승 포함 최단시간) / 편한 길(환승 없음)
- F3 큰 글씨, 직관적 시니어 UI
- F4 전화 서비스콜 (모든 화면 하단 고정)
- F5 자주 가는 곳 등록/삭제 → 누르면 바로 길찾기
- F6 탑승 안내: 대기시간 → 환승 안내 → 하차 안내

## 프로젝트 구조 (모듈형)
```
lib/
├── app/       # 라우팅, 테마, 의존성 조립
├── core/      # 공통 UI(큰 버튼/큰 글씨), 테마, 상수
├── data/      # API·로컬저장 구현체 (Repository 구현)
├── domain/    # 엔티티, Repository 인터페이스, UseCase
└── features/  # 화면 모듈 (새 기능 = 폴더 추가)
```
의존 방향: `features → domain ← data`, `core`는 어디서나 사용.
화면(features)은 data를 직접 알지 못하며, 반드시 domain 인터페이스를 통해 접근한다.

## 시작하기
```bash
flutter create .   # 최초 1회: android/ios 플랫폼 폴더 생성
flutter pub get
flutter run        # 키 없이 실행하면 Mock(가짜 데이터) 모드
```

## 실제 API 연동
키는 코드에 넣지 않고 실행 시 주입한다 (자동으로 실제 모드 전환):
```bash
flutter run \
  --dart-define=TAGO_KEY=공공데이터포털_일반인증키_Decoding \
  --dart-define=ODSAY_KEY=ODsay_발급키 \
  --dart-define=KAKAO_KEY=카카오_REST_API_키
```
- **TAGO** (정류장·도착정보): data.go.kr 에서 "국토교통부 버스정류소정보 / 버스도착정보" 활용신청 → **일반 인증키(Decoding)** 사용
- **ODsay** (환승 포함 길찾기): lab.odsay.com 에서 키 발급
- **카카오 로컬** (목적지 장소 검색): developers.kakao.com 앱 생성 → REST API 키 사용 (KAKAO_KEY만 따로 넣어도 장소 검색은 실제로 동작)

### 권한 설정 (flutter create 후 1회)
- Android `android/app/src/main/AndroidManifest.xml`:
  ```xml
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
  <uses-permission android:name="android.permission.RECORD_AUDIO"/>
  ```
- iOS `ios/Runner/Info.plist` 에 아래 키 + 사용 사유 문구:
  - `NSLocationWhenInUseUsageDescription` (위치)
  - `NSMicrophoneUsageDescription` (마이크)
  - `NSSpeechRecognitionUsageDescription` (음성 인식)

## 브랜치 전략
`main`(배포) ← `develop`(통합) ← `feature/*`, `fix/*`
커밋 규칙: `feat:` `fix:` `docs:` `refactor:`
