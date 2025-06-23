package kr.co.solfood.admin.home;

import kr.co.solfood.user.login.UserVO;
import kr.co.solfood.user.store.CategoryProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminHomeController {

    private final AdminHomeService adminHomeService;
    
    @Autowired
    private CategoryProperties categoryProperties;

    AdminHomeController(AdminHomeService adminHomeService) {
        this.adminHomeService = adminHomeService;
    }

    @GetMapping("/home")
    public void home(Model model) {
    }

    @GetMapping("/home/user-management")
    public String userManagement(Model model) {
        return "admin/user-management/home";
    }

    @GetMapping("/home/user-management/search")
    public String userSearch(@RequestParam String query, Model model) {
        List<UserVO> userList = adminHomeService.getUsers(query);
        System.out.println(query);
        model.addAttribute("userList", userList);
        System.out.println("리스트" + userList);
        return "admin/user-management/home";
    }
    
    //카테고리 설정 정보 API (관리자용)
    @GetMapping("/api/category/config")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCategoryConfig() {
        Map<String, Object> config = categoryProperties.getCategoryConfig();
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", config);
        
        return ResponseEntity.ok(response);
    }

}
