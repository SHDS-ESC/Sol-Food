package kr.co.solfood.admin.dto;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
public enum SelectChartData {
    YEAR("연간"),
    MONTH("월간"),
    DAY("일간");

    private String date;
}
