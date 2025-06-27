package kr.co.solfood.owner.menu;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/owner/menu")
public class OwnerMenuController {

    // 점주 > 메뉴 관리 페이지
    @GetMapping()
    public void menu() {}

}
