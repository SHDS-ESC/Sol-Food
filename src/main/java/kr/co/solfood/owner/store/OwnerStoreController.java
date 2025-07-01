package kr.co.solfood.owner.store;


import kr.co.solfood.owner.login.OwnerVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Optional;

@Slf4j // 로그 출력
@Controller // 컨트롤러
@RequestMapping("/owner/store") // 기본 url 매핑 설정
public class OwnerStoreController {

    @Autowired // 의존성 주입 (DI)
    private OwnerStoreService ownerStoreService;


    // 점주 > 상점 관리 페이지 get
    @GetMapping("")
    public String store(Model model, HttpSession sess) {
        // 점주 id 꺼내기
        OwnerVO owner = (OwnerVO) sess.getAttribute("ownerLoginSession");
        int ownerId = owner.getOwnerId();

        // 서비스 : 점주 <-> 상점 조회
        OwnerStoreVO store  = ownerStoreService.getOwnerStore(ownerId);
        model.addAttribute("store", store);

        return "owner/store";
    }

    // 점주 > 상점 등록 페이지 get
    @GetMapping("/add")
    public String addStore(Model model, HttpSession sess) {
        // 서비스 : 카테고리 리스트 조회
        List<OwnerCategoryVO> categoryList = ownerStoreService.getOwnerCategory();
        model.addAttribute("categoryList",categoryList); // 모델

        // 상점 등록 진행 세션 플래그 설정 (S3 업로드 보안용)
        sess.setAttribute("s3InProgress", true);
        sess.setAttribute("uploadCount", 0);
        sess.setMaxInactiveInterval(30 * 60); // 30분 후 만료

        return "owner/addStore";
    }

    // 점주 > 상점 등록 페이지 post
    @PostMapping("/add")
    public ModelAndView addStore(
            @ModelAttribute OwnerStoreVO req, // 폼에서 전달된 상점 정보 자동 매핑
            HttpSession sess,
            ModelAndView mv,
            RedirectAttributes redirectAttrs)
    {
        // 세션에서 점주 정보 Optional로 감싸기
        Optional<OwnerVO> owner = Optional.ofNullable((OwnerVO) sess.getAttribute("ownerLoginSession"));

        if (owner.isPresent()) { // 세션에 로그인 점주 정보가 있으면

            req.setOwnerId(owner.get().getOwnerId()); // 점주 id

            // 서비스 : 상점 등록
            int result = ownerStoreService.insertStore(req);
            boolean isAddStore = result > 0;

            // 상점 등록 완료 후 세션 정리
            sess.removeAttribute("s3InProgress");
            sess.removeAttribute("uploadCount");

            if (isAddStore) {
                redirectAttrs.addFlashAttribute("msg", "\uD83C\uDF74상점이 등록되었습니다.\uD83C\uDF7D\uFE0F");
                mv.setViewName("redirect:/owner/store");
            } else {
                log.error("상점 등록 실패");
                mv.addObject("store", req); // 실패 시 입력한 데이터 다시 전달
                redirectAttrs.addFlashAttribute("msg", "상점 등록에 실패했습니다.");
                mv.setViewName("owner/addStore");
            }

        } else {
            mv.setViewName("redirect:/owner/login"); // 로그인 안된경우 로그인페지로
        }

        return mv;
    }

    // 점주 > 상점 수정 페이지 진입 get
    @GetMapping("/edit")
    public String editStore(
            Model model,
            HttpSession sess
    ) {
        OwnerVO owner = (OwnerVO) sess.getAttribute("ownerLoginSession");

        // 서비스 : 상점 정보 가져오기
        OwnerStoreVO store = ownerStoreService.getOwnerStore(owner.getOwnerId());
        model.addAttribute("store", store);

        // 서비스 : 카테고리 리스트 (셀렉트박스용)
        List<OwnerCategoryVO> categoryList = ownerStoreService.getOwnerCategory();
        model.addAttribute("categoryList",categoryList);

        // 상점 진행 세션 플래그 설정 (S3 업로드 보안용)
        sess.setAttribute("s3InProgress", true);
        sess.setAttribute("uploadCount", 0);
        sess.setMaxInactiveInterval(30 * 60); // 30분 후 만료

        return "owner/editStore";
    }

    // 점주 > 상점 수정 페이지 post
    @PostMapping("/edit")
    public ModelAndView editStore(
            @ModelAttribute OwnerStoreVO req,
            HttpSession sess,
            ModelAndView mv,
            RedirectAttributes redirectAttrs
    ){
        OwnerVO owner = (OwnerVO) sess.getAttribute("ownerLoginSession");
        req.setOwnerId(owner.getOwnerId());

        // 서비스 : 상점 수정
        int result = ownerStoreService.updateStore(req);

        // 상점 수정 완료 후 세션 정리
        sess.removeAttribute("s3InProgress");
        sess.removeAttribute("uploadCount");

        if(result>0){
            redirectAttrs.addFlashAttribute("msg", "\uD83C\uDF74 상점이 수정되었습니다.\uD83D\uDC8C");
            mv.setViewName("redirect:/owner/store");
        } else {
            redirectAttrs.addFlashAttribute("msg", "상점 수정에 실패했습니다.");
            mv.addObject("store", req);
            mv.setViewName("owner/editStore");
        }

        return mv;
    }

    // 점주 > 상점 삭제
    @PostMapping("/delete")
    public String deleteStore(
            @RequestParam int storeId,
            HttpSession sess,
            RedirectAttributes redirectAttributes
    ) {
        // 서비스 : 상점 삭제
        ownerStoreService.deleteStore(storeId);
        // 알럿
        redirectAttributes.addFlashAttribute("msg", "상점이 삭제되었습니다.");
        return "redirect:/owner/store";
    }




}
