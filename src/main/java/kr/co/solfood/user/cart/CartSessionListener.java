package kr.co.solfood.user.cart;

import lombok.extern.slf4j.Slf4j;
import kr.co.solfood.util.ApplicationContextProvider;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

@Slf4j
public class CartSessionListener implements HttpSessionListener {

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        
        // 세션에서 사용자 ID 가져오기
        Object userObj = session.getAttribute("userLoginSession");
        if (userObj != null) {
            try {
                // UserVO에서 usersId 추출 (리플렉션 사용)
                java.lang.reflect.Method getUsersIdMethod = userObj.getClass().getMethod("getUsersId");
                Long usersId = (Long) getUsersIdMethod.invoke(userObj);
                
                if (usersId != null) {
                    // ApplicationContext에서 CartController 빈 가져오기
                    CartController cartController = ApplicationContextProvider.getBean(CartController.class);
                    cartController.cleanupOnSessionExpire(usersId.longValue());
                    log.info("세션 만료로 인한 Map 정리 완료: 사용자 {}", usersId);
                }
            } catch (Exception e) {
                log.warn("세션 만료 시 Map 정리 중 오류: {}", e.getMessage());
            }
        }
    }
} 