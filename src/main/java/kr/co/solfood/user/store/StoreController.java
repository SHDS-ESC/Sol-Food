package kr.co.solfood.user.store;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/user/store")
public class StoreController {
    @Autowired
    private StoreService service;

    @GetMapping("")
    public String getStoreList(@RequestParam(value = "category", required = false) String category, Model model) {
        List<StoreVO> storeList;
        if (category == null) {
            storeList = service.getAllStore();
        } else {
            storeList = service.getCategoryStore(category);
            model.addAttribute("currentCategory", category);
        }
        model.addAttribute("store", storeList);
        return "user/store";
    }

}
