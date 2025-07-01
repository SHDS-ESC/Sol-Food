package kr.co.solfood.user.login;

import kr.co.solfood.common.constants.UrlConstants;
import org.springframework.web.servlet.HandlerInterceptor;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;

public class UserLoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 로그인 체크
        HttpSession session = request.getSession();
        if (session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION) == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("alert('로그인이 필요합니다.');");
            
            // Context Path를 동적으로 가져오기
            String contextPath = request.getContextPath();
            out.println("location.href = '" + contextPath + "/user/login';");
            out.flush();
            return false;
        }
        return true;
    }
}
