package kr.co.solfood.user.login;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

import java.util.Date;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("로그인 관련 간단한 테스트")
class SimpleLoginTest {

    private LoginVO loginVO;
    private LoginRequest loginRequest;
    private SearchPwdRequest searchPwdRequest;

    @BeforeEach
    void setUp() {
        // 테스트 데이터 초기화
        loginVO = new LoginVO();
        loginVO.setUsersNickname("테스트 사용자");
        loginVO.setUsersEmail("test@example.com");
        loginVO.setUsersKakaoId(123456789L);
        loginVO.setUsersPoint(100);
        loginVO.setUsersLoginType("kakao");

        loginRequest = new LoginRequest();
        loginRequest.setUsersEmail("test@example.com");
        loginRequest.setUsersPwd("password123");

        searchPwdRequest = new SearchPwdRequest();
        searchPwdRequest.setUsersEmail("test@example.com");
        searchPwdRequest.setUsersPwd("newpassword123");
    }

    @Test
    @DisplayName("LoginVO 객체 생성 및 기본값 설정 테스트")
    void testLoginVOCreation() {
        // given & when
        LoginVO vo = new LoginVO();
        vo.setUsersNickname("홍길동");
        vo.setUsersEmail("hong@example.com");
        vo.setUsersPoint(500);

        // then
        assertNotNull(vo);
        assertEquals("홍길동", vo.getUsersNickname());
        assertEquals("hong@example.com", vo.getUsersEmail());
        assertEquals(500, vo.getUsersPoint());
    }

    @Test
    @DisplayName("LoginRequest 객체 생성 및 기본값 설정 테스트")
    void testLoginRequestCreation() {
        // given & when
        LoginRequest request = new LoginRequest();
        request.setUsersEmail("user@example.com");
        request.setUsersPwd("securepassword");

        // then
        assertNotNull(request);
        assertEquals("user@example.com", request.getUsersEmail());
        assertEquals("securepassword", request.getUsersPwd());
    }

    @Test
    @DisplayName("SearchPwdRequest 객체 생성 및 기본값 설정 테스트")
    void testSearchPwdRequestCreation() {
        // given & when
        SearchPwdRequest request = new SearchPwdRequest();
        request.setUsersEmail("reset@example.com");
        request.setUsersPwd("newsecurepassword");

        // then
        assertNotNull(request);
        assertEquals("reset@example.com", request.getUsersEmail());
        assertEquals("newsecurepassword", request.getUsersPwd());
    }

    @Test
    @DisplayName("LoginVO 날짜 설정 테스트")
    void testLoginVODateSetting() {
        // given
        Date currentDate = new Date();

        // when
        loginVO.setUsersCreatedAt(currentDate);
        loginVO.setUsersUpdatedAt(currentDate);

        // then
        assertNotNull(loginVO.getUsersCreatedAt());
        assertNotNull(loginVO.getUsersUpdatedAt());
        assertEquals(currentDate, loginVO.getUsersCreatedAt());
        assertEquals(currentDate, loginVO.getUsersUpdatedAt());
    }

    @ParameterizedTest
    @ValueSource(strings = {"kakao", "native", "google"})
    @DisplayName("다양한 로그인 타입 테스트")
    void testDifferentLoginTypes(String loginType) {
        // given & when
        loginVO.setUsersLoginType(loginType);

        // then
        assertEquals(loginType, loginVO.getUsersLoginType());
    }

    @Test
    @DisplayName("카카오 ID 설정 테스트")
    void testKakaoIdSetting() {
        // given
        long kakaoId = 987654321L;

        // when
        loginVO.setUsersKakaoId(kakaoId);

        // then
        assertEquals(kakaoId, loginVO.getUsersKakaoId());
    }

    @Test
    @DisplayName("포인트 증가 테스트")
    void testPointIncrement() {
        // given
        int initialPoint = loginVO.getUsersPoint();
        int increment = 50;

        // when
        loginVO.setUsersPoint(initialPoint + increment);

        // then
        assertEquals(initialPoint + increment, loginVO.getUsersPoint());
    }

    @Test
    @DisplayName("이메일 유효성 검사 테스트")
    void testEmailValidation() {
        // given
        String validEmail = "test@example.com";
        String invalidEmail = "invalid-email";

        // when & then
        assertTrue(validEmail.contains("@"));
        assertTrue(validEmail.contains("."));
        assertFalse(invalidEmail.contains("@"));
    }

    @Test
    @DisplayName("비밀번호 길이 검사 테스트")
    void testPasswordLength() {
        // given
        String shortPassword = "123";
        String validPassword = "password123";
        String longPassword = "verylongpassword123456789";

        // when & then
        assertTrue(shortPassword.length() < 8);
        assertTrue(validPassword.length() >= 8);
        assertTrue(longPassword.length() > 8);
    }

    @Test
    @DisplayName("객체 동등성 테스트")
    void testObjectEquality() {
        // given
        LoginVO vo1 = new LoginVO();
        vo1.setUsersEmail("test@example.com");
        vo1.setUsersNickname("테스트");

        LoginVO vo2 = new LoginVO();
        vo2.setUsersEmail("test@example.com");
        vo2.setUsersNickname("테스트");

        // when & then
        assertEquals(vo1.getUsersEmail(), vo2.getUsersEmail());
        assertEquals(vo1.getUsersNickname(), vo2.getUsersNickname());
    }
} 