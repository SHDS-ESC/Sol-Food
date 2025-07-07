package kr.co.solfood.user.cart;

import kr.co.solfood.common.constants.UrlConstants;
import kr.co.solfood.payments.integrated.IntegratedPaymentService;
import kr.co.solfood.payments.payment.PaymentService;
import kr.co.solfood.user.login.LoginService;
import kr.co.solfood.user.login.UserVO;
import kr.co.solfood.util.CustomException;
import kr.co.solfood.util.ErrorCode;
import kr.co.solfood.util.PageMaker;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Controller
@RequestMapping(UrlConstants.User.CART_BASE)
public class CartController {

    // 사용자별 초대 친구 목록을 저장하는 Map
    // 엔티티 삭제 필요. 만약 Key가 겹치는 경우엔 초기화 할 것인지 불러올 것인지 선택
    // Key : 발의자 ID
    // Value : 초대 친구 ID Set
    private final Map<Long, Set<Long>> inviteMap = new ConcurrentHashMap<>();
    // 최종 영수증 정보를 저장하는 Map
    // 엔티티 삭제 필요. 만약 Key가 겹치는 경우엔 초기화 할 것인지 불러올 것인지 선택
    // Key : 발의자 ID
    // Value : 최종 영수증 VO
    private final Map<Long, BillDTO> billMap = new ConcurrentHashMap<>();

    @Autowired
    private CartService cartService;
    @Autowired
    private IntegratedPaymentService integratedPaymentService;
    @Autowired
    private PaymentService paymentService;
    @Autowired
    private LoginService loginService;

    /**
     * 세션에서 유효한 사용자 정보를 가져옴
     * @param session HttpSession
     * @return UserVO 사용자 정보
     * @throws CustomException 로그인되지 않은 경우
     */
    private UserVO getValidatedUser(HttpSession session) {
        System.out.println("로그인 체크");
        UserVO user = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        if (user == null) {
            System.out.println("로그인되지 않은 사용자");
            throw new CustomException(ErrorCode.UNAUTHORIZED);
        }
        System.out.println("로그인 한 사용자");
        return user;
    }

    /**
     * 장바구니 유효성 검증 (비어있지 않은지 확인)
     * @param session HttpSession
     * @throws CustomException 장바구니가 비어있는 경우
     */
    private void validateCart(HttpSession session) {
        CartVO cart = cartService.getCart(session);
        if (cart == null || cart.isEmpty()) {
            throw new CustomException(ErrorCode.CART_EMPTY);
        }
    }

    // =============================== 페이지 이동 API ===============================

    /**
     * 장바구니 페이지
     */
    @GetMapping
    public String cartPage(HttpSession session, Model model) {
        getValidatedUser(session); // 로그인 검증만 필요

        CartVO cart = cartService.getCart(session);
        model.addAttribute(UrlConstants.Model.CART, cart);
        return UrlConstants.View.USER_CART;
    }

    /**
     * 결제 방식 선택 페이지
     */
    @GetMapping("/payment-method")
    public String paymentMethodPage(HttpSession session, Model model) {
        getValidatedUser(session);
        validateCart(session);

        CartVO cart = cartService.getCart(session);
        model.addAttribute(UrlConstants.Model.CART, cart);
        return UrlConstants.View.USER_CART_PAYMENT_METHOD;
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

        UserVO user = getValidatedUser(session);
        validateCart(session);

        CartVO cart = cartService.getCart(session);

        // 친구 초대 페이지 진입시 항상 초기화 (현재 사용자만 선택)
        Set<Long> selectedFriendIds = new HashSet<>();
        selectedFriendIds.add((long) user.getUsersId());
        inviteMap.put(user.getUsersId(), selectedFriendIds);

        log.info("친구 초대 페이지 진입: 사용자 {} - 선택 상태 초기화", user.getUsersId());

        // 필터링된 친구 목록 조회
        List<UserVO> filteredUsers = getFilteredFriends(user, filter, search);

        // 페이징 처리
        PageMaker<UserVO> pageMaker = getPagedFriends(filteredUsers, page, size);

        // JSP에서 사용할 데이터 준비
        model.addAttribute(UrlConstants.Model.CART, cart);
        model.addAttribute("friends", pageMaker.getList());
        model.addAttribute("selectedFriends", selectedFriendIds);
        model.addAttribute(UrlConstants.Model.CURRENT_USER, user);
        model.addAttribute("pageMaker", pageMaker);
        model.addAttribute("currentPage", page);
        model.addAttribute(CartConstants.PARAM_SEARCH, search);
        model.addAttribute("filter", filter);
        model.addAttribute("totalCount", pageMaker.getCount());

        return UrlConstants.View.USER_CART_INVITE_FRIENDS;
    }

