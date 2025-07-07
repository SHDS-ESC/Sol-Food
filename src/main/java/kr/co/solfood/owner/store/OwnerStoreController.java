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

@Slf4j
@Controller
@RequestMapping("/owner/store")
public class OwnerStoreController {

    @Autowired
    private OwnerStoreService ownerStoreService;

    // 점주 > 상점 관리 페이지 GET
    @GetMapping("")
    public String store(Model model, HttpSession sess) {
        // Optional로 세션에서 점주 정보 추출
        Optional<OwnerVO> ownerOpt = Optional.ofNullable((OwnerVO) sess.getAttribute("ownerLoginSession"));

        if (ownerOpt.isPresent()) {
            long ownerId = ownerOpt.get().getOwnerId();
            OwnerStoreVO store = ownerStoreService.getOwnerStore(ownerId);
            model.addAttribute("store", store);
            return "owner/store";
        }

        return "redirect:/owner/login"; // 로그인 안된 경우
    }

    // 점주 > 상점 등록 페이지 GET
    @GetMapping("/add")
    public String addStore(Model model, HttpSession sess) {
        List<OwnerCategoryVO> categoryList = ownerStoreService.getOwnerCategory();
        model.addAttribute("categoryList", categoryList);

        sess.setAttribute("s3InProgress", true);
        sess.setAttribute("uploadCount", 0);
        sess.setMaxInactiveInterval(30 * 60); // 30분 유지

        return "owner/addStore";
    }

    // 점주 > 상점 등록 페이지 POST
    @PostMapping("/add")
    public ModelAndView addStore(@ModelAttribute OwnerStoreVO req,
                                 HttpSession sess,
                                 ModelAndView mv,
                                 RedirectAttributes redirectAttrs) {

        Optional<OwnerVO> ownerOpt = Optional.ofNullable((OwnerVO) sess.getAttribute("ownerLoginSession"));

        if (ownerOpt.isPresent()) {
            req.setOwnerId(ownerOpt.get().getOwnerId());
            int result = ownerStoreService.insertStore(req);

            sess.removeAttribute("s3InProgress");
            sess.removeAttribute("uploadCount");

            if (result > 0) {
                redirectAttrs.addFlashAttribute("msg", "🍴상점이 등록되었습니다.🍽️");
                mv.setViewName("redirect:/owner/store");
            } else {
                log.error("상점 등록 실패");
                mv.addObject("store", req);
                redirectAttrs.addFlashAttribute("msg", "상점 등록에 실패했습니다.");
                mv.setViewName("owner/addStore");
            }
        } else {
            mv.setViewName("redirect:/owner/login");
        }

        return mv;
    }

    // 점주 > 상점 수정 페이지 GET
    @GetMapping("/edit")
    public String editStore(Model model, HttpSession sess) {
        Optional<OwnerVO> ownerOpt = Optional.ofNullable((OwnerVO) sess.getAttribute("ownerLoginSession"));

        if (ownerOpt.isPresent()) {
            OwnerStoreVO store = ownerStoreService.getOwnerStore(ownerOpt.get().getOwnerId());
            List<OwnerCategoryVO> categoryList = ownerStoreService.getOwnerCategory();

            model.addAttribute("store", store);
            model.addAttribute("categoryList", categoryList);

            sess.setAttribute("s3InProgress", true);
            sess.setAttribute("uploadCount", 0);
            sess.setMaxInactiveInterval(30 * 60);

            return "owner/editStore";
        }

        return "redirect:/owner/login";
    }

    // 점주 > 상점 수정 페이지 POST
    @PostMapping("/edit")
    public ModelAndView editStore(@ModelAttribute OwnerStoreVO req,
                                  HttpSession sess,
                                  ModelAndView mv,
                                  RedirectAttributes redirectAttrs) {

        Optional<OwnerVO> ownerOpt = Optional.ofNullable((OwnerVO) sess.getAttribute("ownerLoginSession"));

        if (ownerOpt.isPresent()) {
            req.setOwnerId(ownerOpt.get().getOwnerId());
            int result = ownerStoreService.updateStore(req);

            sess.removeAttribute("s3InProgress");
            sess.removeAttribute("uploadCount");

            if (result > 0) {
                redirectAttrs.addFlashAttribute("msg", "🍴 상점이 수정되었습니다.💌");
                mv.setViewName("redirect:/owner/store");
            } else {
                redirectAttrs.addFlashAttribute("msg", "상점 수정에 실패했습니다.");
                mv.addObject("store", req);
                mv.setViewName("owner/editStore");
            }
        } else {
            mv.setViewName("redirect:/owner/login");
        }

        return mv;
    }

    // 점주 > 상점 삭제
    @PostMapping("/delete")
    public String deleteStore(@RequestParam int storeId,
                              HttpSession sess,
                              RedirectAttributes redirectAttributes) {

        Optional<OwnerVO> ownerOpt = Optional.ofNullable((OwnerVO) sess.getAttribute("ownerLoginSession"));

        if (ownerOpt.isPresent()) {
            ownerStoreService.deleteStore(storeId);
            redirectAttributes.addFlashAttribute("msg", "상점이 삭제되었습니다.");
            return "redirect:/owner/store";
        }

        return "redirect:/owner/login";
    }

}
