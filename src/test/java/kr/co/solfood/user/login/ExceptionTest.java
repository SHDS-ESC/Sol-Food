package kr.co.solfood.user.login;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.function.Executable;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("예외 상황 테스트")
class ExceptionTest {

    @Test
    @DisplayName("null 값 처리 테스트")
    void testNullHandling() {
        // given
        UserVO userVO = new UserVO();

        // when & then
        assertDoesNotThrow(() -> {
            userVO.setUsersNickname(null);
            userVO.setUsersEmail(null);
        });

        assertNull(userVO.getUsersNickname());
        assertNull(userVO.getUsersEmail());
    }

    @Test
    @DisplayName("빈 문자열 처리 테스트")
    void testEmptyStringHandling() {
        // given
        UserVO userVO = new UserVO();

        // when
        userVO.setUsersNickname("");
        userVO.setUsersEmail("");

        // then
        assertEquals("", userVO.getUsersNickname());
        assertEquals("", userVO.getUsersEmail());
    }

    @Test
    @DisplayName("음수 포인트 처리 테스트")
    void testNegativePointHandling() {
        // given
        UserVO userVO = new UserVO();

        // when
        userVO.setUsersPoint(-100);

        // then
        assertEquals(-100, userVO.getUsersPoint());
    }

    @Test
    @DisplayName("매우 큰 포인트 값 처리 테스트")
    void testLargePointHandling() {
        // given
        UserVO userVO = new UserVO();

        // when
        userVO.setUsersPoint(Integer.MAX_VALUE);

        // then
        assertEquals(Integer.MAX_VALUE, userVO.getUsersPoint());
    }

    @Test
    @DisplayName("잘못된 이메일 형식 테스트")
    void testInvalidEmailFormat() {
        // given
        String[] invalidEmails = {
            "invalid-email",
            "@example.com",
            "test@",
            "test.example.com",
            "",
            null
        };

        // when & then
        for (String email : invalidEmails) {
            if (email != null) {
                assertFalse(isValidEmailFormat(email), 
                    "이메일 형식이 잘못되었습니다: " + email);
            }
        }
    }

    @Test
    @DisplayName("유효한 이메일 형식 테스트")
    void testValidEmailFormat() {
        // given
        String[] validEmails = {
            "test@example.com",
            "user.name@domain.co.kr",
            "user+tag@example.org",
            "123@numbers.com"
        };

        // when & then
        for (String email : validEmails) {
            assertTrue(isValidEmailFormat(email), 
                "이메일 형식이 유효합니다: " + email);
        }
    }

    @Test
    @DisplayName("비밀번호 길이 검증 테스트")
    void testPasswordLengthValidation() {
        // given
        String shortPassword = "123";
        String validPassword = "password123";
        String longPassword = "verylongpassword123456789";

        // when & then
        assertFalse(isValidPasswordLength(shortPassword));
        assertTrue(isValidPasswordLength(validPassword));
        assertTrue(isValidPasswordLength(longPassword));
    }

    @Test
    @DisplayName("로그인 타입 유효성 검사 테스트")
    void testLoginTypeValidation() {
        // given
        String[] validLoginTypes = {"kakao", "native", "google"};
        String[] invalidLoginTypes = {"", null, "invalid"};

        // when & then
        for (String loginType : validLoginTypes) {
            assertTrue(isValidLoginType(loginType), 
                "유효한 로그인 타입입니다: " + loginType);
        }

        for (String loginType : invalidLoginTypes) {
            if (loginType != null) {
                assertFalse(isValidLoginType(loginType), 
                    "잘못된 로그인 타입입니다: " + loginType);
            }
        }
    }

    @Test
    @DisplayName("객체 생성 시 기본값 테스트")
    void testDefaultValues() {
        // given & when
        UserVO userVO = new UserVO();
        LoginRequest loginRequest = new LoginRequest();
        SearchPwdRequest searchPwdRequest = new SearchPwdRequest();

        // then
        // LoginVO의 기본값 확인
        assertEquals(0, userVO.getUsersPoint());
        assertNull(userVO.getUsersNickname());
        assertNull(userVO.getUsersEmail());

        // LoginRequest의 기본값 확인
        assertNull(loginRequest.getUsersEmail());
        assertNull(loginRequest.getUsersPwd());

        // SearchPwdRequest의 기본값 확인
        assertNull(searchPwdRequest.getUsersEmail());
        assertNull(searchPwdRequest.getUsersPwd());
    }

    @Test
    @DisplayName("날짜 설정 테스트")
    void testDateSetting() {
        // given
        UserVO userVO = new UserVO();

        // when
        userVO.setUsersCreatedAt(null);
        userVO.setUsersUpdatedAt(null);

        // then
        assertNull(userVO.getUsersCreatedAt());
        assertNull(userVO.getUsersUpdatedAt());
    }

    // 헬퍼 메서드들
    private boolean isValidEmailFormat(String email) {
        if (email == null || email.isEmpty()) {
            return false;
        }
        return email.contains("@") && email.contains(".") && 
               email.indexOf("@") < email.lastIndexOf(".");
    }

    private boolean isValidPasswordLength(String password) {
        return password != null && password.length() >= 8;
    }

    private boolean isValidLoginType(String loginType) {
        if (loginType == null || loginType.isEmpty()) {
            return false;
        }
        return loginType.equals("kakao") || 
               loginType.equals("native") || 
               loginType.equals("google");
    }
} 