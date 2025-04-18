# time-to-pray-app
Flutter 기반으로 개발 중인 기도서 앱 애플리케이션입니다.

## ⚙️ Flutter 프로젝트 초기화

이 레포는 GitHub 저장소명이 `time-to-pray-app`이지만,  
Dart/Flutter의 패키지명 규칙에 따라 내부적으로는 `time_to_pray_app` 이름으로 생성되어야 합니다.

Flutter 프로젝트를 생성하려면 아래 명령어를 사용하세요:

```bash
cd time-to-pray-app
flutter create --project-name time_to_pray_app .
flutter pub get
flutter run
```

## 🛠️ 개발 환경

- **Flutter 버전**: 3.6.2  
- **개발 플랫폼**: Android (iOS 추후 지원 예정)  
- **백엔드 API 서버**: Naver Cloud 내 Linux 환경  
- **프로그래밍 언어**: Dart (Flutter), Java (Spring 예정)

## 📱 주요 기능

- 사용자 친화적인 UI 구성
- 실시간 데이터 연동
- 안정적인 상태 관리 (예: GetX, Provider 등)

## 🧱 프로젝트 구조

```bash
lib/
├── main.dart              # 앱 진입점
├── src/
│   ├── home/              # 홈 화면 관련 코드
│   ├── user/              # 사용자 관련 기능 (로그인, 회원가입 등)
│   ├── common/            # 공통 위젯, 유틸 등
│   └── ...
assets/
├── images/                # 이미지 리소스
├── fonts/                 # 폰트 리소스
└── ...