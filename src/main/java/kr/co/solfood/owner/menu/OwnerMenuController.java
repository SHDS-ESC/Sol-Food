package kr.co.solfood.owner.menu;

import kr.co.solfood.owner.login.OwnerVO;
import kr.co.solfood.owner.store.OwnerStoreService;
import kr.co.solfood.owner.store.OwnerStoreVO;
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

@Slf4j
@Controller
@RequestMapping("/owner/menu")
public class OwnerMenuController {

    @Autowired
    private OwnerStoreService ownerStoreService;

    @Autowired
    private OwnerMenuService ownerMenuService;

    // 점주 > 메뉴 관리 페이지 GET
    @GetMapping()
    public String menu(HttpSession sess, Model model, RedirectAttributes redirectAttributes) {
        Optional<OwnerVO> ownerOpt = Optional.ofNullable((OwnerVO) sess.getAttribute("ownerLoginSession"));

        if (ownerOpt.isEmpty()) {
            return "redirect:/owner/login"; // 로그인 안되어있으면 로그인 페이지
        }

        OwnerStoreVO ownerStore = ownerStoreService.getOwnerStore(ownerOpt.get().getOwnerId());

        if (ownerStore == null) {
            redirectAttributes.addFlashAttribute("msg", "상점을 먼저 등록해 주세요.🙂");
            return "redirect:/owner/store";
        } else if (!"승인완료".equals(ownerStore.getStoreStatus())) {
            redirectAttributes.addFlashAttribute("msg", "승인 완료 후, 메뉴를 등록할 수 있습니다.🙂");
            return "redirect:/owner/store";
        }

        List<OwnerMenuVO> menu = ownerMenuService.selectMenu(ownerStore.getStoreId());
        log.info("{}", menu);
        model.addAttribute("menu", menu);

        return "owner/menu";
    }

    // 점주 > 메뉴 등록 페이지 GET
    @GetMapping("/add")
    public String addMenu(HttpSession sess) {
        sess.setAttribute("s3InProgress", true);
        sess.setAttribute("uploadCount", 0);
        sess.setMaxInactiveInterval(30 * 60); // 30분 만료
        return "owner/addMenu";
    }

    // 점주 > 메뉴 등록 POST
    @PostMapping("/add")
    public ModelAndView addMenu(HttpSession sess,
                                ModelAndView mv,
                                @ModelAttribute OwnerMenuVO req,
                                RedirectAttributes redirectAttributes) {

        Optional<OwnerVO> ownerOpt = Optional.ofNullable((OwnerVO) sess.getAttribute("ownerLoginSession"));

        if (ownerOpt.isEmpty()) {
            mv.setViewName("redirect:/owner/login");
            return mv;
        }

        OwnerStoreVO ownerStore = ownerStoreService.getOwnerStore(ownerOpt.get().getOwnerId());
        req.setStoreId(ownerStore.getStoreId());

        int result = ownerMenuService.insertMenu(req);

        sess.removeAttribute("s3InProgress");
        sess.removeAttribute("uploadCount");

        if (result > 0) {
            redirectAttributes.addFlashAttribute("msg", "메뉴 등록 성공");
            mv.setViewName("redirect:/owner/menu");
        } else {
            mv.addObject("menu", req);
            redirectAttributes.addFlashAttribute("msg", "메뉴 등록 실패");
            mv.setViewName("owner/addMenu");
        }

        return mv;
    }

    // 점주 > 메뉴 수정 페이지 GET
    @GetMapping("/edit")
    public String editMenu(Model model, @RequestParam int menuId, HttpSession sess) {
        sess.setAttribute("s3InProgress", true);
        sess.setAttribute("uploadCount", 0);
        sess.setMaxInactiveInterval(30 * 60);

        OwnerMenuVO menu = ownerMenuService.getMenuById(menuId);
        model.addAttribute("menu", menu);
        return "owner/editMenu";
    }

    // 점주 > 메뉴 수정 POST
    @PostMapping("/edit")
    public ModelAndView editMenu(@ModelAttribute OwnerMenuVO req,
                                 HttpSession sess,
                                 RedirectAttributes redirectAttributes,
                                 ModelAndView mv) {

        int result = ownerMenuService.updateMenu(req);

        sess.removeAttribute("s3InProgress");
        sess.removeAttribute("uploadCount");

        if (result > 0) {
            redirectAttributes.addFlashAttribute("msg", "🍴 메뉴가 수정되었습니다.💌");
            mv.setViewName("redirect:/owner/menu");
        } else {
            redirectAttributes.addFlashAttribute("msg", "메뉴 수정 실패");
            mv.addObject("menu", req);
            mv.setViewName("owner/editMenu");
        }

        return mv;
    }

    // 점주 > 메뉴 삭제
    @PostMapping("/delete")
    public String deleteMenu(@RequestParam int menuId, RedirectAttributes redirectAttributes) {
        ownerMenuService.deleteMenu(menuId);
        redirectAttributes.addFlashAttribute("msg", "메뉴가 삭제되었습니다.");
        return "redirect:/owner/menu";
    }
}
