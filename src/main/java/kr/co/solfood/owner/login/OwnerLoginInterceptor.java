package kr.co.solfood.owner.login;

import kr.co.solfood.common.constants.UrlConstants;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;

public class OwnerLoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        if (session.getAttribute(UrlConstants.Session.OWNER_LOGIN_SESSION) == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("alert('점주 로그인이 필요합니다.');");
            
            // Context Path를 동적으로 가져오기
            String contextPath = request.getContextPath();
            out.println("location.href = '" + contextPath + "/owner/login';");
            out.flush();
            return false;
        }
        return true;
    }
}
