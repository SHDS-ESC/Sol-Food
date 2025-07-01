package kr.co.solfood.user.cart;

import kr.co.solfood.common.constants.UrlConstants;
import kr.co.solfood.user.login.LoginService;
import kr.co.solfood.user.login.UserVO;
import kr.co.solfood.util.PageDTO;
import kr.co.solfood.util.PageMaker;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping(UrlConstants.User.CART_BASE)
public class CartController {
    
    @Autowired
    private CartService cartService;
    
    @Autowired
    private LoginService loginService;

    /**
     * 사용자 로그인 체크 공통 메서드
     */
    private UserVO validateUserLogin(HttpSession session) {
        return (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
    }

    /**
     * 로그인 실패 응답 생성 공통 메서드
     */
    private Map<String, Object> createLoginRequiredResponse() {
        Map<String, Object> response = new HashMap<>();
        response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
        response.put(CartConstants.JSON_MESSAGE, CartConstants.MSG_LOGIN_REQUIRED);
        return response;
    }

    /**
     * 장바구니 페이지
     */
    @GetMapping
    public String cartPage(HttpSession session, Model model) {
        UserVO user = validateUserLogin(session);
        if (user == null) {
            return UrlConstants.Redirect.TO_USER_LOGIN;
        }
        
        CartVO cart = cartService.getCart(session);
        model.addAttribute(UrlConstants.Model.CART, cart);
        
        return UrlConstants.View.USER_CART;
    }
    
    /**
     * 결제 방식 선택 페이지
     */
    @GetMapping("/payment-method")
    public String paymentMethodPage(HttpSession session, Model model) {
        UserVO user = validateUserLogin(session);
        if (user == null) {
            return UrlConstants.Redirect.TO_USER_LOGIN;
        }
        
        CartVO cart = cartService.getCart(session);
        if (cart == null || cart.isEmpty()) {
            return UrlConstants.Redirect.TO_USER_CART;
        }
        
        model.addAttribute(UrlConstants.Model.CART, cart);
        return UrlConstants.View.USER_CART_PAYMENT_METHOD;
    }
    
    /**
     * 친구 초대 페이지
     */
    @GetMapping("/invite-friends")
    public String inviteFriendsPage(
            @RequestParam(value = CartConstants.PARAM_PAGE, defaultValue = "1") int page,
            @RequestParam(value = CartConstants.PARAM_SIZE, defaultValue = "10") int size,
            @RequestParam(value = CartConstants.PARAM_SEARCH, required = false) String search,
            @RequestParam(value = "filter", defaultValue = "all") String filter,
            HttpSession session, Model model) {
        
        UserVO user = validateUserLogin(session);
        if (user == null) {
            return UrlConstants.Redirect.TO_USER_LOGIN;
        }
        
        CartVO cart = cartService.getCart(session);
        if (cart == null || cart.isEmpty()) {
            return UrlConstants.Redirect.TO_USER_CART;
        }
        
        // 페이징 설정
        PageDTO pageDTO = new PageDTO();
        pageDTO.setCurrentPage(page);
        pageDTO.setPageSize(size);
        
        log.debug("친구 초대 페이지 - 페이지: {}, 크기: {}, 필터: " + filter, page, size);
        if (search != null) {
            log.debug("검색어: {}", search);
        }
        
        // 필터에 따라 다른 사용자 목록 조회
        List<UserVO> filteredUsers;
        
        switch (filter) {
            case "department":
                // 부서별 필터링
                filteredUsers = loginService.getUsersByDepartmentIdExcludingCurrentUser(
                        user.getDepartmentId(), user.getUsersId());
                break;
            case "all":
            default:
                // 전체 (회사 전체)
                filteredUsers = loginService.getUsersByCompanyIdExcludingCurrentUser(
                        user.getCompanyId(), user.getUsersId());
                break;
        }
        
        // 검색어가 있으면 추가 필터링
        if (search != null && !search.trim().isEmpty()) {
            filteredUsers = filteredUsers.stream()
                    .filter(u -> u.getUsersName().contains(search.trim()))
                    .collect(java.util.stream.Collectors.toList());
        }
        
        long totalCount = filteredUsers.size();
        
        // 페이징 처리 (메모리에서)
        int offset = pageDTO.getOffset();
        int endIndex = Math.min(offset + pageDTO.getPageSize(), filteredUsers.size());
        List<UserVO> pagedUsers = filteredUsers.subList(offset, endIndex);
        
        // PageMaker 생성
        PageMaker<UserVO> pageMaker = new PageMaker<>(pagedUsers, totalCount, size, page);
        
        model.addAttribute(UrlConstants.Model.CART, cart);
        model.addAttribute(UrlConstants.Model.COMPANY_USERS, filteredUsers);
        model.addAttribute(UrlConstants.Model.CURRENT_USER, user);
        model.addAttribute("pageMaker", pageMaker);
        model.addAttribute("currentPage", page);
        model.addAttribute(CartConstants.PARAM_SEARCH, search);
        model.addAttribute("filter", filter);
        model.addAttribute("totalCount", totalCount);
        
        return UrlConstants.View.USER_CART_INVITE_FRIENDS;
    }
    
    /**
     * 선택된 친구 ID를 받아서 세션에 저장하는 API (ID만 저장)
     */
    @PostMapping("/save-selected-friend-ids")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveSelectedFriendIds(
            @RequestBody List<String> selectedFriendIds,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO user = validateUserLogin(session);
            if (user == null) {
                return ResponseEntity.ok(createLoginRequiredResponse());
            }
            
            log.debug("친구 ID 처리 - 전달받은 친구 수: {}", 
                    selectedFriendIds != null ? selectedFriendIds.size() : 0);
            
            // 세션에 친구 ID만 저장 (간단하고 안전)
            session.setAttribute("selectedFriendIds", selectedFriendIds != null ? selectedFriendIds : new ArrayList<>());
            
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
            response.put(CartConstants.JSON_MESSAGE, "친구 정보가 저장되었습니다.");
            response.put("friendCount", selectedFriendIds != null ? selectedFriendIds.size() : 0);
            
        } catch (Exception e) {
            log.error("친구 정보 저장 오류", e);
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
            response.put(CartConstants.JSON_MESSAGE, "친구 정보 저장에 실패했습니다.");
        }
        
        return ResponseEntity.ok(response);
    }

