package kr.co.solfood.owner.menu;

import kr.co.solfood.owner.login.OwnerVO;
import kr.co.solfood.owner.store.OwnerStoreService;
import kr.co.solfood.owner.store.OwnerStoreVO;
import lombok.extern.slf4j.Slf4j;
import oracle.jdbc.proxy.annotation.Post;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Optional;

@Slf4j
@Controller
@RequestMapping("/owner/menu")
public class OwnerMenuController {

    @Autowired
    private OwnerStoreService ownerStoreService;

    @Autowired
    private OwnerMenuService ownerMenuService;


    // 점주 > 메뉴 관리 페이지 get
    @GetMapping()
    public String menu(
            HttpSession sess,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        // 로그인 정보 가져오기
        OwnerVO owner = (OwnerVO) sess.getAttribute("ownerLoginSession");
        if(owner == null) {
            return "redirect:/owner/login"; // 로그인 안되어있으면 로그인페이지
        }
        OwnerStoreVO ownerStore = ownerStoreService.getOwnerStore(owner.getOwnerId());
        if(ownerStore == null) {
            redirectAttributes.addFlashAttribute("msg", "상점을 먼저 등록해 주세요.\uD83D\uDE42");
            return "redirect:/owner/store";
        } else if (!"승인완료".equals(ownerStore.getStoreStatus())) {
            redirectAttributes.addFlashAttribute("msg","승인 완료 후, 메뉴를 등록할 수 있습니다.\uD83D\uDE42");
            return "redirect:/owner/store";
        }

        // 서비스 : 점주 메뉴 조회
        List<OwnerMenuVO> menu = ownerMenuService.selectMenu(ownerStore.getStoreId());
        log.info("{}",menu);
        model.addAttribute("menu", menu);

        return "owner/menu";
    }

    // 점주 > 메뉴 등록 get
    @GetMapping("/add")
    public String addMenu(HttpSession sess) {

        // 메뉴 등록 진행 세션 플래그 설정 (S3 업로드 보안용)
        sess.setAttribute("s3InProgress", true);
        sess.setAttribute("uploadCount", 0);
        sess.setMaxInactiveInterval(30 * 60); // 30분 후 만료
        
        return "owner/addMenu"; // 정확한 경로를 명시
    }

    // 메뉴 등록 post
    @PostMapping("/add")
    public ModelAndView addMenu(
            HttpSession sess,
            ModelAndView mv,
            @ModelAttribute OwnerMenuVO req, // 폼에서 전달된 메뉴 정보 자동 매핑
            RedirectAttributes redirectAttributes
    ){
        Optional<OwnerVO> owner = Optional.ofNullable((OwnerVO) sess.getAttribute("ownerLoginSession"));
        if(owner.isPresent()) { // 세션에 점주가 있으면


            OwnerStoreVO ownerStore = ownerStoreService.getOwnerStore(owner.get().getOwnerId());
            req.setStoreId(ownerStore.getStoreId());

            System.out.println("ownerStore"+ownerStore);
            System.out.println("req"+req);

            // 서비스 : 메뉴 등록
            int result = ownerMenuService.insertMenu(req);
            boolean isAddMenu = result > 0;

            // 메뉴 등록 완료 후 세션 정리
            sess.removeAttribute("s3InProgress");
            sess.removeAttribute("uploadCount");

            if(isAddMenu){
                redirectAttributes.addFlashAttribute("msg", "메뉴 등록 성공");
                mv.setViewName("redirect:/owner/menu");
            }


        } else {
            mv.setViewName("redirect:/owner/login");

        }
        return mv;

    }

    // 메뉴 수정 get
    @GetMapping("/edit")
    public String editMenu(
            Model model,
            @RequestParam int menuId,
            HttpSession sess
    ) {

        // 메뉴 수정 진행 세션 플래그 설정 (S3 업로드 보안용)
        sess.setAttribute("s3InProgress", true);
        sess.setAttribute("uploadCount", 0);
        sess.setMaxInactiveInterval(30 * 60); // 30분 후 만료

        // 메뉴 단건 조회
        OwnerMenuVO menu = ownerMenuService.getMenuById(menuId);

        // menu 객체를 모델에 담음
        model.addAttribute("menu", menu);
        return "owner/editMenu";

    }

    // 메뉴 수정 post
    @PostMapping("/edit")
    public ModelAndView editMenu(
            @ModelAttribute OwnerMenuVO req,
            HttpSession sess,
            RedirectAttributes redirectAttributes,
            ModelAndView mv
    ){
        // 메뉴 수정
        int result =ownerMenuService.updateMenu(req);

        // 상점 수정 완료 후 세션 정리
        sess.removeAttribute("s3InProgress");
        sess.removeAttribute("uploadCount");

        if(result > 0){
            redirectAttributes.addFlashAttribute("msg", "\uD83C\uDF74 메뉴가 수정되었습니다.\uD83D\uDC8C");
            mv.setViewName("redirect:/owner/menu");
        } else {
            redirectAttributes.addFlashAttribute("msg", "메뉴 수정 실패");
            mv.addObject("menu",req);
            mv.setViewName("owner/editMenu");
        }

        return mv;
    }

    // 메뉴 삭제
    @PostMapping("/delete")
    public String deleteMenu(
            @RequestParam int menuId,
            RedirectAttributes redirectAttributes
    ){
        ownerMenuService.deleteMenu(menuId);
        redirectAttributes.addFlashAttribute("msg", "메뉴가 삭제되었습니다.");
        return "redirect:/owner/menu";
    }


}