    /**
     * 결제 금액 결정 페이지
     */
    @GetMapping("/make-bill")
    public String makeBillPage(HttpSession session, Model model) {
        getValidatedUser(session); // 로그인 검증만 필요
        validateCart(session);

        return UrlConstants.View.USER_CART_MAKE_BILL;
    }

    /**
     * 수락 대기 페이지
     */
    @GetMapping("/waiting-approval")
    public String waitingApprovalPage(HttpSession session, Model model, @Value("${imp.code}") String impCode) {
        UserVO user = getValidatedUser(session);
        validateCart(session);

        CartVO cart = cartService.getCart(session);

        // inviteMap이 비어있으면 현재 사용자만 추가 (혼자 결제하는 경우)
        Set<Long> selectedFriendIds = inviteMap.getOrDefault(user.getUsersId(), new HashSet<>());
        if (selectedFriendIds.isEmpty()) {
            selectedFriendIds.add((long) user.getUsersId());
            inviteMap.put(user.getUsersId(), selectedFriendIds);
            log.info("혼자 결제하는 경우: 사용자 {}를 inviteMap에 추가", user.getUsersId());
        }

        // 선택된 친구들의 상세 정보 조회
        List<UserVO> selectedFriends = getParticipantDetails(user);

        log.info("수락 대기 페이지: 사용자 {} - 선택된 친구들 {}명", user.getUsersId(), selectedFriends.size());
        model.addAttribute(UrlConstants.Model.CART, cart);
        model.addAttribute(UrlConstants.Model.CURRENT_USER, user);
        model.addAttribute("selectedFriends", selectedFriends);
        model.addAttribute("friendCount", selectedFriends.size());
        model.addAttribute("miniGameMessage", CartConstants.MSG_MINI_GAME_PREPARING);
        model.addAttribute("impCode", impCode);
        return UrlConstants.View.USER_CART_WAITING_APPROVAL;
    }

    /**
     * 결제 완료 페이지
     */
    @GetMapping("/payment-complete")
    public String paymentCompletePage(HttpSession session, Model model) {
        UserVO user = getValidatedUser(session);
        validateCart(session);

        CartVO cart = cartService.getCart(session);

        model.addAttribute(UrlConstants.Model.CART, cart);
        model.addAttribute(UrlConstants.Model.CURRENT_USER, user);
        return UrlConstants.View.USER_CART_PAYMENT_COMPLETE;
    }

    // =============================== 장바구니 관련 API ===============================

    /**
     * 장바구니에 메뉴 추가 API (옵션 자동 계산)
     */
    @PostMapping("/add-with-options")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addToCartWithOptions(
            @RequestParam(UrlConstants.Param.MENU_ID) int menuId,
            @RequestParam(UrlConstants.Param.QUANTITY) int quantity,
            @RequestParam(value = "selectedOptions", required = false) String selectedOptions,
            HttpSession session) {

        getValidatedUser(session); // 로그인 검증만 필요

        boolean success = cartService.addToCartWithOptions(session, menuId, quantity, selectedOptions);

        if (success) {
            return ResponseEntity.ok(createCartAddSuccessResponse(session, CartConstants.MSG_CART_ADD_SUCCESS));
        } else {
            return ResponseEntity.ok(createCartErrorResponse(CartConstants.MSG_CART_ADD_FAILED));
        }
    }

