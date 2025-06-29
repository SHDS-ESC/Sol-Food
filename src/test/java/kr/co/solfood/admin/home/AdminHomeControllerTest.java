package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.*;
import kr.co.solfood.util.PageMaker;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import java.util.ArrayList;
import java.util.List;
import static org.hamcrest.Matchers.*;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;


class AdminHomeControllerTest {
    private MockMvc adminMockMvc;
    private AdminHomeController adminHomeController;
    private AdminHomeService adminHomeService;
    private final int START_PAGE = 1;
    private final int PAGE_GROUP_AMOUNT = 10;

    @BeforeEach
    void setup() {
        adminHomeService = Mockito.mock(AdminHomeService.class);
        adminHomeController = new AdminHomeController(adminHomeService);
        adminMockMvc = MockMvcBuilders.standaloneSetup(adminHomeController).build();
    }

    @Test
    @DisplayName("admin/home GET 요청시 홈 화면 이동")
    void home() throws Exception {
        adminMockMvc.perform(get("/admin/home"))
                .andDo(print()) // 실제 응답 내용을 콘솔에 출력
                .andExpect(status().isOk())
                .andExpect(view().name("admin/home"));
    }

    @Test
    @DisplayName("admin/home/user-management GET 요청시 사용자 관리 페이지 확인")
    void userManagement() {
        // 요청 데이터 세팅
        UserSearchRequestDTO userSearchRequestDTO = new UserSearchRequestDTO();
        userSearchRequestDTO.setCurrentPage(START_PAGE);
        userSearchRequestDTO.setPageSize(PAGE_GROUP_AMOUNT);

        PageMaker<UserSearchResponseDTO> fakeResponse = new PageMaker<>(new ArrayList<>(), 1, 10, 1);

        // 서비스 리턴 값 지정
        when(adminHomeService.getUsers(Mockito.any(UserSearchRequestDTO.class)))
                .thenReturn(fakeResponse);

        // MockMvc를 사용하여 GET 요청 수행, Attribute 검증
        try {
            adminMockMvc.perform(get("/admin/home/user-management"))
                    .andDo(print())
                    .andExpect(status().isOk())
                    .andExpect(model().attribute("userList", allOf(
                            hasProperty("firstPage", is(1)),
                            hasProperty("lastPage", is(1)),
                            hasProperty("pageCount", is(1)),
                            hasProperty("curPage", is(1)),
                            hasProperty("limit", is(10)),
                            hasProperty("count", is(1L)),
                            hasProperty("totalPageCount", is(0)),
                            hasProperty("list", is(empty()))
                    )))
                    .andExpect(view().name("admin/user-management/home"));
        } catch (Exception e) {
            throw new RuntimeException("Error during user management test", e);
        }
    }

    @Test
    @DisplayName("GET 요청시 유저 검색 결과 확인")
    void getUsers() {
        // 요청 데이터 세팅
        UserSearchRequestDTO userSearchRequestDTO = new UserSearchRequestDTO();
        userSearchRequestDTO.setCurrentPage(START_PAGE);
        userSearchRequestDTO.setPageSize(PAGE_GROUP_AMOUNT);
        userSearchRequestDTO.setQuery("testUser");

        UserSearchResponseDTO userSearchResponseDTO = new UserSearchResponseDTO();
        userSearchResponseDTO.setUsersName("testUser");

        List<UserSearchResponseDTO> userList = new ArrayList<>();
        userList.add(userSearchResponseDTO);
        PageMaker<UserSearchResponseDTO> fakeResponse = new PageMaker<>(userList, 1, 10, 1);

        // 서비스 리턴 값 지정
        when(adminHomeService.getUsers(Mockito.any(UserSearchRequestDTO.class)))
                .thenReturn(fakeResponse);

        try {
            adminMockMvc.perform(get("/admin/home/user-management/search")
                            .param("currentPage", String.valueOf(START_PAGE))
                            .param("pageSize", String.valueOf(PAGE_GROUP_AMOUNT)))
                    .andDo(print())
                    .andExpect(status().isOk());

        } catch (Exception e) {
            throw new RuntimeException("Error during user search test", e);
        }
    }

