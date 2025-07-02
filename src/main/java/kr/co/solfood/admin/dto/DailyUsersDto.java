package kr.co.solfood.admin.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Getter;
import java.time.LocalDate;

@Getter
@AllArgsConstructor
public class DailyUsersDto {
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate date;
    private long daily;
    private long cumulative;
}

