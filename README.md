# 🍽️ Sol-Food - 홍대 주변 맛집 리뷰 플랫폼

<div align="center">

<table style="margin: 0 auto;">
<tr>
<td align="center"><img src="https://github.com/5y1ee.png?size=100" width="100" height="100" style="border-radius: 50%;"/></td>
<td align="center"><img src="https://github.com/jiwonns.png?size=100" width="100" height="100" style="border-radius: 50%;"/></td>
<td align="center"><img src="https://github.com/ogh010.png?size=100" width="100" height="100" style="border-radius: 50%;"/></td>
<td align="center"><img src="https://github.com/dlsundn.png?size=100" width="100" height="100" style="border-radius: 50%;"/></td>
<td align="center"><img src="https://github.com/sngsngUDON.png?size=100" width="100" height="100" style="border-radius: 50%;"/></td>
</tr>
<tr>
<td align="center"><strong><a href="https://github.com/5y1ee">이상윤</a></strong></td>
<td align="center"><strong><a href="https://github.com/jiwonns">박지원</a></strong></td>
<td align="center"><strong><a href="https://github.com/ogh010">오가희</a></strong></td>
<td align="center"><strong><a href="https://github.com/dlsundn">이선우</a></strong></td>
<td align="center"><strong><a href="https://github.com/sngsngUDON">안민석</a></strong></td>
</tr>
</table>

<br/>

