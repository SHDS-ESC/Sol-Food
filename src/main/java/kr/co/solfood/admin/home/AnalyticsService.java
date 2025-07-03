package kr.co.solfood.admin.home;

import com.google.analytics.data.v1beta.*;
import kr.co.solfood.admin.dto.DailyUsersDto;
import kr.co.solfood.admin.dto.ReportRowDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AnalyticsService {

    private final BetaAnalyticsDataClient gaClient;
    private final String ga4PropertyId;

    public List<ReportRowDto> getActiveUsersByCity(LocalDate from, LocalDate to) {
        RunReportRequest req = RunReportRequest.newBuilder()
                .setProperty("properties/" + ga4PropertyId)
                .addDimensions(Dimension.newBuilder().setName("city"))
                .addMetrics(Metric.newBuilder().setName("activeUsers"))
                .addDateRanges(DateRange.newBuilder()
                        .setStartDate(from.toString())
                        .setEndDate(to.toString()))
                .build();

        RunReportResponse res = gaClient.runReport(req);
        return res.getRowsList().stream()
                .map(r -> new ReportRowDto(
                        r.getDimensionValues(0).getValue(),
                        Long.parseLong(r.getMetricValues(0).getValue())))
                .collect(Collectors.toList());
    }

    /** 실시간 30분 activeUsers 예시 */
    public List<ReportRowDto> getRealtimeUsersByCountry() {
        RunRealtimeReportRequest req = RunRealtimeReportRequest.newBuilder()
                .setProperty("properties/" + ga4PropertyId)
                .addDimensions(Dimension.newBuilder().setName("country"))
                .addMetrics(Metric.newBuilder().setName("activeUsers"))
                .build();
        RunRealtimeReportResponse res = gaClient.runRealtimeReport(req);
        return res.getRowsList().stream()
                .map(r -> new ReportRowDto(
                        r.getDimensionValues(0).getValue(),
                        Long.parseLong(r.getMetricValues(0).getValue())))
                .collect(Collectors.toList());
    }

    /** 날짜별 totalUsers + 누적 합계 */
    public List<DailyUsersDto> getDailyTotalUsers(LocalDate from, LocalDate to) {

        RunReportRequest req = RunReportRequest.newBuilder()
                .setProperty("properties/" + ga4PropertyId)
                .addDimensions(Dimension.newBuilder().setName("date"))
                .addMetrics(Metric.newBuilder().setName("totalUsers"))
                .addDateRanges(DateRange.newBuilder()
                        .setStartDate(from.toString())
                        .setEndDate(to.toString()))
                .addOrderBys(OrderBy.newBuilder()                      // 날짜 오름차순
                        .setDimension(OrderBy.DimensionOrderBy.newBuilder()
                                .setDimensionName("date"))
                        .setDesc(false))
                .build();

        RunReportResponse res = gaClient.runReport(req);

        DateTimeFormatter fmt = DateTimeFormatter.BASIC_ISO_DATE; // yyyyMMdd
        long cumulative = 0;
        List<DailyUsersDto> list = new ArrayList<>();

        for (Row row : res.getRowsList()) {
            LocalDate date = LocalDate.parse(row.getDimensionValues(0).getValue(), fmt);
            long daily = Long.parseLong(row.getMetricValues(0).getValue());
            cumulative += daily;

            list.add(new DailyUsersDto(date, daily, cumulative));
        }
        return list;
    }

}
