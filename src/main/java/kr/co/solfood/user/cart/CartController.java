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
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
     * 친구 초대 AJAX API (페이징 포함)
     */
    @GetMapping("/invite-friends-ajax")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> inviteFriendsAjax(
            @RequestParam(value = CartConstants.PARAM_PAGE, defaultValue = "1") int page,
            @RequestParam(value = CartConstants.PARAM_SIZE, defaultValue = "10") int size,
            @RequestParam(value = CartConstants.PARAM_SEARCH, required = false) String search,
            @RequestParam(value = "filter", defaultValue = "all") String filter,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO user = validateUserLogin(session);
            if (user == null) {
                return ResponseEntity.ok(createLoginRequiredResponse());
            }
            
            // 페이징 설정
            PageDTO pageDTO = new PageDTO();
            pageDTO.setCurrentPage(page);
            pageDTO.setPageSize(size);
            
            // 필터에 따라 다른 사용자 목록 조회
            List<UserVO> filteredUsers;
            
            switch (filter) {
                case "department":
                    filteredUsers = loginService.getUsersByDepartmentIdExcludingCurrentUser(
                            user.getDepartmentId(), user.getUsersId());
                    break;
                case "all":
                default:
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
            
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
            response.put("friends", pagedUsers);
            response.put("pageMaker", pageMaker);
            response.put("currentPage", page);
            response.put("totalCount", totalCount);
            
        } catch (Exception e) {
            log.error("친구 초대 AJAX 오류", e);
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
            response.put(CartConstants.JSON_MESSAGE, "친구 목록 조회에 실패했습니다.");
        }
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * 친구 목록 API (JavaScript 호환용 별칭)
     */
    @GetMapping("/friends-api")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getFriendsApi(
            @RequestParam(value = CartConstants.PARAM_PAGE, defaultValue = "1") int page,
            @RequestParam(value = CartConstants.PARAM_SIZE, defaultValue = "10") int size,
            @RequestParam(value = CartConstants.PARAM_SEARCH, required = false) String search,
            @RequestParam(value = "filter", defaultValue = "all") String filter,
            HttpSession session) {
        return inviteFriendsAjax(page, size, search, filter, session);
    }
    
    /**
     * 선택된 친구 목록 조회 API
     */
    @GetMapping("/selected-friends")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getSelectedFriends(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO user = validateUserLogin(session);
            if (user == null) {
                return ResponseEntity.ok(createLoginRequiredResponse());
            }
            
            // 세션에서 선택된 친구 ID 목록 가져오기
            @SuppressWarnings("unchecked")
            Set<Long> selectedFriendIds = (Set<Long>) session.getAttribute("selectedFriends");
            
            if (selectedFriendIds == null) {
                selectedFriendIds = new HashSet<>();
                // 현재 사용자 기본 선택
                selectedFriendIds.add((long) user.getUsersId());
                session.setAttribute("selectedFriends", selectedFriendIds);
            }
            
            // Long을 String으로 변환 (JavaScript 호환성)
            List<String> selectedFriendIdStrings = selectedFriendIds.stream()
                    .map(String::valueOf)
                    .collect(java.util.stream.Collectors.toList());
            
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
            response.put("selectedFriendIds", selectedFriendIdStrings);
            
        } catch (Exception e) {
            log.error("선택된 친구 목록 조회 오류", e);
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
            response.put(CartConstants.JSON_MESSAGE, "선택된 친구 목록 조회에 실패했습니다.");
        }
        
        return ResponseEntity.ok(response);
    }

    /**
     * 친구 토글 (서버 중심)
     */
    @PostMapping("/friends/toggle")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleFriend(
            @RequestParam long friendId, 
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO user = validateUserLogin(session);
            if (user == null) {
                return ResponseEntity.ok(createLoginRequiredResponse());
            }
            
            // 세션에서 선택된 친구 목록 가져오기
            @SuppressWarnings("unchecked")
            Set<Long> selectedFriends = (Set<Long>) session.getAttribute("selectedFriends");
            if (selectedFriends == null) {
                selectedFriends = new HashSet<>();
            }
            
            // 토글 처리
            boolean wasSelected = selectedFriends.contains(friendId);
            if (wasSelected) {
                selectedFriends.remove(friendId);
            } else {
                selectedFriends.add(friendId);
            }
            
            // 세션에 다시 저장
            session.setAttribute("selectedFriends", selectedFriends);
            
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
            response.put("friendId", friendId);
            response.put("selected", !wasSelected);
            response.put("totalSelected", selectedFriends.size());
            
        } catch (Exception e) {
            log.error("친구 토글 오류", e);
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
            response.put(CartConstants.JSON_MESSAGE, "친구 선택 처리에 실패했습니다.");
        }
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * 친구 일괄 동기화 (개선된 버전)
     */
    @PostMapping("/friends/sync")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> syncSelectedFriends(
            @RequestBody Map<String, Object> request,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO user = validateUserLogin(session);
            if (user == null) {
                return ResponseEntity.ok(createLoginRequiredResponse());
            }
            
            // 새로운 형식 (selectedFriendIds) 또는 기존 형식 처리
            @SuppressWarnings("unchecked")
            List<Object> friendIdObjects = (List<Object>) request.get("selectedFriendIds");
            
            if (friendIdObjects == null) {
                // 기존 형식 시도
                friendIdObjects = (List<Object>) request;
            }
            
            Set<Long> selectedFriends = new HashSet<>();
            
            if (friendIdObjects != null) {
                for (Object friendIdObj : friendIdObjects) {
                    try {
                        if (friendIdObj instanceof Number) {
                            selectedFriends.add(((Number) friendIdObj).longValue());
                        } else if (friendIdObj instanceof String) {
                            selectedFriends.add(Long.parseLong((String) friendIdObj));
                        }
                    } catch (NumberFormatException e) {
                        log.warn("잘못된 친구 ID 형식: {}", friendIdObj);
                    }
                }
            }
            
            // 세션에 저장
            session.setAttribute("selectedFriends", selectedFriends);
            
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
            response.put("syncedCount", selectedFriends.size());
            
        } catch (Exception e) {
            log.error("친구 동기화 오류", e);
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
            response.put(CartConstants.JSON_MESSAGE, "친구 동기화에 실패했습니다.");
        }
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * 초대 확정 API
     */
    @PostMapping("/invite-confirm")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> confirmInvite(
            @RequestBody Map<String, Object> request,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO user = validateUserLogin(session);
            if (user == null) {
                return ResponseEntity.ok(createLoginRequiredResponse());
            }
            
            @SuppressWarnings("unchecked")
            List<Object> selectedFriendIdObjects = (List<Object>) request.get("selectedFriendIds");
            
            if (selectedFriendIdObjects == null || selectedFriendIdObjects.isEmpty()) {
                response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
                response.put(CartConstants.JSON_MESSAGE, "선택된 친구가 없습니다.");
                return ResponseEntity.ok(response);
            }
            
            // Long으로 변환하여 세션에 저장
            Set<Long> friendIdSet = new HashSet<>();
            List<String> friendIdStringList = new ArrayList<>();
            
            for (Object friendIdObj : selectedFriendIdObjects) {
                try {
                    long friendId;
                    if (friendIdObj instanceof Number) {
                        friendId = ((Number) friendIdObj).longValue();
                    } else if (friendIdObj instanceof String) {
                        friendId = Long.parseLong((String) friendIdObj);
                    } else {
                        continue;
                    }
                    
                    friendIdSet.add(friendId);
                    friendIdStringList.add(String.valueOf(friendId));
                } catch (NumberFormatException e) {
                    log.warn("잘못된 친구 ID 형식: {}", friendIdObj);
                }
            }
            
            // 세션에 두 가지 형식으로 저장 (기존 호환성)
            session.setAttribute("selectedFriends", friendIdSet);
            session.setAttribute("selectedFriendIds", friendIdStringList);
            
            log.info("초대 확정 완료: 사용자 {} - 선택된 친구들 {}", user.getUsersId(), friendIdSet);
            
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
            response.put(CartConstants.JSON_MESSAGE, "친구 초대가 완료되었습니다.");
            response.put("selectedFriendCount", friendIdSet.size());
            
        } catch (Exception e) {
            log.error("초대 확정 오류", e);
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
            response.put(CartConstants.JSON_MESSAGE, "초대 확정에 실패했습니다.");
        }
        
        return ResponseEntity.ok(response);
    }

    /**
     * 친구 초대 페이지 (개선된 서버 중심)
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
        
        // 친구 초대 페이지 진입시 항상 초기화 (현재 사용자만 선택)
        Set<Long> selectedFriends = new HashSet<>();
        selectedFriends.add((long) user.getUsersId());
        session.setAttribute("selectedFriends", selectedFriends);
        
        log.info("친구 초대 페이지 진입: 사용자 {} - 선택 상태 초기화", user.getUsersId());
        
        // 페이징 설정
        PageDTO pageDTO = new PageDTO();
        pageDTO.setCurrentPage(page);
        pageDTO.setPageSize(size);
        
        // 필터에 따라 다른 사용자 목록 조회
        List<UserVO> filteredUsers;
        switch (filter) {
            case "department":
                filteredUsers = loginService.getUsersByDepartmentIdExcludingCurrentUser(
                        user.getDepartmentId(), user.getUsersId());
                break;
            case "all":
            default:
                filteredUsers = loginService.getUsersByCompanyIdExcludingCurrentUser(
                        user.getCompanyId(), user.getUsersId());
                break;
        }
        
        // 검색어 필터링
        if (search != null && !search.trim().isEmpty()) {
            filteredUsers = filteredUsers.stream()
                    .filter(u -> u.getUsersName().contains(search.trim()))
                    .collect(java.util.stream.Collectors.toList());
        }
        
        long totalCount = filteredUsers.size();
        
        // 페이징 처리
        int offset = pageDTO.getOffset();
        int endIndex = Math.min(offset + pageDTO.getPageSize(), filteredUsers.size());
        List<UserVO> pagedUsers = offset < filteredUsers.size() ? 
            filteredUsers.subList(offset, endIndex) : new ArrayList<>();
        
        // PageMaker 생성
        PageMaker<UserVO> pageMaker = new PageMaker<>(pagedUsers, totalCount, size, page);
        
        // JSP에서 사용할 데이터 준비
        model.addAttribute(UrlConstants.Model.CART, cart);
        model.addAttribute("friends", pagedUsers);
        model.addAttribute("selectedFriends", selectedFriends);
        model.addAttribute(UrlConstants.Model.CURRENT_USER, user);
        model.addAttribute("pageMaker", pageMaker);
        model.addAttribute("currentPage", page);
        model.addAttribute(CartConstants.PARAM_SEARCH, search);
        model.addAttribute("filter", filter);
        model.addAttribute("totalCount", totalCount);
        
        return UrlConstants.View.USER_CART_INVITE_FRIENDS;
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
        
        // 세션에서 선택된 친구 ID들 가져오기
        @SuppressWarnings("unchecked")
        Set<Long> selectedFriendIds = (Set<Long>) session.getAttribute("selectedFriends");
        
        List<UserVO> selectedFriends = new ArrayList<>();
        
        // 현재 사용자는 항상 포함
        selectedFriends.add(user);
        
        // 선택된 친구들 정보 조회
        if (selectedFriendIds != null && selectedFriendIds.size() > 1) { // 현재 사용자 외에 다른 사람이 있는 경우
            List<UserVO> companyUsers = loginService.getUsersByCompanyIdExcludingCurrentUser(
                    user.getCompanyId(), user.getUsersId());
            
            for (Long friendId : selectedFriendIds) {
                if (friendId != user.getUsersId()) { // 현재 사용자는 이미 추가됨
                    for (UserVO companyUser : companyUsers) {
                        if (companyUser.getUsersId() == friendId.intValue()) {
                            selectedFriends.add(companyUser);
                            break;
                        }
                    }
                }
            }
        }
        
        log.info("수락 대기 페이지: 사용자 {} - 선택된 친구들 {}명", 
                 user.getUsersId(), selectedFriends.size());
        
        model.addAttribute(UrlConstants.Model.CART, cart);
        model.addAttribute(UrlConstants.Model.CURRENT_USER, user);
        model.addAttribute("selectedFriends", selectedFriends);
        model.addAttribute("friendCount", selectedFriends.size());
        model.addAttribute("miniGameMessage", CartConstants.MSG_MINI_GAME_PREPARING);
        
        return UrlConstants.View.USER_CART_WAITING_APPROVAL;
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
            
            if (options != null && !options.trim().isEmpty() && unitPrice != null && unitPrice > 0) {
                success = cartService.addToCart(session, menuId, quantity, unitPrice, options);
            } else if (unitPrice != null && unitPrice > 0) {
                success = cartService.addToCart(session, menuId, quantity, unitPrice);
            } else {
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
    
    /**
     * 더치페이 가격 계산 API
     */
    @PostMapping("/calculate-dutch-pay")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> calculateDutchPay(
            @RequestBody Map<String, Object> request,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO user = validateUserLogin(session);
            if (user == null) {
                return ResponseEntity.ok(createLoginRequiredResponse());
            }
            
            CartVO cart = cartService.getCart(session);
            if (cart == null || cart.isEmpty()) {
                response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
                response.put(CartConstants.JSON_MESSAGE, "장바구니가 비어있습니다.");
                return ResponseEntity.ok(response);
            }
            
            @SuppressWarnings("unchecked")
            List<String> participantIds = (List<String>) request.get("participantIds");
            String paymentMethod = (String) request.get("paymentMethod");
            
            if (participantIds == null || participantIds.isEmpty()) {
                response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
                response.put(CartConstants.JSON_MESSAGE, "참여자 정보가 없습니다.");
                return ResponseEntity.ok(response);
            }
            
            int totalAmount = cart.getTotalAmount();
            int participantCount = participantIds.size();
            
            Map<String, Integer> paymentDistribution = new HashMap<>();
            
            if ("equal".equals(paymentMethod)) {
                // 균등 분할
                int baseAmount = totalAmount / participantCount;
                int remainder = totalAmount % participantCount;
                
                for (int i = 0; i < participantIds.size(); i++) {
                    String participantId = participantIds.get(i);
                    int amount = baseAmount + (i < remainder ? 1 : 0);
                    paymentDistribution.put(participantId, amount);
                }
            } else if ("random".equals(paymentMethod)) {
                // 랜덤 분할 (범위 제한)
                int minAmount = Math.max(1000, totalAmount / participantCount / 2);
                int maxAmount = Math.min(totalAmount - (participantCount - 1) * minAmount, 
                                       totalAmount / participantCount * 2);
                
                int remainingAmount = totalAmount;
                java.util.Random random = new java.util.Random();
                
                for (int i = 0; i < participantIds.size() - 1; i++) {
                    String participantId = participantIds.get(i);
                    int remainingParticipants = participantIds.size() - i;
                    int minForThisParticipant = Math.max(minAmount, 
                            remainingAmount - (remainingParticipants - 1) * maxAmount);
                    int maxForThisParticipant = Math.min(maxAmount, 
                            remainingAmount - (remainingParticipants - 1) * minAmount);
                    
                    int amount = random.nextInt(maxForThisParticipant - minForThisParticipant + 1) 
                               + minForThisParticipant;
                    
                    paymentDistribution.put(participantId, amount);
                    remainingAmount -= amount;
                }
                
                // 마지막 참여자는 남은 금액
                paymentDistribution.put(participantIds.get(participantIds.size() - 1), remainingAmount);
            }
            
            // 참여자 정보 조회
            List<UserVO> participants = new ArrayList<>();
            List<UserVO> companyUsers = loginService.getUsersByCompanyIdExcludingCurrentUser(
                    user.getCompanyId(), user.getUsersId());
            
            for (String participantId : participantIds) {
                try {
                    int userId = Integer.parseInt(participantId);
                    
                    if (userId == user.getUsersId()) {
                        participants.add(user);
                    } else {
                        for (UserVO companyUser : companyUsers) {
                            if (companyUser.getUsersId() == userId) {
                                participants.add(companyUser);
                                break;
                            }
                        }
                    }
                } catch (NumberFormatException e) {
                    log.warn("잘못된 참여자 ID: {}", participantId);
                }
            }
            
            // 응답 데이터 구성
            List<Map<String, Object>> paymentList = new ArrayList<>();
            for (UserVO participant : participants) {
                String participantId = String.valueOf(participant.getUsersId());
                Integer amount = paymentDistribution.get(participantId);
                
                if (amount != null) {
                    Map<String, Object> paymentInfo = new HashMap<>();
                    paymentInfo.put("userId", participant.getUsersId());
                    paymentInfo.put("userName", participant.getUsersName());
                    paymentInfo.put("userProfile", participant.getUsersProfile());
                    paymentInfo.put("amount", amount);
                    paymentInfo.put("isCurrentUser", participant.getUsersId() == user.getUsersId());
                    
                    paymentList.add(paymentInfo);
                }
            }
            
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
            response.put("totalAmount", totalAmount);
            response.put("participantCount", participantCount);
            response.put("paymentMethod", paymentMethod);
            response.put("paymentList", paymentList);
            response.put("cart", cart);
            
        } catch (Exception e) {
            log.error("더치페이 계산 오류", e);
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
            response.put(CartConstants.JSON_MESSAGE, "더치페이 계산에 실패했습니다.");
        }
        
        return ResponseEntity.ok(response);
    }


} 