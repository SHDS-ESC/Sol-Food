# JUnit 5 테스트 가이드

## 생성된 테스트 클래스

### 1. SimpleLoginTest.java
- **목적**: Mockito 없이 JUnit 5만 사용하는 기본적인 테스트
- **테스트 내용**:
  - LoginVO, LoginRequest, SearchPwdRequest 객체 생성 및 기본값 설정
  - 날짜 설정 테스트
  - 다양한 로그인 타입 테스트 (ParameterizedTest 사용)
  - 카카오 ID 설정 테스트
  - 포인트 증가 테스트
  - 이메일 유효성 검사
  - 비밀번호 길이 검사
  - 객체 동등성 테스트

### 2. LoginServiceImplTest.java
- **목적**: Mockito를 사용한 서비스 계층 테스트
- **테스트 내용**:
  - 회원 가입 성공/실패 케이스
  - 카카오 최초 로그인 확인
  - 회사/부서 리스트 조회
  - 자체 로그인
  - 비밀번호 찾기 및 새 비밀번호 설정

## 테스트 실행 방법

### IntelliJ IDEA에서 실행
1. 테스트 클래스 파일을 열기
2. 클래스명 옆의 실행 버튼(▶) 클릭
3. 또는 각 테스트 메서드 옆의 실행 버튼 클릭

### Eclipse에서 실행
1. 테스트 클래스에서 우클릭
2. "Run As" → "JUnit Test" 선택

### Maven 명령어로 실행 (Maven 설치 필요)
```bash
# 모든 테스트 실행
mvn test

# 특정 테스트 클래스만 실행
mvn test -Dtest=SimpleLoginTest

# 특정 테스트 메서드만 실행
mvn test -Dtest=SimpleLoginTest#testLoginVOCreation
```

## JUnit 5 주요 어노테이션

- `@Test`: 테스트 메서드 표시
- `@DisplayName`: 테스트 이름을 한글로 표시
- `@BeforeEach`: 각 테스트 메서드 실행 전 실행
- `@ParameterizedTest`: 매개변수를 사용한 테스트
- `@ValueSource`: 매개변수 값 제공
- `@ExtendWith(MockitoExtension.class)`: Mockito 확장 사용

## Mockito 주요 어노테이션

- `@Mock`: Mock 객체 생성
- `@InjectMocks`: Mock 객체를 주입받을 대상
- `when().thenReturn()`: Mock 객체의 동작 정의

## 테스트 작성 패턴

### Given-When-Then 패턴
```java
@Test
void testExample() {
    // Given: 테스트 준비
    String input = "test";
    
    // When: 테스트 실행
    String result = someMethod(input);
    
    // Then: 결과 검증
    assertEquals("expected", result);
}
```

## 추가 테스트 작성 팁

1. **테스트 이름**: `@DisplayName`을 사용해 한글로 명확하게 작성
2. **테스트 격리**: 각 테스트는 독립적으로 실행될 수 있어야 함
3. **Mock 사용**: 외부 의존성은 Mock으로 대체
4. **예외 테스트**: `assertThrows()`를 사용해 예외 상황도 테스트
5. **경계값 테스트**: 최소값, 최대값, null 값 등 경계 상황 테스트 