    /**
     * 수락 대기 페이지
     */
    @GetMapping("/waiting-approval")
    public String waitingApprovalPage(HttpSession session, Model model) {
        UserVO user = validateUserLogin(session);
        if (user == null) {
            return UrlConstants.Redirect.TO_USER_LOGIN;
        }
        
        CartVO cart = cartService.getCart(session);
        if (cart == null || cart.isEmpty()) {
            return UrlConstants.Redirect.TO_USER_CART;
        }
        
        // 세션에서 친구 ID만 가져오기
        @SuppressWarnings("unchecked")
        List<String> selectedFriendIds = (List<String>) session.getAttribute("selectedFriendIds");
        
        log.debug("수락 대기 페이지 - 친구 ID 수: {}", 
                selectedFriendIds != null ? selectedFriendIds.size() : 0);
        
        model.addAttribute(UrlConstants.Model.CART, cart);
        model.addAttribute("friendCount", selectedFriendIds != null ? selectedFriendIds.size() : 0);
        model.addAttribute("miniGameMessage", CartConstants.MSG_MINI_GAME_PREPARING);
        
        return UrlConstants.View.USER_CART_WAITING_APPROVAL;
    }
    
    /**
     * AJAX로 선택된 친구들의 정보를 실시간 조회하는 API
     */
    @GetMapping("/get-selected-friends")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getSelectedFriends(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO user = validateUserLogin(session);
            if (user == null) {
                return ResponseEntity.ok(createLoginRequiredResponse());
            }
            
            // 세션에서 친구 ID 목록 가져오기
            @SuppressWarnings("unchecked")
            List<String> selectedFriendIds = (List<String>) session.getAttribute("selectedFriendIds");
            
            List<UserVO> selectedFriends = new ArrayList<>();
            
            if (selectedFriendIds != null && !selectedFriendIds.isEmpty()) {
                // 실시간으로 DB에서 친구 정보 조회
                List<UserVO> companyUsers = loginService.getUsersByCompanyIdExcludingCurrentUser(
                        user.getCompanyId(), user.getUsersId());
                
                for (String friendId : selectedFriendIds) {
                    try {
                        int userId = Integer.parseInt(friendId);
                        for (UserVO companyUser : companyUsers) {
                            if (companyUser.getUsersId() == userId) {
                                selectedFriends.add(companyUser);
                                break;
                            }
                        }
                    } catch (NumberFormatException e) {
                        log.warn("잘못된 친구 ID 형식: {}", friendId);
                    }
                }
            }
            
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
            response.put("friends", selectedFriends);
            
        } catch (Exception e) {
            log.error("친구 정보 조회 오류", e);
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
            response.put(CartConstants.JSON_MESSAGE, "친구 정보 조회에 실패했습니다.");
        }
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * 친구 ID 배열로 친구들의 정보를 조회하는 API
     */
    @PostMapping("/get-friends-by-ids")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getFriendsByIds(
            @RequestBody List<String> friendIds,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO user = validateUserLogin(session);
            if (user == null) {
                return ResponseEntity.ok(createLoginRequiredResponse());
            }
            
            List<UserVO> friends = new ArrayList<>();
            
            if (friendIds != null && !friendIds.isEmpty()) {
                // 회사 전체 사용자 목록 조회
                List<UserVO> companyUsers = loginService.getUsersByCompanyIdExcludingCurrentUser(
                        user.getCompanyId(), user.getUsersId());
                
                // 요청된 친구 ID들과 매칭
                for (String friendId : friendIds) {
                    try {
                        int userId = Integer.parseInt(friendId);
                        for (UserVO companyUser : companyUsers) {
                            if (companyUser.getUsersId() == userId) {
                                friends.add(companyUser);
                                break;
                            }
                        }
                    } catch (NumberFormatException e) {
                        log.warn("잘못된 친구 ID 형식: {}", friendId);
                    }
                }
            }
            
            log.debug("친구 정보 조회 - 요청: {}, 응답: {}", friendIds.size(), friends.size());
            
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
            response.put("friends", friends);
            
        } catch (Exception e) {
            log.error("친구 정보 조회 오류", e);
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
            response.put(CartConstants.JSON_MESSAGE, "친구 정보 조회에 실패했습니다.");
        }
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * 장바구니에 메뉴 추가 API
     */
    @PostMapping("/add")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addToCart(
            @RequestParam(UrlConstants.Param.MENU_ID) int menuId,
            @RequestParam(UrlConstants.Param.QUANTITY) int quantity,
            @RequestParam(value = "unitPrice", required = false) Integer unitPrice,
            @RequestParam(value = "options", required = false) String options,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO user = validateUserLogin(session);
            if (user == null) {
                return ResponseEntity.ok(createLoginRequiredResponse());
            }
            
            boolean success;
            
            // 옵션 정보가 있는 경우, 가격만 있는 경우, 기본 메뉴만 추가하는 경우 구분
            if (options != null && !options.trim().isEmpty() && unitPrice != null && unitPrice > 0) {
                log.info("옵션 정보 포함 장바구니 추가: menuId=" + menuId + ", quantity=" + quantity + ", unitPrice=" + unitPrice + ", options=" + options);
                success = cartService.addToCart(session, menuId, quantity, unitPrice, options);
            } else if (unitPrice != null && unitPrice > 0) {
                log.info("옵션 가격만 포함 장바구니 추가: menuId=" + menuId + ", quantity=" + quantity + ", unitPrice=" + unitPrice);
                success = cartService.addToCart(session, menuId, quantity, unitPrice);
            } else {
                log.info("기본 메뉴 장바구니 추가: menuId=" + menuId + ", quantity=" + quantity);
                success = cartService.addToCart(session, menuId, quantity);
            }
            
            if (success) {
                response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
                response.put(CartConstants.JSON_MESSAGE, CartConstants.MSG_CART_ADD_SUCCESS);
                response.put(CartConstants.JSON_CART_COUNT, cartService.getCartItemCount(session));
            } else {
                response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
                response.put(CartConstants.JSON_MESSAGE, CartConstants.MSG_CART_ADD_FAILED);
            }
            
        } catch (Exception e) {
            log.error("장바구니 추가 오류", e);
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
            response.put(CartConstants.JSON_MESSAGE, CartConstants.MSG_CART_ADD_ERROR);
        }
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * 장바구니 수량 변경 API
     */
    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateQuantity(
            @RequestParam(UrlConstants.Param.MENU_ID) int menuId,
            @RequestParam(UrlConstants.Param.QUANTITY) int quantity,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO user = validateUserLogin(session);
            if (user == null) {
                return ResponseEntity.ok(createLoginRequiredResponse());
            }
            
            boolean success = cartService.updateQuantity(session, menuId, quantity);
            
            if (success) {
                response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
                response.put(CartConstants.JSON_MESSAGE, CartConstants.MSG_QUANTITY_UPDATE_SUCCESS);
                CartVO cart = cartService.getCart(session);
                response.put(CartConstants.JSON_TOTAL_AMOUNT, cart.getTotalAmount());
                response.put(CartConstants.JSON_CART_COUNT, cartService.getCartItemCount(session));
            } else {
                response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
                response.put(CartConstants.JSON_MESSAGE, CartConstants.MSG_QUANTITY_UPDATE_FAILED);
            }
            
        } catch (Exception e) {
            log.error("수량 변경 오류", e);
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
            response.put(CartConstants.JSON_MESSAGE, CartConstants.MSG_QUANTITY_UPDATE_ERROR);
        }
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * 장바구니 아이템 삭제 API
     */
    @PostMapping("/remove")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> removeFromCart(
            @RequestParam(UrlConstants.Param.MENU_ID) int menuId,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO user = validateUserLogin(session);
            if (user == null) {
                return ResponseEntity.ok(createLoginRequiredResponse());
            }
            
            boolean success = cartService.removeItem(session, menuId);
            
            if (success) {
                response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
                response.put(CartConstants.JSON_MESSAGE, CartConstants.MSG_ITEM_REMOVE_SUCCESS);
                CartVO cart = cartService.getCart(session);
                response.put(CartConstants.JSON_TOTAL_AMOUNT, cart.getTotalAmount());
                response.put(CartConstants.JSON_CART_COUNT, cartService.getCartItemCount(session));
            } else {
                response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
                response.put(CartConstants.JSON_MESSAGE, CartConstants.MSG_ITEM_REMOVE_FAILED);
            }
            
        } catch (Exception e) {
            log.error("메뉴 삭제 오류", e);
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
            response.put(CartConstants.JSON_MESSAGE, CartConstants.MSG_ITEM_REMOVE_ERROR);
        }
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * 장바구니 전체 삭제 API
     */
    @PostMapping("/clear")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> clearCart(HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO user = validateUserLogin(session);
            if (user == null) {
                return ResponseEntity.ok(createLoginRequiredResponse());
            }
            
            cartService.clearCart(session);
            
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
            response.put(CartConstants.JSON_MESSAGE, CartConstants.MSG_CART_CLEAR_SUCCESS);
            response.put(CartConstants.JSON_CART_COUNT, CartConstants.DEFAULT_CART_COUNT);
            
        } catch (Exception e) {
            log.error("장바구니 비우기 오류", e);
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
            response.put(CartConstants.JSON_MESSAGE, CartConstants.MSG_CART_CLEAR_ERROR);
        }
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * 장바구니 아이템 개수 조회 API
     */
    @GetMapping("/count")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCartCount(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO user = validateUserLogin(session);
            if (user == null) {
                response.put(CartConstants.JSON_COUNT, CartConstants.DEFAULT_CART_COUNT);
                return ResponseEntity.ok(response);
            }
            
            int count = cartService.getCartItemCount(session);
            response.put(CartConstants.JSON_COUNT, count);
            
        } catch (Exception e) {
            log.error("장바구니 개수 조회 오류", e);
            response.put(CartConstants.JSON_COUNT, CartConstants.DEFAULT_CART_COUNT);
        }
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * 장바구니 총 금액 조회 API
     */
    @GetMapping("/total")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCartTotal(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO user = validateUserLogin(session);
            if (user == null) {
                response.put(CartConstants.JSON_COUNT, CartConstants.DEFAULT_CART_COUNT);
                response.put(CartConstants.JSON_TOTAL_AMOUNT, 0);
                return ResponseEntity.ok(response);
            }
            
            CartVO cart = cartService.getCart(session);
            int count = cart != null ? cart.getItems().size() : 0;
            int totalAmount = cart != null ? cart.getTotalAmount() : 0;
            
            response.put(CartConstants.JSON_COUNT, count);
            response.put(CartConstants.JSON_TOTAL_AMOUNT, totalAmount);
            
        } catch (Exception e) {
            log.error("장바구니 총 금액 조회 오류", e);
            response.put(CartConstants.JSON_COUNT, CartConstants.DEFAULT_CART_COUNT);
            response.put(CartConstants.JSON_TOTAL_AMOUNT, 0);
        }
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * 부서별 사용자 목록 조회 API
     */
    @GetMapping("/users/department/{departmentId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getUsersByDepartment(
            @PathVariable(UrlConstants.Param.DEPARTMENT_ID) int departmentId,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO user = validateUserLogin(session);
            if (user == null) {
                return ResponseEntity.ok(createLoginRequiredResponse());
            }
            
            List<UserVO> departmentUsers = loginService.getUsersByDepartmentIdExcludingCurrentUser(
                    departmentId, user.getUsersId());
            
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
            response.put(CartConstants.JSON_USERS, departmentUsers);
            
        } catch (Exception e) {
            log.error("부서별 사용자 조회 오류", e);
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
            response.put(CartConstants.JSON_MESSAGE, CartConstants.MSG_USER_LIST_ERROR);
        }
        
        return ResponseEntity.ok(response);
    }
} 