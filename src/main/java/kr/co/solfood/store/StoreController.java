package kr.co.solfood.store;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("user/store")
public class StoreController {
    @Autowired
    private StoreService service;

    //전체 가게 목록 조회
    @GetMapping("")
    public String getAllStore(Model model) {
        List<StoreVO> storeList = service.getAllStore();
        model.addAttribute("store", storeList);
        return "user/store";
    }

    //카테고리별 목록 조회


}