    /**
     * 장바구니 아이템 수량 변경 API
     */
    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateCartItemQuantity(
            @RequestParam(UrlConstants.Param.MENU_ID) int menuId,
            @RequestParam(UrlConstants.Param.QUANTITY) int quantity,
            HttpSession session) {

        getValidatedUser(session); // 로그인 검증만 필요

        boolean success = cartService.updateQuantity(session, menuId, quantity);

        if (success) {
            return ResponseEntity.ok(createCartSuccessResponse(session, CartConstants.MSG_QUANTITY_UPDATE_SUCCESS));
        } else {
            return ResponseEntity.ok(createCartErrorResponse(CartConstants.MSG_QUANTITY_UPDATE_FAILED));
        }
    }

    /**
     * 장바구니 아이템 삭제 API
     */
    @PostMapping("/remove")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> removeCartItem(
            @RequestParam(UrlConstants.Param.MENU_ID) int menuId,
            HttpSession session) {

        getValidatedUser(session); // 로그인 검증만 필요

        boolean success = cartService.removeItem(session, menuId);

        if (success) {
            return ResponseEntity.ok(createCartSuccessResponse(session, CartConstants.MSG_ITEM_REMOVE_SUCCESS));
        } else {
            return ResponseEntity.ok(createCartErrorResponse(CartConstants.MSG_ITEM_REMOVE_FAILED));
        }
    }

    /**
     * 장바구니 전체 삭제 API
     */
    @PostMapping("/clear")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> clearCart(HttpSession session) {
        UserVO user = getValidatedUser(session);
        cartService.clearCart(session);

        // 장바구니 비우면 inviteMap에서도 삭제
        inviteMap.remove(user.getUsersId());

        return ResponseEntity.ok(createCartClearSuccessResponse(CartConstants.MSG_CART_CLEAR_SUCCESS));
    }

    /**
     * 장바구니 아이템 개수 조회 API
     */
    @GetMapping("/count")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCartItemCount(HttpSession session) {
        getValidatedUser(session); // 로그인 검증만 필요

        int count = cartService.getCartItemCount(session);

        Map<String, Object> response = new HashMap<>();
        response.put(CartConstants.JSON_COUNT, count);

        return ResponseEntity.ok(response);
    }

    /**
     * 장바구니 총 금액 조회 API
     */
    @GetMapping("/total")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCartTotalAmount(HttpSession session) {
        System.out.println("API Total Called");
        getValidatedUser(session); // 로그인 검증만 필요

        int count = cartService.getCartItemCount(session);
        int totalAmount = cartService.getCartTotalAmount(session);

        Map<String, Object> response = new HashMap<>();
        response.put(CartConstants.JSON_COUNT, count);
        response.put(CartConstants.JSON_TOTAL_AMOUNT, totalAmount);

        return ResponseEntity.ok(response);
    }

    /**
     * 테스트용 API - getWriter() 직접 사용
     */
    @GetMapping("/test-getwriter")
    public void testGetWriter(HttpServletResponse response) throws Exception {
        log.info("테스트 API 호출 - getWriter() 직접 사용");
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("{}");
        out.flush();
    }

    // =============================== 친구 초대 관련 API ===============================

    /**
     * 친구 목록 조회 API (페이징 포함)
     */
    @GetMapping("/friends-api")
    @ResponseBody
    private ResponseEntity<Map<String, Object>> getFriendsList(
            @RequestParam(value = CartConstants.PARAM_PAGE, defaultValue = "1") int page,
            @RequestParam(value = CartConstants.PARAM_SIZE, defaultValue = "10") int size,
            @RequestParam(value = CartConstants.PARAM_SEARCH, required = false) String search,
            @RequestParam(value = "filter", defaultValue = "all") String filter,
            HttpSession session) {

        UserVO user = getValidatedUser(session);

        // 필터링된 친구 목록 조회
        List<UserVO> filteredUsers = getFilteredFriends(user, filter, search);

        // 페이징 처리
        PageMaker<UserVO> pageMaker = getPagedFriends(filteredUsers, page, size);

        Map<String, Object> response = new HashMap<>();
        response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
        response.put("friends", pageMaker.getList());
        response.put("pageMaker", pageMaker);
        response.put("currentPage", page);
        response.put("totalCount", pageMaker.getCount());

        return ResponseEntity.ok(response);
    }

