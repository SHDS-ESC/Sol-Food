package kr.co.solfood.user.login;

import org.springframework.web.servlet.HandlerInterceptor;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;

public class UserLoginInterceptor implements HandlerInterceptor {
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 로그인 체크
        HttpSession session = request.getSession();
        LoginVO loginType = (LoginVO) session.getAttribute("userLoginSession");
        if (loginType == null) {
            // 미 로그인 상태
            response.setContentType("text/html;charset=utf-8");
            PrintWriter out = response.getWriter();
            out.println("<script>");
            out.println("alert('로그인 후 접근 가능합니다.');");
            out.println("location.href = '/solfood/user/login';");
            out.println("</script>");
            return false; // 가지 못함
        }
        return true;
    }
}
