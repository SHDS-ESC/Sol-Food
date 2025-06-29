package kr.co.solfood.admin.login;

import config.MvcConfig;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.web.WebAppConfiguration;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.BDDMockito.given;

@ExtendWith(MockitoExtension.class)
@ContextConfiguration(classes = {MvcConfig.class})
@WebAppConfiguration
class AdminLoginServiceImplTest {

    @Mock
    private AdminLoginMapper adminMapper;

    @InjectMocks
    private AdminLoginServiceImpl adminHomeService;

    @Test
    @DisplayName("잘못된 비밀번호 로그인시도 시 예외 발생 테스트")
    void login() {
        // Given
        String password = "wrongPassword";

        AdminVO adminVO = new AdminVO();
        adminVO.setAdminPwd("correctPassword");

        // When
        given(adminMapper.login(password)).willReturn(null);

        // Then
        assertThrows(RuntimeException.class, () -> adminHomeService.login(password));
    }
}