    /**
     * 선택된 친구 목록 조회 API
     */
    @GetMapping("/selected-friends")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getSelectedFriends(HttpSession session) {
        UserVO user = getValidatedUser(session);

        Set<Long> selectedFriendIds = inviteMap.getOrDefault(user.getUsersId(), new HashSet<>());
        if (selectedFriendIds.isEmpty()) {
            selectedFriendIds.add((long) user.getUsersId());
            inviteMap.put(user.getUsersId(), selectedFriendIds);
        }
        List<String> selectedFriendIdStrings = selectedFriendIds.stream()
                .map(String::valueOf)
                .collect(java.util.stream.Collectors.toList());

        Map<String, Object> response = new HashMap<>();
        response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
        response.put("selectedFriendIds", selectedFriendIdStrings);

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
        UserVO user = getValidatedUser(session);

        Set<Long> selectedFriends = inviteMap.getOrDefault(user.getUsersId(), new HashSet<>());
        boolean wasSelected = selectedFriends.contains(friendId);
        if (wasSelected) {
            selectedFriends.remove(friendId);
        } else {
            selectedFriends.add(friendId);
        }
        inviteMap.put(user.getUsersId(), selectedFriends);

        Map<String, Object> response = new HashMap<>();
        response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
        response.put("friendId", friendId);
        response.put("selected", !wasSelected);
        response.put("totalSelected", selectedFriends.size());

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
        UserVO user = getValidatedUser(session);

        @SuppressWarnings("unchecked")
        List<Object> friendIdObjects = (List<Object>) request.get("selectedFriendIds");
        if (friendIdObjects == null) {
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
        inviteMap.put(user.getUsersId(), selectedFriends);

        Map<String, Object> response = new HashMap<>();
        response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
        response.put("syncedCount", selectedFriends.size());

        return ResponseEntity.ok(response);
    }

    /**
     * 초대 확정 API -> Controller의 Map에 저장
     */
    @PostMapping("/invite-confirm")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> confirmInvite(
            @RequestBody Map<String, Object> request,
            HttpSession session) {
        UserVO user = getValidatedUser(session);
        validateCart(session);

        @SuppressWarnings("unchecked")
        List<Object> selectedFriendIdObjects = (List<Object>) request.get("selectedFriendIds");
        if (selectedFriendIdObjects == null || selectedFriendIdObjects.isEmpty()) {
            Map<String, Object> response = new HashMap<>();
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
            response.put(CartConstants.JSON_MESSAGE, "선택된 친구가 없습니다.");
            return ResponseEntity.ok(response);
        }
        Set<Long> friendIdSet = new HashSet<>();
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
            } catch (NumberFormatException e) {
                log.warn("잘못된 친구 ID 형식: {}", friendIdObj);
            }
        }
        // Controller의 Map에 저장
        inviteMap.put(user.getUsersId(), friendIdSet);
        log.info("초대 확정 완료: 사용자 {} - 선택된 친구들 {} (Map에 저장)", user.getUsersId(), friendIdSet);

        Map<String, Object> response = new HashMap<>();
        response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
        response.put(CartConstants.JSON_MESSAGE, "친구 초대가 완료되었습니다.");
        response.put("selectedFriendCount", friendIdSet.size());

