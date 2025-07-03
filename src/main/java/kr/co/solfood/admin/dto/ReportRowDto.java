package kr.co.solfood.admin.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ReportRowDto {
    private String dimension;
    private long metric;
}
