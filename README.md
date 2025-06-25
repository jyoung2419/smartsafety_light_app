# Smart Safety Light App

> Flutter 기반의 경량형 스마트 안전관리 시스템

본 프로젝트는 스마트 안전관리 시스템을 Flutter 기반으로 설계 및 개발하였으며,  
기존 유사 시스템의 기능을 참고하여 전체 기능을 재구현하였습니다.

## 📱 주요 기능

- 작업 등록 및 작업 상세 관리
- 작업 위험등급 설정 (고위험 / 위험 / 일반)
- 작업자 교육 이수 및 서명 수집
- 작업 승인 프로세스 및 실시간 작업 상태 모니터링
- 안전신문고 기능 (안전 사고 신고 및 조치 관리)
- 신고 상세내용, 발생유형, 사진 등록, 조치결과 기록
- 작업 현황 통계 대시보드

## ⚙️ 기술 스택

- Flutter 3.7.0
- State Management: Provider
- REST API 연동: Spring Boot Backend
- 데이터 저장: Shared Preferences, Secure Storage
- 이미지 및 서명: Image Picker, Signature 패키지
- 환경변수 관리: flutter_dotenv
- 애니메이션: flutter_animate

## 📸 주요 화면 스크린샷
<p align="center">
  <img src="https://github.com/user-attachments/assets/0b2dafe6-5b2c-4f54-a36a-499163da22c0" width="45%" />
  <img src="https://github.com/user-attachments/assets/4590fa7d-ffd0-4bc9-8d02-9e92063895e8" width="45%" /><br>
  <img src="https://github.com/user-attachments/assets/5953647a-dd19-4e82-8823-9945d371cc80" width="45%" />
  <img src="https://github.com/user-attachments/assets/a740f5a6-4996-4a12-8bad-6487b0a548a4" width="45%" />
</p>

## 🚀 빌드 및 실행

### Android

```bash
flutter build apk --release
```

## 📝 개발환경
Flutter SDK: 3.7.0

Dart SDK: ^3.7.0

## 🔒 환경설정
assets/env/.env 파일에 개발/운영 서버 API 환경설정 관리


⚠️ 해당 프로젝트는 학습/포트폴리오용으로 제작되었으며, 상업적 목적이 아닙니다.