        return ResponseEntity.ok(response);
    }

    // =============================== 더치페이 관련 API ===============================

    /**
     * 더치페이 가격 계산 API
     */
    @PostMapping("/calculate-dutch-pay")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> calculateDutchPay(
            @RequestBody Map<String, Object> request,
            HttpSession session) {
        UserVO user = getValidatedUser(session);
        validateCart(session);
        CartVO cart = cartService.getCart(session);
        String paymentMethod = (String) request.get("paymentMethod");

        Set<Long> participantIds = getParticipantIds(user);
        if (participantIds.isEmpty()) {
            Map<String, Object> response = new HashMap<>();
            response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
            response.put(CartConstants.JSON_MESSAGE, "참여자 정보가 없습니다.");
            return ResponseEntity.ok(response);
        }

        int totalAmount = cart.getTotalAmount();
        int participantCount = participantIds.size();
        Map<String, Integer> paymentDistribution = new HashMap<>();

        if ("equal".equals(paymentMethod)) {
            int baseAmount = totalAmount / participantCount;
            int remainder = totalAmount % participantCount;
            int i = 0;
            for (Long participantId : participantIds) {
                int amount = baseAmount + (i < remainder ? 1 : 0);
                paymentDistribution.put(participantId.toString(), amount);
                i++;
            }
        } else if ("random".equals(paymentMethod)) {
            int minAmount = Math.max(1000, totalAmount / participantCount / 2);
            int maxAmount = Math.min(totalAmount - (participantCount - 1) * minAmount,
                    totalAmount / participantCount * 2);
            int remainingAmount = totalAmount;
            java.util.Random random = new java.util.Random();
            List<Long> participantIdList = new ArrayList<>(participantIds);
            for (int i = 0; i < participantIdList.size() - 1; i++) {
                Long participantId = participantIdList.get(i);
                int remainingParticipants = participantIdList.size() - i;
                int minForThisParticipant = Math.max(minAmount,
                        remainingAmount - (remainingParticipants - 1) * maxAmount);
                int maxForThisParticipant = Math.min(maxAmount,
                        remainingAmount - (remainingParticipants - 1) * minAmount);
                int amount = random.nextInt(maxForThisParticipant - minForThisParticipant + 1)
                        + minForThisParticipant;
                paymentDistribution.put(participantId.toString(), amount);
                remainingAmount -= amount;
            }
            paymentDistribution.put(participantIdList.get(participantIdList.size() - 1).toString(), remainingAmount);
        }

        List<UserVO> participants = getParticipantDetails(user);
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

        Map<String, Object> response = new HashMap<>();
        response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
        response.put("totalAmount", totalAmount);
        response.put("participantCount", participantCount);
        response.put("paymentMethod", paymentMethod);
        response.put("paymentList", paymentList);
        response.put("cart", cart);
        response.put("participants", participants);

        return ResponseEntity.ok(response);
    }

    /**
     * 더치페이 계산 결과 조회 API (GET, make-bill.jsp용)
     */
    @GetMapping("/calculate-dutch-pay")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getDutchPayCalculation(HttpSession session) {
        UserVO user = getValidatedUser(session);
        validateCart(session);

        CartVO cart = cartService.getCart(session);
        if (cart == null || cart.isEmpty()) {
            Map<String, Object> response = new HashMap<>();
            response.put("result", "error");
            response.put("message", "장바구니가 비어있습니다.");
            return ResponseEntity.ok(response);
        }

        List<UserVO> participantList = getParticipantDetails(user);
        List<Map<String, Object>> participants = new ArrayList<>();
        int totalAmount = cart.getTotalAmount();
        int participantCount = participantList.size();
        int amountPerPerson = participantCount > 0 ? totalAmount / participantCount : 0;

        for (UserVO participant : participantList) {
            Map<String, Object> participantInfo = new HashMap<>();
            participantInfo.put("userId", participant.getUsersId());
            participantInfo.put("userName", participant.getUsersName());
            participantInfo.put("userProfile", participant.getUsersProfile());
            participantInfo.put("amount", amountPerPerson);
            participantInfo.put("isCurrentUser", participant.getUsersId() == user.getUsersId());
            participants.add(participantInfo);
        }

        Map<String, Object> response = new HashMap<>();
        response.put("result", "success");
        response.put("participantList", participants);
        response.put("totalAmount", totalAmount);

        return ResponseEntity.ok(response);
    }

    /**
     * BillDTO 생성/저장 API (POST, make-bill.jsp용)
     */
    @PostMapping("/submit-bill")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> submitBill(@RequestBody Map<String, Object> request, HttpSession session) {
        UserVO user = getValidatedUser(session);

        // 1. session에서 cart 가져오기
        CartVO cart = cartService.getCart(session);
        if (cart == null || cart.isEmpty()) {
            Map<String, Object> response = new HashMap<>();
            response.put("result", "error");
            response.put("message", "장바구니가 비어있습니다.");
            return ResponseEntity.ok(response);
        }

        // 2. controller의 inviteMap에서 참여자 목록 가져오기
        List<UserVO> participants = getParticipantDetails(user);
        int totalAmount = cart.getTotalAmount();
        int participantCount = participants.size();
        int amountPerPerson = participantCount > 0 ? totalAmount / participantCount : 0;

        // 3. BillDTO 생성
        BillDTO billDTO = new BillDTO();
        billDTO.setLeaderId(user.getUsersId());
        billDTO.setTotalAmount(totalAmount);
        billDTO.setStoreId(cart.getStoreId());
        billDTO.setStoreName(cart.getStoreName());
        billDTO.setCartItems(cart.getItems());
        Map<Long, Integer> userBill = new HashMap<>();
        for (UserVO participant : participants) {
            userBill.put(participant.getUsersId(), amountPerPerson);
        }
        billDTO.setUserBill(userBill);

        // 4. billMap에 저장, inviteMap에서 참여자 목록 제거
        billMap.put(user.getUsersId(), billDTO);
//        inviteMap.remove(user.getUsersId());

        // log.info("BillDTO 생성 완료: 사용자 {} - 총 금액 {}원, 참여자 {}명",
        //         user.getUsersId(), billDTO.getTotalAmount(), billDTO.getCartItems().size());

        // 5. DB 저장
        int integratedPaymentId = integratedPaymentService.createIntegratedPayment(billDTO);
        paymentService.createPayment(billDTO, integratedPaymentId);

        Map<String, Object> response = new HashMap<>();
        response.put("result", "success");
        response.put("message", "영수증이 생성되었습니다.");

        return ResponseEntity.ok(response);
    }

    /**
     * 더치페이 페이지 데이터 통합 조회 API
     */
    @GetMapping("/dutch-pay-data")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getDutchPayData(HttpSession session) {
        UserVO user = getValidatedUser(session);
        validateCart(session);
        CartVO cart = cartService.getCart(session);
        List<UserVO> participants = getParticipantDetails(user);

        Map<String, Object> response = new HashMap<>();
        response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
        response.put("participants", participants);
        response.put("cart", cart);
        response.put("totalAmount", cart.getTotalAmount());
        response.put("itemCount", cart.getItems().size());
        response.put("participantCount", participants.size());

        return ResponseEntity.ok(response);
    }

    // =============================== 기타 API ===============================

    /**
     * 부서별 사용자 목록 조회 API
     */
    @GetMapping("/users/department/{departmentId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getUsersByDepartment(
            @PathVariable(UrlConstants.Param.DEPARTMENT_ID) int departmentId,
            HttpSession session) {

        UserVO user = getValidatedUser(session);

        List<UserVO> departmentUsers = loginService.getUsersByDepartmentIdExcludingCurrentUser(
                departmentId, user.getUsersId());

        Map<String, Object> response = new HashMap<>();
        response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
        response.put(CartConstants.JSON_USERS, departmentUsers);

        return ResponseEntity.ok(response);
    }

    /**
     * SSE를 통한 결제 상태 모니터링
     */
    @GetMapping(value = "/payment-status-stream")
    public ResponseEntity<String> paymentStatusStream(HttpSession session) {
        UserVO user = getValidatedUser(session);

        // SSE 응답 생성
        String sseData = "data: {\"type\": \"connected\", \"userId\": " + user.getUsersId() + "}\n\n";

        return ResponseEntity.ok()
                .contentType(MediaType.valueOf("text/event-stream;charset=UTF-8"))
                .header("Cache-Control", "no-cache")
                .header("Connection", "keep-alive")
                .header("Access-Control-Allow-Origin", "*")
                .body(sseData);
    }

    // =============================== 내부 메서드 ===============================

    /**
     * 장바구니 성공 응답 생성 (카트 정보 포함)
     */
    private Map<String, Object> createCartSuccessResponse(HttpSession session, String message) {
        Map<String, Object> response = new HashMap<>();
        response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
        response.put(CartConstants.JSON_MESSAGE, message);

        // 카트 정보 추가
        response.put(CartConstants.JSON_TOTAL_AMOUNT, cartService.getCartTotalAmount(session));
        response.put(CartConstants.JSON_CART_COUNT, cartService.getCartItemCount(session));

        return response;
    }

    /**
     * 장바구니 실패 응답 생성
     */
    private Map<String, Object> createCartErrorResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_ERROR);
        response.put(CartConstants.JSON_MESSAGE, message);
        return response;
    }

    /**
     * 장바구니 비우기 성공 응답 생성 (카트 개수만 0으로 설정)
     */
    private Map<String, Object> createCartClearSuccessResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put(CartConstants.JSON_RESULT, CartConstants.RESULT_SUCCESS);
        response.put(CartConstants.JSON_MESSAGE, message);
        response.put(CartConstants.JSON_CART_COUNT, CartConstants.DEFAULT_CART_COUNT);
        return response;
    }

    /**
     * 장바구니 추가 성공 응답 생성 (추가 정보 포함)
     */
    private Map<String, Object> createCartAddSuccessResponse(HttpSession session, String message) {
        Map<String, Object> response = createCartSuccessResponse(session, message);

        // 추가된 아이템의 실제 계산된 가격 정보도 포함
        response.put(CartConstants.JSON_TOTAL_AMOUNT, cartService.getCartTotalAmount(session));

        return response;
    }

    /**
     * 필터링된 친구 목록 조회 (페이징 포함)
     */
    private List<UserVO> getFilteredFriends(UserVO user, String filter, String search) {
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

        return filteredUsers;
    }

    /**
     * 페이징된 친구 목록 조회
     */
    private PageMaker<UserVO> getPagedFriends(List<UserVO> allUsers, int page, int size) {
        long totalCount = allUsers.size();

        // 페이징 처리
        int offset = (page - 1) * size;
        int endIndex = Math.min(offset + size, allUsers.size());
        List<UserVO> pagedUsers = offset < allUsers.size() ?
                allUsers.subList(offset, endIndex) : new ArrayList<>();

        return new PageMaker<>(pagedUsers, totalCount, size, page);
    }

    /**
     * 참여자 ID Set 반환 (항상 user 포함)
     */
    private Set<Long> getParticipantIds(UserVO user) {
        Set<Long> ids = inviteMap.get(user.getUsersId());
        if (ids == null || ids.isEmpty()) {
            Set<Long> self = new HashSet<>();
            self.add((long) user.getUsersId());
            return self;
        }
        return new HashSet<>(ids);
    }

    /**
     * 참여자 상세 정보 조회 (항상 user 포함, inviteMap 기반)
     */
    private List<UserVO> getParticipantDetails(UserVO user) {
        Set<Long> participantIds = getParticipantIds(user);
        List<Long> idList = new ArrayList<>(participantIds);
        return loginService.getUsersByIds(idList);
    }

    @PostMapping("/invite-reset")
    @ResponseBody
    public ResponseEntity<?> resetInviteMap(HttpSession session) {
        UserVO user = getValidatedUser(session);
        Set<Long> self = new HashSet<>();
        self.add((long) user.getUsersId());
        inviteMap.put(user.getUsersId(), self);
        return ResponseEntity.ok().build();
    }

}