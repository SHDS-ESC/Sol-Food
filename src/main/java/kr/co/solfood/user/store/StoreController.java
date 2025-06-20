package kr.co.solfood.user.store;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/user/store")
public class StoreController {
    @Autowired
    private StoreService service;

    @Autowired
    private CategoryProperties categoryProperties;

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

    //Ajax용 카테고리별 목록 조회 API
    @GetMapping("/api/store/category/{category}")
    @ResponseBody
    public ResponseEntity<List<StoreVO>> getCategoryStoreApi(@PathVariable String category) {
        try {
            List<StoreVO> storeList;
            if ("전체".equals(category)) {
                storeList = service.getAllStore();
            } else {
                storeList = service.getCategoryStore(category);
            }
            return ResponseEntity.ok(storeList);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().build();
        }
    }

    //카테고리 설정 정보 API (프론트엔드용)
    @GetMapping("/api/category/config")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCategoryConfig() {
        try {
            Map<String, Object> config = categoryProperties.getCategoryConfig();
            return ResponseEntity.ok(config);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().build();
        }
    }

}
