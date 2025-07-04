package kr.co.solfood.user.menu;

import lombok.Data;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Map;
import java.util.List;

@Data
public class MenuVO {
    private int menuId;           // menu_id
    private int storeId;          // store_id
    private String menuName;      // menu_name
    private int menuPrice;        // menu_price
    private String menuMainimage; // menu_mainimage
    private String menuIntro;     // menu_intro
    private String menuExtra;     // menu_extra - JSON 형태의 추가 옵션 정보
    
    private static final ObjectMapper objectMapper = new ObjectMapper();
    
    // 카테고리 매핑 상수
    private static final Map<String, String> CATEGORY_KEYWORDS = Map.of(
        "프리미엄", "프리미엄",
        "정식", "정식시리즈",
        "마요", "마요시리즈",
        "카레", "카레",
        "볶음밥", "볶음밥",
        "덮밥", "덮밥",
        "비빔밥", "비빔밥",
        "도시락", "도시락"
    );
    
    // 메뉴명을 기반으로 카테고리를 결정하는 메서드 (개선됨)
    public String getCategory() {
        if (menuName == null) return "기타";
        
        return CATEGORY_KEYWORDS.entrySet().stream()
            .filter(entry -> menuName.contains(entry.getKey()))
            .map(Map.Entry::getValue)
            .findFirst()
            .orElse("신메뉴");
    }
    
    /**
     * 메뉴 추가 옵션이 있는지 확인
     */
    public boolean hasExtraOptions() {
        return menuExtra != null && !menuExtra.trim().isEmpty() && !menuExtra.equals("{}");
    }
    
    /**
     * 메뉴 추가 옵션을 Map으로 파싱
     */
    public Map<String, Object> getExtraOptionsAsMap() {
        if (!hasExtraOptions()) {
            return Map.of();
        }
        
        try {
            return objectMapper.readValue(menuExtra, new TypeReference<Map<String, Object>>() {});
        } catch (JsonProcessingException e) {
            return Map.of();
        }
    }
    
    /**
     * 선택된 옵션들의 추가 가격 계산
     * @param selectedOptions 선택된 옵션들 (JSON 문자열) 예: {"사이즈": "대"}
     * @return 추가 가격
     */
    public int calculateExtraPrice(String selectedOptions) {
        if (selectedOptions == null || selectedOptions.trim().isEmpty()) {
            return 0;
        }
        
        try {
            Map<String, Object> extraOptionsMap = getExtraOptionsAsMap();
            Map<String, Object> selected = objectMapper.readValue(selectedOptions, new TypeReference<Map<String, Object>>() {});
            
            // menu_extra 구조: {"options":[{"name":"사이즈","choices":[{"value":"소","price":0},{"value":"대","price":1000}]}]}
            List<Map<String, Object>> options = (List<Map<String, Object>>) extraOptionsMap.get("options");
            if (options == null) {
                return 0;
            }
            
            int totalExtra = 0;
            
            // 선택된 옵션들을 순회
            for (Map.Entry<String, Object> selectedEntry : selected.entrySet()) {
                String optionName = selectedEntry.getKey(); // 예: "사이즈"
                Object selectedValue = selectedEntry.getValue(); // 예: "대"
                
                // menu_extra의 options에서 해당 이름의 옵션 찾기
                for (Map<String, Object> option : options) {
                    String name = (String) option.get("name");
                    if (optionName.equals(name)) {
                        List<Map<String, Object>> choices = (List<Map<String, Object>>) option.get("choices");
                        if (choices != null) {
                            for (Map<String, Object> choice : choices) {
                                if (isChoiceSelected(choice, selectedValue)) {
                                    Object priceObj = choice.get("price");
                                    if (priceObj instanceof Number) {
                                        totalExtra += ((Number) priceObj).intValue();
                                    }
                                }
                            }
                        }
                        break; // 해당 옵션을 찾았으므로 더 이상 검색하지 않음
                    }
                }
            }
            
            return totalExtra;
        } catch (JsonProcessingException e) {
            return 0;
        }
    }
    

    
    /**
     * 선택 항목이 선택되었는지 확인 (새로운 구조용)
     * 새로운 구조: {"value":"대","price":1000}
     */
    private boolean isChoiceSelected(Map<String, Object> choice, Object selectedValue) {
        Object choiceValue = choice.get("value");
        
        if (selectedValue instanceof List) {
            // 다중 선택인 경우 (예: ["치즈", "계란"])
            List<?> selectedList = (List<?>) selectedValue;
            return selectedList.contains(choiceValue);
        } else {
            // 단일 선택인 경우 (예: "대")
            return choiceValue != null && choiceValue.equals(selectedValue);
        }
    }
} 