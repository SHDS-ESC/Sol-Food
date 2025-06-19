package kr.co.solfood.user.store;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class StoreController {
    @Autowired
    private StoreService service;
    
    @Autowired
    private CategoryProperties categoryProperties;

    //전체 가게 목록 조회
    @GetMapping("/store")
    public void getAllStore(Model model) {
        List<StoreVO> storeList = service.getAllStore();
        model.addAttribute("store", storeList);
    }

    //카테고리별 목록 조회
    @GetMapping("/store/category/{category}")
    public String getCategoryStore(@PathVariable String category, Model model){
        List<StoreVO> categoryStoreList = service.getCategoryStore(category);
        model.addAttribute("store", categoryStoreList);
        model.addAttribute("currentCategory", category);
        return "/user/store";
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
