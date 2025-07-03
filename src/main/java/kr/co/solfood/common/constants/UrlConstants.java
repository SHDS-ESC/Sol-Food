package kr.co.solfood.common.constants;

/**
 * 애플리케이션에서 사용되는 핵심 URL 경로를 관리하는 상수 클래스
 * 단순하고 실용적인 구조로 구성
 */
public final class UrlConstants {
    
    private UrlConstants() {
        throw new AssertionError("상수 클래스는 인스턴스화할 수 없습니다.");
    }
    
    /**
     * 공통 경로
     */
    public static final class Common {
        public static final String ROOT = "/";
        
        private Common() {}
    }
    
    /**
     * 사용자(User) 관련 경로
     */
    public static final class User {
        public static final String BASE = "/user";
        
        // 로그인 관련
        public static final String LOGIN_BASE = BASE + "/login";
        public static final String LOGIN_PAGE = LOGIN_BASE;
        public static final String LOGIN_EXTRA = LOGIN_BASE + "/extra";
        public static final String LOGIN_REGISTER = LOGIN_BASE + "/register";
        
        // 마이페이지 관련
        public static final String MYPAGE_BASE = BASE + "/mypage";
        public static final String MYPAGE_INFO = MYPAGE_BASE + "/info";
        
        // 가게 관련
        public static final String STORE_BASE = BASE + "/store";
        public static final String STORE_LIST = STORE_BASE + "/list";
        public static final String STORE_DETAIL = STORE_BASE + "/detail";
        
        // 리뷰 관련
        public static final String REVIEW_BASE = BASE + "/review";
        public static final String REVIEW_WRITE = REVIEW_BASE + "/write";
        public static final String REVIEW_EDIT = REVIEW_BASE + "/edit";
        
        // 찜 관련
        public static final String LIKE_BASE = BASE + "/like";
        public static final String LIKE_ADD = LIKE_BASE + "/add";
        public static final String LIKE_CANCEL = LIKE_BASE + "/cancel";
        
        // 장바구니 관련
        public static final String CART_BASE = BASE + "/cart";
        public static final String CART_ADD = CART_BASE + "/add";
        public static final String CART_UPDATE = CART_BASE + "/update";
        public static final String CART_REMOVE = CART_BASE + "/remove";
        public static final String CART_CLEAR = CART_BASE + "/clear";
        public static final String CART_COUNT = CART_BASE + "/count";
        public static final String CART_PAYMENT_METHOD = CART_BASE + "/payment-method";
        public static final String CART_INVITE_FRIENDS = CART_BASE + "/invite-friends";
        public static final String CART_WAITING_APPROVAL = CART_BASE + "/waiting-approval";
        public static final String CART_USERS_DEPARTMENT = CART_BASE + "/users/department";
        
        private User() {}
    }
    
    /**
     * 관리자(Admin) 관련 경로
     */
    public static final class Admin {
        public static final String BASE = "/admin";
        public static final String LOGIN = BASE + "/login";
        public static final String KAKAO_LOGIN = BASE + "/kakaoLogin";
        public static final String HOME = BASE + "/home";
        
        private Admin() {}
    }
    
    /**
     * 점주(Owner) 관련 경로
     */
    public static final class Owner {
        public static final String BASE = "/owner";
        public static final String LOGIN = BASE + "/login";
        public static final String KAKAO_LOGIN = BASE + "/kakaoLogin";
        public static final String INDEX = BASE + "/index";
        
        private Owner() {}
    }
    
    /**
     * API 관련 경로
     */
    public static final class Api {
        public static final String FILE_BASE = "/api/file";
        
        private Api() {}
    }
    
    /**
     * JSP 뷰 경로
     */
    public static final class View {
        public static final String USER_MYPAGE = "user/login/mypage";
        public static final String USER_LOGIN_INFO = "user/login/info";
        public static final String USER_REVIEW_WRITE = "user/review/write";
        public static final String USER_CART = "user/cart/cart";
        public static final String USER_CART_PAYMENT_METHOD = "user/cart/payment-method";
        public static final String USER_CART_INVITE_FRIENDS = "user/cart/invite-friends";
        public static final String USER_CART_WAITING_APPROVAL = "user/cart/waiting-approval";
        
        private View() {}
    }
    
    /**
     * 세션 속성 키
     */
    public static final class Session {
        public static final String USER_LOGIN_SESSION = "userLoginSession";
        public static final String ADMIN_LOGIN_SESSION = "adminLoginSession";
        public static final String OWNER_LOGIN_SESSION = "ownerLoginSession";
        public static final String USER_CART = "userCart";
        
        private Session() {}
    }
    
    /**
     * 파라미터 이름
     */
    public static final class Param {
        public static final String STORE_ID = "storeId";
        public static final String REVIEW_ID = "reviewId";
        public static final String MENU_ID = "menuId";
        public static final String QUANTITY = "quantity";
        public static final String DEPARTMENT_ID = "departmentId";
        public static final String COMPANY_ID = "companyId";
        public static final String CURRENT_USER_ID = "currentUserId";
        
        private Param() {}
    }
    
    /**
     * 모델 속성 키
     */
    public static final class Model {
        public static final String KAKAO_JS_KEY = "kakaoJsKey";
        public static final String SUCCESS = "success";
        public static final String ERROR = "error";
        public static final String CART = "cart";
        public static final String COMPANY_USERS = "companyUsers";
        public static final String CURRENT_USER = "currentUser";
        
        private Model() {}
    }
    
    /**
     * 리다이렉트 경로
     */
    public static final class Redirect {
        public static final String TO_USER_LOGIN = "redirect:" + User.LOGIN_PAGE;
        public static final String TO_USER_REGISTER = "redirect:" + User.LOGIN_REGISTER;
        public static final String TO_USER_MYPAGE = "redirect:" + User.MYPAGE_BASE;
        public static final String TO_ADMIN_LOGIN = "redirect:" + Admin.LOGIN;
        public static final String TO_OWNER_LOGIN = "redirect:" + Owner.LOGIN;
        public static final String TO_ROOT = "redirect:" + Common.ROOT;
        public static final String TO_USER_CART = "redirect:" + User.CART_BASE;
        
        private Redirect() {}
    }
} 