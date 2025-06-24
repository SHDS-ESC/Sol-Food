package kr.co.solfood.admin.login;

import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;

public class OwnerLoginInterceptor implements HandlerInterceptor {
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 로그인 체크
        HttpSession session = request.getSession();
        OwnerVO vo = (OwnerVO) session.getAttribute("owner");
        if (vo == null) {
            // 미 로그인 상태
            response.setContentType("text/html;charset=utf-8");
            PrintWriter out = response.getWriter();
            out.println("<script>");
            out.println("alert('로그인 후 이용 가능합니다.');");
            out.println("location.href = '/solfood/owner/login';");
            out.println("</script>");
            return false; // 가지 못함
        }
        // 로그인 된 상태
        return true; // 이 값이 false면 못 감 (흰 화면)
    }
}
