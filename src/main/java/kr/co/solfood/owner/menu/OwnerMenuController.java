package kr.co.solfood.owner.menu;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/owner/menu")
public class OwnerMenuController {

    // 점주 > 메뉴 관리 페이지
    @GetMapping()
    public void menu() {}

    @GetMapping("/add")
    public String addMenu() {
        return "owner/addMenu"; // 정확한 경로를 명시
    }
}
