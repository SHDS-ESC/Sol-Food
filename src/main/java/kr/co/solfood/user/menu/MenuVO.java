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
     * @param selectedOptions 선택된 옵션들 (JSON 문자열) 예: {"사이즈": "대", "토핑": ["치즈", "계란"]}
     * @return 추가 가격
     */
    public int calculateExtraPrice(String selectedOptions) {
        if (selectedOptions == null || selectedOptions.trim().isEmpty()) {
            return 0;
        }
        try {
            Map<String, Object> selected = objectMapper.readValue(selectedOptions, new TypeReference<Map<String, Object>>() {});
            List<Map<String, Object>> optionGroups = objectMapper.readValue(menuExtra, new TypeReference<List<Map<String, Object>>>() {});
            int totalExtra = 0;
            for (Map.Entry<String, Object> selectedEntry : selected.entrySet()) {
                String groupName = selectedEntry.getKey().replaceAll("\\s+", "").toLowerCase().trim();
                Object selectedValue = selectedEntry.getValue();
                for (Map<String, Object> group : optionGroups) {
                    String groupNameDb = ((String) group.get("groupName")).replaceAll("\\s+", "").toLowerCase().trim();
                    if (groupName.equals(groupNameDb)) {
                        List<Map<String, Object>> choices = (List<Map<String, Object>>) group.get("options");
                        if (choices != null) {
                            if (selectedValue instanceof String) {
                                String selectedStr = ((String) selectedValue).replaceAll("\\s+", "").toLowerCase().trim();
                                for (Map<String, Object> choice : choices) {
                                    String value = ((String) choice.get("name")).replaceAll("\\s+", "").toLowerCase().trim();
                                    if (value.equals(selectedStr)) {
                                        Object priceObj = choice.get("price");
                                        if (priceObj instanceof Number) {
                                            totalExtra += ((Number) priceObj).intValue();
                                        }
                                    }
                                }
                            } else if (selectedValue instanceof java.util.List) {
                                for (Object sel : (java.util.List<?>) selectedValue) {
                                    String selectedStr = sel.toString().replaceAll("\\s+", "").toLowerCase().trim();
                                    for (Map<String, Object> choice : choices) {
                                        String value = ((String) choice.get("name")).replaceAll("\\s+", "").toLowerCase().trim();
                                        if (value.equals(selectedStr)) {
                                            Object priceObj = choice.get("price");
                                            if (priceObj instanceof Number) {
                                                totalExtra += ((Number) priceObj).intValue();
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        break;
                    }
                }
            }
            return totalExtra;
        } catch (Exception e) {
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