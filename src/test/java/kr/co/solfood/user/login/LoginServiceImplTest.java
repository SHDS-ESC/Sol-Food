package kr.co.solfood.user.login;

import configuration.KakaoProperties;
import configuration.ServerProperties;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.Date;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class LoginServiceImplTest {

    @Mock
    private LoginMapper loginMapper;

    @Mock
    private KakaoProperties kakaoProperties;

    @Mock
    private ServerProperties serverProperties;

    @InjectMocks
    private LoginServiceImpl loginService;

    private LoginVO testLoginVO;
    private LoginRequest testLoginRequest;
    private SearchPwdRequest testSearchPwdRequest;
    private CompanyVO testCompanyVO;
    private DepartmentVO testDepartmentVO;

    @BeforeEach
    void setUp() {
        // 테스트용 LoginVO 설정
        testLoginVO = new LoginVO();
        testLoginVO.setUsersNickname("테스트 사용자");
        testLoginVO.setUsersEmail("test@example.com");
        testLoginVO.setUsersKakaoId(123456789L);
        testLoginVO.setUsersPoint(100);
        testLoginVO.setUsersLoginType("kakao");

        // 테스트용 LoginRequest 설정
        testLoginRequest = new LoginRequest();
        testLoginRequest.setUsersEmail("test@example.com");
        testLoginRequest.setUsersPwd("password123");

        // 테스트용 SearchPwdRequest 설정
        testSearchPwdRequest = new SearchPwdRequest();
        testSearchPwdRequest.setUsersEmail("test@example.com");
        testSearchPwdRequest.setUsersPwd("newpassword123");

        // 테스트용 CompanyVO 설정
        testCompanyVO = new CompanyVO();
        testCompanyVO.setCompanyId(1);
        testCompanyVO.setCompanyName("테스트 회사");

        // 테스트용 DepartmentVO 설정
        testDepartmentVO = new DepartmentVO();
        testDepartmentVO.setDepartmentId(1);
        testDepartmentVO.setDepartmentName("테스트 부서");
        testDepartmentVO.setCompanyId(1);
    }

    @Test
    @DisplayName("회원 가입 테스트 - 성공 케이스")
    void register_Success() {
        // given
        when(loginMapper.register(any(LoginVO.class))).thenReturn(1);

        // when
        LoginVO result = loginService.register(testLoginVO);

        // then
        assertNotNull(result);
        assertEquals("테스트 사용자", result.getUsersNickname());
        assertEquals("test@example.com", result.getUsersEmail());
        assertNotNull(result.getUsersCreatedAt());
        assertNotNull(result.getUsersUpdatedAt());
    }

    @Test
    @DisplayName("회원 가입 테스트 - 실패 케이스")
    void register_Failure() {
        // given
        when(loginMapper.register(any(LoginVO.class))).thenReturn(0);

        // when
        LoginVO result = loginService.register(testLoginVO);

        // then
        assertNull(result);
    }

    @Test
    @DisplayName("카카오 최초 로그인 확인 테스트 - 최초 로그인")
    void confirmKakaoLoginWithFirst_FirstLogin() {
        // given
        testLoginVO.setUsersCreatedAt(null);

        // when
        boolean result = loginService.confirmKakaoLoginWithFirst(testLoginVO);

        // then
        assertTrue(result);
        assertNull(testLoginVO.getUsersUpdatedAt());
    }

    @Test
    @DisplayName("카카오 최초 로그인 확인 테스트 - 기존 사용자")
    void confirmKakaoLoginWithFirst_ExistingUser() {
        // given
        testLoginVO.setUsersCreatedAt(new Date());

        // when
        boolean result = loginService.confirmKakaoLoginWithFirst(testLoginVO);

        // then
        assertFalse(result);
        assertNotNull(testLoginVO.getUsersUpdatedAt());
    }

    @Test
    @DisplayName("회사 리스트 조회 테스트")
    void getCompanyList_Success() {
        // given
        List<CompanyVO> expectedCompanies = Arrays.asList(testCompanyVO);
        when(loginMapper.selectAllCompanies()).thenReturn(expectedCompanies);

        // when
        List<CompanyVO> result = loginService.getCompanyList();

        // then
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals("테스트 회사", result.get(0).getCompanyName());
    }

    @Test
    @DisplayName("부서 리스트 조회 테스트")
    void getDepartmentsByCompanyId_Success() {
        // given
        List<DepartmentVO> expectedDepartments = Arrays.asList(testDepartmentVO);
        when(loginMapper.getDepartmentsByCompanyId(anyInt())).thenReturn(expectedDepartments);

        // when
        List<DepartmentVO> result = loginService.getDepartmentsByCompanyId(1);

        // then
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals("테스트 부서", result.get(0).getDepartmentName());
        assertEquals(1, result.get(0).getCompanyId());
    }

    @Test
    @DisplayName("자체 로그인 테스트")
    void nativeLogin_Success() {
        // given
        when(loginMapper.selectUser(any(LoginRequest.class))).thenReturn(testLoginVO);

        // when
        LoginVO result = loginService.nativeLogin(testLoginRequest);

        // then
        assertNotNull(result);
        assertEquals("테스트 사용자", result.getUsersNickname());
        assertEquals("test@example.com", result.getUsersEmail());
    }

    @Test
    @DisplayName("비밀번호 찾기 테스트")
    void searchPwd_Success() {
        // given
        when(loginMapper.searchPwd(any(SearchPwdRequest.class))).thenReturn(testLoginVO);

        // when
        LoginVO result = loginService.searchPwd(testSearchPwdRequest);

        // then
        assertNotNull(result);
        assertEquals("test@example.com", result.getUsersEmail());
    }

    @Test
    @DisplayName("새 비밀번호 설정 테스트")
    void setNewPwd_Success() {
        // given
        // Mockito의 void 메서드는 기본적으로 아무것도 하지 않음

        // when & then
        assertDoesNotThrow(() -> loginService.setNewPwd(testSearchPwdRequest));
    }
} 