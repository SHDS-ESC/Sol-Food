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
        HttpSession session = request.getSession();
        UserVO user = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        String contextPath = request.getContextPath();

        // AJAX/JSON 요청 감지
        String requestedWith = request.getHeader("X-Requested-With");
        String accept = request.getHeader("Accept");
        boolean isAjax = "XMLHttpRequest".equals(requestedWith) || (accept != null && accept.contains("application/json"));

        if (user == null) {
            if (isAjax) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"code\":\"UNAUTHORIZED\",\"message\":\"로그인이 필요합니다.\"}");
            } else {
                response.setContentType("text/html; charset=UTF-8");
                PrintWriter out = response.getWriter();
                out.println("<script>");
                out.println("alert('로그인이 필요합니다.');");
                out.println("location.href = '" + contextPath + "/user/login';");
                out.println("</script>");
                out.flush();
            }
            return false;
        } else if (UserStatus.INACTIVE.getStatus().equals(user.getUsersStatus())) {
            if (isAjax) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"code\":\"INACTIVE\",\"message\":\"" + user.getUsersRejectedReason() + "\"}");
            } else {
                response.setContentType("text/html; charset=UTF-8");
                PrintWriter out = response.getWriter();
                out.println("<script>");
                out.print("alert('");
                out.print(user.getUsersRejectedReason());
                out.print("');");
                out.println("location.href = '" + contextPath + "/user/login';");
                out.println("</script>");
                out.flush();
            }
            return false;
        }
        return true;
    }
}