    @Test
    @DisplayName("GET 요청시 차트 데이터 확인")
    void getChartData() {

        String date = "2025";

        List<ChartRequestDTO> fakeResponse = new ArrayList<>();
        ChartRequestDTO chartData = new ChartRequestDTO();
        chartData.setCreatedAt(2025);
        chartData.setUserCount(1);
        fakeResponse.add(chartData);

        // 서비스 리턴 값 지정
        when(adminHomeService.userManagementChart(date))
                .thenReturn(fakeResponse);

        try {
            adminMockMvc.perform(get("/admin/home/user-management/chart")
                            .param("date", "2025"))
                    .andDo(print())
                    .andExpect(status().isOk());
        } catch (Exception e) {
            throw new RuntimeException("Error during chart data test", e);
        }
    }

    @Test
    @DisplayName("GET 요청시 점주 관리 페이지 확인")
    void ownerManagement() {
        // 요청 데이터 세팅
        OwnerSearchDTO ownerSearchDTO = new OwnerSearchDTO();
        ownerSearchDTO.setCurrentPage(START_PAGE);
        ownerSearchDTO.setPageSize(PAGE_GROUP_AMOUNT);

        PageMaker<OwnerSearchResponseDTO> fakeResponse = new PageMaker<>(new ArrayList<>(), 1, 10, 1);

        // 서비스 리턴 값 지정
        when(adminHomeService.getOwners(Mockito.any(OwnerSearchDTO.class)))
                .thenReturn(fakeResponse);

        try {
            adminMockMvc.perform(get("/admin/home/owner-management"))
                    .andDo(print()) // 실제 응답 내용을 콘솔에 출력
                    .andExpect(status().isOk())
                    .andDo(print())
                    .andExpect(status().isOk())
                    .andExpect(model().attribute("ownerList", allOf(
                            hasProperty("firstPage", is(1)),
                            hasProperty("lastPage", is(1)),
                            hasProperty("pageCount", is(1)),
                            hasProperty("curPage", is(1)),
                            hasProperty("limit", is(10)),
                            hasProperty("count", is(1L)),
                            hasProperty("totalPageCount", is(0)),
                            hasProperty("list", is(empty()))
                    )))
                    .andExpect(view().name("admin/owner-management/home"));
        } catch (Exception e) {
            throw new RuntimeException("Error during owner management test", e);
        }
    }

    @Test
    @DisplayName("GET 요청시 점주 검색 결과 확인")
    void getOwners() {
        try {
            adminMockMvc.perform(get("/admin/home/owner-management/search")
                            .param("currentPage", "1")
                            .param("pageSize", "10"))
                    .andDo(print()) // 실제 응답 내용을 콘솔에 출력
                    .andExpect(status().isOk());
        } catch (Exception e) {
            throw new RuntimeException("Error during owner search test", e);
        }
    }

    @Test
    @DisplayName("GET 요청시 결제 관리 페이지 확인")
    void paymentManagement() {
        try {
            adminMockMvc.perform(get("/admin/home/payment-management"))
                    .andDo(print()) // 실제 응답 내용을 콘솔에 출력
                    .andExpect(status().isOk())
                    .andExpect(view().name("admin/payment-management/home"));
        } catch (Exception e) {
            throw new RuntimeException("Error during payment management test", e);
        }
    }

    @Test
    @DisplayName("GET 요청시 결제 검색 결과 확인")
    void ownerStatusUpdate() {
        try {
            adminMockMvc.perform(get("/admin/home/owner-management/status-update")
                            .param("ownerId", "1")
                            .param("status", "승인완료"))
                    .andDo(print()) // 실제 응답 내용을 콘솔에 출력
                    .andExpect(status().isOk())
                    .andExpect(content().string("admin/owner-management/home"));
        } catch (Exception e) {
            throw new RuntimeException("Error during owner status update test", e);
        }
    }
}