![Java](https://img.shields.io/badge/Java-11-orange?style=for-the-badge&logo=java)
![Spring](https://img.shields.io/badge/Spring-5.2.25-green?style=for-the-badge&logo=spring)
![MyBatis](https://img.shields.io/badge/MyBatis-3.5.19-red?style=for-the-badge)
![Oracle](https://img.shields.io/badge/Oracle-19c-red?style=for-the-badge&logo=oracle)
![MariaDB](https://img.shields.io/badge/MariaDB-3.5.3-blue?style=for-the-badge&logo=mariadb)
![Maven](https://img.shields.io/badge/Maven-3.6+-orange?style=for-the-badge&logo=apache-maven)

**홍대입구역 주변 맛집 정보와 리뷰를 제공하는 웹 플랫폼**

[🚀 시작하기](#시작하기) • [📋 기능](#주요-기능) • [🏗️ 아키텍처](#아키텍처) • [🛠️ 기술-스택](#기술-스택)

</div>

---

## 📖 프로젝트 개요

Sol-Food는 홍대입구역 **주변**의 다양한 맛집 정보를 제공하고, 사용자들이 직접 리뷰를 작성하고 공유할 수 있는 웹 플랫폼입니다. 카카오 Local API를 활용한 자동 데이터 수집, 사용자 참여형 리뷰 시스템, 강력한 관리자/점주/사용자 권한 분리, 결제 관리 등 실전 서비스 수준의 기능을 제공합니다.

### 🎯 주요 특징

- 🗺️ **카카오맵 연동**: 실시간 위치 기반 맛집 검색
- 🤖 **자동 크롤링**: 카카오 Local API를 통한 맛집 정보 자동 수집
- ⭐ **별점 시스템**: 5점 만점 리뷰 및 평균 별점 제공
- 📱 **반응형 디자인**: 모바일과 데스크톱 모두 지원
- 👥 **다중 사용자**: 일반 사용자, 점주, 관리자 권한 분리

---

## 🚀 시작하기

### 📋 사전 요구사항

- **Java 11** 이상
- **Maven 3.6** 이상
- **Oracle Database 19c** 또는 **MariaDB 3.5.3**
- **카카오 개발자 계정** (Local API 키 필요)

### 🔧 설치 및 실행

1. **저장소 클론**
   ```bash
   git clone https://github.com/your-username/sol-food.git
   cd sol-food
   ```

2. **데이터베이스 설정**
   ```sql
   -- Oracle 또는 MariaDB에 데이터베이스 생성
   CREATE DATABASE sol_food;
   ```

3. **설정 파일 구성**
   ```properties
   # src/main/resources/application.properties
   db.driver=net.sf.log4jdbc.sql.jdbcapi.DriverSpy
   db.url=jdbc:log4jdbc:mariadb://YOUR_IP:YOUR_PORT_NUMBER/YOUR_DB_NAME
   db.username=YOUR_DB_USER_NAME
   db.password=YOUR_DB_PASSWORD
   server.ip=YOUR_IP
   server.port=YOUR_PORT_NUMBER
   
   
   # 카카오 API 키 설정
   kakao.restApiKey=YOUR_KAKAO_RESTAPI_KEY
   kakao.jsApiKey=YOUR_KAKAO_JS_KEY
   ```

4. **프로젝트 빌드 및 실행**
   ```bash
   mvn clean install
   mvn spring-boot:run
   ```

5. **웹 브라우저에서 접속**
   ```
   http://YOUR_IP:YOUR_PORT_NUMBER
   ```

---

## 📋 주요 기능

### 👤 사용자 기능
- **맛집 검색**: 카테고리별, 위치별 맛집 검색
- **리뷰 작성**: 별점, 사진, 텍스트 리뷰 작성
- **리뷰 조회**: 가게별 리뷰 목록 및 상세 보기
- **마이페이지**: 개인 정보 관리 및 내 리뷰 관리

### 🏪 점주 기능
- **가게 관리**: 가게 정보 등록 및 수정
- **메뉴 관리**: 메뉴 등록, 수정, 삭제
- **리뷰 모니터링**: 가게 리뷰 현황 확인

### 👨‍💼 관리자 기능
- **사용자 관리**: 회원 정보 조회 및 관리
- **가게 크롤링**: 카카오 API를 통한 자동 가게 정보 수집
- **통계 대시보드**: 사용자 활동 및 가게 통계 확인
- **결제 관리**: 통합결제 내역 조회 및 상세 페이지

---

## 📁 폴더/모듈 구조 및 역할

```
src/main/java/kr/co/solfood/
├── user/      # 일반 사용자(로그인, 게시판, 마이페이지, 리뷰, 카트, 가게, 메뉴, 좋아요, 게임, 카테고리 등)
├── owner/     # 점주(로그인, 가게, 리뷰, 메뉴)
├── admin/     # 관리자(홈, 로그인, 크롤러, DTO, 결제관리 등)
├── payments/  # 결제(통합결제, 단일결제, 공통, 충전 등)
├── common/    # 공통 상수, S3 등
├── util/      # 예외, 페이징, 에러코드 등 유틸리티

src/main/resources/kr/co/solfood/
├── user/      # 사용자 매퍼(Board, Login, Store, Review, Mypage 등)
├── owner/     # 점주 매퍼
├── admin/     # 관리자 매퍼(Home, Login)
├── payments/  # 결제 매퍼(Payment, Integrated, Charge)

src/main/webapp/WEB-INF/views/
├── user/      # 사용자 JSP(로그인, 게시판, 가게, 마이페이지, 리뷰, 카트, 게임 등)
├── owner/     # 점주 JSP(가게, 메뉴, 리뷰, 매출 등)
├── admin/     # 관리자 JSP(홈, 사용자/점주/결제/리뷰 관리, 로그인 등)
│   └── payment-management/ (home.jsp, detail.jsp)
├── common/    # 공통 헤더 등

src/main/webapp/js/admin/
├── payment-management.js  # 결제관리 JS
├── user-management.js     # 사용자관리 JS
├── owner-management.js    # 점주관리 JS

src/main/webapp/css/admin/
├── payment-management.css  # 결제관리 CSS
├── user-management.css     # 사용자관리 CSS
├── owner-management.css    # 점주관리 CSS

```

---

## 🏗️ 아키텍처 및 데이터 흐름

```
사용자/관리자 요청
  ↓
Controller (ex: AdminHomeController)
  ↓
Service (ex: AdminHomeService)
  ↓
Mapper (MyBatis, ex: AdminMapper.xml, PaymentMapper.xml 등)
  ↓
DB
  ↑
Model(DTO) → JSP View (ex: payment-management/detail.jsp)
```

- **결제 상세**: PageMaker<PaymentDistinctResponseDto>로 여러 결제 정보 리스트 전달
- JSP에서 forEach로 반복, 각 인원별 상세를 아코디언+카드로 출력
- DTO의 날짜 필드는 LocalDateTime → JSP에서 문자열로 출력
- 매퍼 XML은 src/main/resources/kr/co/solfood/ 하위에 기능별로 분리

---

## 🌟 결제관리 상세 페이지 (관리자)

- **경로**: `/admin/payment-management/detail?integratedpaymentId=...`
- **기능**:
  - 통합결제ID로 여러 인원의 결제 내역을 한 번에 조회
  - 각 인원의 결제 상세를 아코디언(토글)으로 펼쳐서 확인
  - 결제 정보(금액, 상태, 수단 등), 결제자 정보, 사용자 정보(프로필 포함) 등 섹션별 카드로 구분
  - Bootstrap 5 적용, 반응형/컬러/아이콘/뱃지 등 시각적 강조
  - 영수증 바로가기, 결제 취소 등 액션 버튼
  - 에러 발생 시 사용자 친화적 안내

#### 📄 JSP 구조 예시
```jsp
<div class="accordion" id="paymentAccordion">
  <c:forEach var="detail" items="${paymentDetail.list}" varStatus="status">
    <div class="accordion-item">
      <h2 class="accordion-header" id="heading${status.index}">
        <button class="accordion-button collapsed" ...>
          <span class="me-2">💳</span> <b>${detail.usersName}</b> <span class="text-muted">/ 결제ID: ${detail.paymentId}</span>
        </button>
      </h2>
      <div id="collapse${status.index}" ...>
        <div class="accordion-body">
          <div class="row g-4">
            <div class="col-md-6"> ...결제 정보 카드... </div>
            <div class="col-md-6"> ...결제자 정보 카드... </div>
          </div>
          <hr/>
          <div class="row g-4">
            <div class="col-md-12"> ...사용자 정보 카드... </div>
          </div>
        </div>
      </div>
    </div>
  </c:forEach>
</div>
```

#### 🛠️ 기술 포인트
- Bootstrap 5 CDN 적용 (CSS/JS)
- JSTL forEach, 조건문, 뱃지/아이콘/컬러 등 적극 활용
- DTO의 LocalDateTime은 JSP에서 문자열로 출력 (formatDate 사용 X)
- 컨트롤러에서 PageMaker로 리스트 전달, JSP에서 반복문으로 출력
- 에러 발생 시 500 에러 안내 및 원인(날짜 타입 등) 명확히 처리

---

## 🛠️ 사용 기술/라이브러리

### Backend
- Java 11, Spring Framework 5.2.25, Spring MVC, MyBatis 3.5.19, HikariCP 6.3.0
- Lombok, JUnit5, Mockito, log4jdbc

### Database
- Oracle 19c, MariaDB 3.5.3

### Frontend
- JSP, JSTL, Bootstrap 5, Kakao Maps API, jQuery(일부), CSS/JS 분리

### 외부 API
- Kakao Local API, Kakao Maps JavaScript API

### 기타
- S3 파일 업로드, 페이징 유틸, 커스텀 예외/에러코드, 세션/인터셉터 보안 등

---

## 🧩 DTO/매퍼/컨트롤러/뷰 연동
- DTO는 기능별로 src/main/java/kr/co/solfood/*/dto/에 위치
- 매퍼 XML은 src/main/resources/kr/co/solfood/*/에 위치, 기능별로 분리
- 컨트롤러는 각 도메인별로 분리, Model에 DTO/리스트/페이징 객체 전달
- JSP는 forEach, 조건문, Bootstrap 카드/아코디언 등으로 데이터 시각화
- JS/CSS는 기능별로 분리, 관리자 결제관리 전용 payment-management.js/css 존재

---

## 🛡️ 에러 처리/보안
- LocalDateTime 등 날짜 타입은 JSP에서 문자열로 출력, formatDate 사용 시 500에러 주의
- CustomException, ErrorCode, ErrorResponseEntity 등으로 예외/에러 일관 처리
- 세션/인터셉터로 관리자/점주/사용자 권한 분리 및 인증
- SQL 인젝션 방지, XSS 방지, 입력 검증 등 보안 적용

---

## 🧪 테스트/기여/문의
- JUnit5, Mockito 기반 단위/통합 테스트
- 테스트 코드 src/test/java/kr/co/solfood/ 하위에 위치
- 기여: Fork & PR, 이슈/문의는 GitHub Issues 또는 contact@sol-food.com

---

**🍽️ Sol-Food와 함께 홍대 주변 맛집을 발견하고, 강력한 관리자 결제 관리 기능으로 운영 효율을 높이세요!**
