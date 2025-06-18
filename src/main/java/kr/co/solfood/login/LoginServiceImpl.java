package kr.co.solfood.login;

import properties.KakaoProperties;
import properties.ServerProperties;
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

import java.util.Objects;

@Service
public class LoginServiceImpl implements LoginService {

    @Autowired
    LoginMapper mapper;

    @Autowired
    KakaoProperties kakaoProperties;

    @Autowired
    ServerProperties serverProperties;

    @Override
    public LoginVO confirmAccessToken(String code) {
        // 1. 토큰 요청
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("grant_type", "authorization_code");
        body.add("client_id",kakaoProperties.getRestApiKey());
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
        System.out.println("카카오아이디"+kakaoId);
        vo.setUsersName("kakao/" + nickname);
        vo.setUsersNickname(nickname);
        vo.setAccessToken(accessToken);
        vo.setUsersProfile(profileImage);
        vo.setUsersEmail(email);
        vo.setUsersPoint(0);
        // 유저 나이 필요
         vo.setUsersAge(20);
        return vo;
    }

    @Override
    public void kakaoLogin(LoginVO vo){
        LoginVO login =  mapper.kakaoLogin(vo);
        System.out.println("찾음" + mapper.kakaoLogin(vo));
        if (login == null) {
            mapper.register(vo); // 기본 가입 처리
        }
    }

}
