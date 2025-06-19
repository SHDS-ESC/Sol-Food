package kr.co.solfood.user.login;

import configuration.KakaoProperties;
import configuration.ServerProperties;
import org.json.JSONObject;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.Objects;

@Service
public class LoginServiceImpl implements LoginService {

    private final LoginMapper mapper;
    private final KakaoProperties kakaoProperties;
    private final ServerProperties serverProperties;

    LoginServiceImpl(LoginMapper mapper, KakaoProperties kakaoProperties, ServerProperties serverProperties) {
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

        String email = kakaoAccount.optString("email", "");
        JSONObject profile;
        // 기본 프로필 이미지와 닉네임 설정
        String profileImage = "https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMyAg/MDAxNjA0MjI5NDA4NDMy.5zGHwAo_UtaQFX8Hd7zrDi1WiV5KrDsPHcRzu3e6b8Eg.IlkR3QN__c3o7Qe9z5_xYyCyr2vcx7L_W1arNFgwAJwg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%8C%8C%EC%8A%A4%ED%85%94.jpg?type=w800";
        int num = (int) (Math.random() * 99) + 1; // 랜덤 숫자 생성
        String nickname = "익명의 사용자" + num; // 기본 닉네임 설정

        // "profile" 키가 존재하는지 확인하고 처리
        if (kakaoAccount.has("profile")) {
            profile = kakaoAccount.getJSONObject("profile");
            profileImage = profile.optString("profile_image_url", "");
            nickname = profile.optString("nickname", "");
        }

        // 5. LoginVO 생성
        LoginVO vo = new LoginVO();
        vo.setUsersNickname(nickname);
        vo.setCompanyId(0);
        vo.setDepartmentId(0);
        vo.setUsersKakaoId(kakaoId);
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
        vo.setUsersCreatedAt(new Date());
        vo.setUsersUpdatedAt(new Date());
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
        vo.setUsersUpdatedAt(new Date());
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

    // 비밀번호 찾기
    @Override
    public LoginVO searchPwd(SearchPwdRequest req) {
        return mapper.searchPwd(req);
    }

    // 비밀번호 찾기 > 새로운 비밀번호 저장
    @Override
    public void setNewPwd(SearchPwdRequest req) {
        mapper.setNewPwd(req);
    }


}
