# 🍽️ Sol-Food - 홍대 맛집 리뷰 플랫폼

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

**Sol-Food**는 홍대입구역 주변의 다양한 맛집 정보를 제공하고, 사용자들이 직접 리뷰를 작성하고 공유할 수 있는 웹 플랫폼입니다. 카카오 Local API를 활용한 자동 데이터 수집과 사용자 참여형 리뷰 시스템을 통해 신뢰할 수 있는 맛집 정보를 제공합니다.

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
   kakao.js.key=YOUR_KAKAO_JS_KEY
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

---

## 🏗️ 아키텍처

```
Sol-Food/
├── 📁 src/main/java/kr/co/solfood/
│   ├── 👤 user/           # 일반 사용자 기능
│   │   ├── login/         # 로그인/회원가입
│   │   ├── store/         # 맛집 정보
│   │   ├── review/        # 리뷰 시스템
│   │   ├── menu/          # 메뉴 관리
│   │   └── mypage/        # 마이페이지
│   ├── 🏪 owner/          # 점주 기능
│   │   └── login/         # 점주 로그인
│   ├── 👨‍💼 admin/         # 관리자 기능
│   │   ├── home/          # 관리자 홈
│   │   ├── crawler/       # 웹 크롤링
│   │   └── dto/           # 데이터 전송 객체
│   └── ⚙️ configuration/  # 설정 클래스
├── 📁 src/main/resources/
│   ├── 📄 kr/co/solfood/  # MyBatis 매퍼 XML
│   └── 📄 webapp/         # JSP 뷰 파일
└── 📁 src/test/           # 테스트 코드
```

### 🔄 데이터 흐름

```
사용자 요청 → Controller → Service → Mapper → Database
                ↓
            View(JSP) ← Model ← Service ← Mapper
```

---

## 🛠️ 기술 스택

### 🎯 Backend
- **Java 11**: 메인 프로그래밍 언어
- **Spring Framework 5.2.25**: 웹 애플리케이션 프레임워크
- **Spring MVC**: 웹 MVC 패턴 구현
- **MyBatis 3.5.19**: ORM 프레임워크
- **HikariCP 6.3.0**: 데이터베이스 커넥션 풀

### 🗄️ Database
- **Oracle Database 19c**: 메인 데이터베이스
- **MariaDB 3.5.3**: 대체 데이터베이스 지원
- **log4jdbc**: SQL 로깅

### 🌐 Frontend
- **JSP**: 서버 사이드 뷰 템플릿
- **JSTL**: JSP 표준 태그 라이브러리
- **Kakao Maps API**: 지도 및 위치 서비스
- **Bootstrap**: 반응형 UI 프레임워크

### 🔧 개발 도구
- **Maven**: 빌드 및 의존성 관리
- **Lombok**: 보일러플레이트 코드 제거
- **JUnit 5**: 단위 테스트
- **Mockito**: 모킹 프레임워크

### 📡 외부 API
- **Kakao Local API**: 맛집 정보 수집
- **Kakao Maps JavaScript API**: 지도 서비스

---

## 📊 주요 기능 상세

### 🗺️ 맛집 검색 시스템
```java
@GetMapping("/user/store")
public String getStoreList(@RequestParam String category, Model model) {
   List<StoreVO> storeList = service.getCategoryStore(category);
   model.addAttribute("store", storeList);
   return "user/store";
}
```

### ⭐ 리뷰 시스템
- **별점 평가**: 1~5점 별점 시스템
- **리뷰 작성**: 제목, 내용, 별점, 사진 업로드
- **통계 제공**: 평균 별점, 별점별 개수 통계

### 🤖 자동 크롤링
```java
@Component
public class StoreWebCrawler {
   public List<StoreVO> crawlHongdaeRestaurants() {
      // 카카오 Local API를 통한 홍대 맛집 정보 수집
   }
}
```

---

## 🧪 테스트

### 단위 테스트 실행
```bash
mvn test
```

### 주요 테스트 케이스
- `LoginServiceImplTest`: 로그인 서비스 테스트
- `ExceptionTest`: 예외 처리 테스트
- `AdminTest`: 관리자 기능 테스트

---

## 📈 성능 최적화

### 🚀 성능 개선 사항
- **HikariCP**: 고성능 커넥션 풀 사용
- **MyBatis**: 효율적인 SQL 매핑
- **캐싱**: 자주 조회되는 데이터 캐싱
- **인덱싱**: 데이터베이스 인덱스 최적화

---

## 🔒 보안

### 🔐 보안 기능
- **인터셉터**: 로그인 상태 검증
- **세션 관리**: 안전한 세션 처리
- **SQL 인젝션 방지**: MyBatis 파라미터 바인딩
- **XSS 방지**: 입력 데이터 검증

---

## 🤝 기여하기

1. **Fork** the Project
2. **Create** your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** your Changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to the Branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

---

## 📝 라이선스

이 프로젝트는 **MIT 라이선스** 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

---

## 📞 문의

- **이메일**: contact@sol-food.com
- **이슈 트래커**: [GitHub Issues](https://github.com/your-username/sol-food/issues)
- **문서**: [Wiki](https://github.com/your-username/sol-food/wiki)

---

**🍽️ Sol-Food와 함께 맛있는 홍대 맛집을 발견하세요!**

[⬆️ 맨 위로](#-sol-food---홍대-맛집-리뷰-플랫폼)
