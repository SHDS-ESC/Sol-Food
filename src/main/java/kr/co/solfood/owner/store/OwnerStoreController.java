package kr.co.solfood.owner.store;

import kr.co.solfood.owner.login.OwnerLoginService;
import kr.co.solfood.owner.login.OwnerVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import properties.KakaoProperties;
import properties.ServerProperties;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/owner/store")
public class OwnerStoreController {

    @Autowired
    private OwnerStoreService ownerStoreService;


    // 점주 > 상점 관리 페이지
    @GetMapping("")
    public String store(Model model, HttpSession sess) {
        // 점주 id 꺼내기
        OwnerVO owner = (OwnerVO) sess.getAttribute("ownerLoginSession");

        if(owner == null) {
            return "redirect:/owner/login"; // 로그인 안돼있으면 로그인페이지
        }

        int ownerId = owner.getOwnerId();

        // 점주 <-> 상점 조회
        OwnerStoreVO store  = ownerStoreService.getOwnerStore(ownerId);
        model.addAttribute("store", store);

        // 카테고리 리스트
        List<OwnerCategoryVO> categoryList = ownerStoreService.getOwnerCategory();
        model.addAttribute("categoryList",categoryList);

        return "owner/store";
    }

    // 점주 > 상점 등록
    @PostMapping("")
    @ResponseBody
    public ResponseEntity<?> store(Model model, OwnerStoreVO ownerStoreVO, HttpSession sess) {
        int result = ownerStoreService.insertStore(ownerStoreVO);
        System.out.println(ownerStoreVO);
        if(result == 1) {
            // 등록 성공 후, 방금 등록한 상점 정보 조회해서 리턴
            OwnerVO owner = (OwnerVO) sess.getAttribute("ownerLoginSession");
            OwnerStoreVO store = ownerStoreService.getOwnerStore(owner.getOwnerId());
            return ResponseEntity.ok(store);
        } else {
            System.out.println("실패");
            return ResponseEntity
                    .badRequest()
                    .body("{\"error\": \"상점 등록 실패\"}"); // ✅ JSON 형태로 실패 메시지 전달
        }
    }


}
