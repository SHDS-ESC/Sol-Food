package kr.co.solfood.user.login;

import configuration.KakaoProperties;
import configuration.ServerProperties;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.util.List;
import java.util.Objects;

@Service
public class LoginServiceImpl implements LoginService {

    private final LoginMapper mapper;
    private final KakaoProperties kakaoProperties;
    private final ServerProperties serverProperties;

    LoginServiceImpl(LoginMapper mapper,KakaoProperties kakaoProperties,ServerProperties serverProperties) {
        this.mapper = mapper;
        this.kakaoProperties = kakaoProperties;
        this.serverProperties = serverProperties;
    }

    // 액세스 토큰 확인 후 VO 반환
    @Override
    public LoginVO confirmAccessToken(String code) {
        // 1. 토큰 요청
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("grant_type", "authorization_code");
        body.add("client_id", kakaoProperties.getRestApiKey());
        body.add("redirect_uri", "http://" + serverProperties.getIp() + ":" + serverProperties.getPort() + "/solfood/user/kakaoLogin");
        body.add("code", code);

        HttpEntity<MultiValueMap<String, String>> tokenRequest = new HttpEntity<>(body, headers);
        RestTemplate rt = new RestTemplate();

        ResponseEntity<String> tokenResponse = rt.exchange(
                "https://kauth.kakao.com/oauth/token",
                HttpMethod.POST,
                tokenRequest,
                String.class
        );

        // 2. access_token 파싱
        String tokenJson = tokenResponse.getBody();
        JSONObject tokenObj = new JSONObject(Objects.requireNonNull(tokenJson));
        String accessToken = tokenObj.getString("access_token");

        // 3. 사용자 정보 요청
        HttpHeaders profileHeaders = new HttpHeaders();
        profileHeaders.add("Authorization", "Bearer " + accessToken);
        profileHeaders.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        HttpEntity<String> profileRequest = new HttpEntity<>(profileHeaders);
        ResponseEntity<String> profileResponse = rt.exchange(
                "https://kapi.kakao.com/v2/user/me",
                HttpMethod.POST,
                profileRequest,
                String.class
        );

        // 4. 사용자 정보 파싱
        String profileJson = profileResponse.getBody();
        JSONObject profileObj = new JSONObject(Objects.requireNonNull(profileJson));

        long kakaoId = profileObj.getLong("id");

        if (mapper.kakaoLogin(kakaoId) != null) {
            return mapper.kakaoLogin(kakaoId);
        }

        JSONObject kakaoAccount = profileObj.getJSONObject("kakao_account");
        JSONObject kakaoProfile = kakaoAccount.getJSONObject("profile");

        String email = kakaoAccount.optString("email", "");
        String nickname = kakaoAccount
                .getJSONObject("profile")
                .optString("nickname", "");
        String profileImage = kakaoProfile.optString("profile_image_url", "");
        System.out.println("카카오" + profileImage);

        // 5. StudentVO 생성
        LoginVO vo = new LoginVO();
        // 회사, 부서 설정 필요
        vo.setCompanyId(0);
        vo.setDepartmentId(0);
        vo.setUsersKakaoId(kakaoId);
        vo.setUsersNickname(nickname);
        vo.setAccessToken(accessToken);
        vo.setUsersProfile(profileImage);
        vo.setUsersEmail(email);
        vo.setUsersPoint(0);
        vo.setUsersLoginType("kakao");
        return vo;
    }

    // 회원 가입 루트 로그인
    @Override
    public LoginVO register(LoginVO vo) {
        vo.setUsersCreatedAt(LocalDate.now().toString());
        vo.setUsersUpdatedAt(LocalDate.now().toString());
        int result = mapper.register(vo);
        if (result > 0) {
            return vo; // 등록 성공 시, 등록된 사용자 정보 반환
        }
        return null; // 등록 실패 시, null 반환
    }

    // 카카오 최초 로그인 확인 (소셜 로그인 전용)
    @Override
    public boolean confirmKakaoLoginWithFirst(LoginVO vo) {
        if (vo.getUsersCreatedAt() == null) {
            return true;
        }
        vo.setUsersUpdatedAt(LocalDate.now().toString());
        return false;
    }

    // 회사 리스트 가져오기
    @Override
    public List<CompanyVO> getCompanyList() {
        return mapper.selectAllCompanies();
    }

    // 회사 > 부서 리스트 가져오기
    @Override
    public List<DepartmentVO> getDepartmentsByCompanyId(int companyId) {
        return mapper.getDepartmentsByCompanyId(companyId);
    }

    // 로그인
    @Override
    public LoginVO nativeLogin(LoginRequest req) {
        return mapper.selectUser(req);
    }

}
