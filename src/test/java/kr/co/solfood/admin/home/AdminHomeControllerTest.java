package kr.co.solfood.admin.home;

import config.MvcConfig;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = {MvcConfig.class})
@WebAppConfiguration
@Transactional
class AdminHomeControllerTest {

    private MockMvc adminMockMvc;

    @BeforeEach
    void setup() {
        AdminHomeService adminHomeService = Mockito.mock(AdminHomeService.class);
        AdminHomeController adminHomeController = new AdminHomeController(adminHomeService);
        adminMockMvc = MockMvcBuilders.standaloneSetup(adminHomeController).build();
    }

    @Test
    @DisplayName("요청시 뷰 이름 확인")
    void home() throws Exception {
        adminMockMvc.perform(get("/admin/home"))
                .andDo(print()) // 실제 응답 내용을 콘솔에 출력
                .andExpect(status().isOk())
                .andExpect(view().name("admin/home"));
    }

    @Test
    @DisplayName("GET 요청시 뷰 이름 확인")
    void userManagement() {
        try {
            adminMockMvc.perform(get("/admin/home/user-management"))
                    .andDo(print()) // 실제 응답 내용을 콘솔에 출력
                    .andExpect(status().isOk())
                    .andExpect(view().name("admin/user-management/home"));
        } catch (Exception e) {
            throw new RuntimeException("Error during user management test", e);
        }
    }

    @Test
    @DisplayName("GET 요청시 유저 검색 결과 확인")
    void getUsers() {
        try {
            adminMockMvc.perform(get("/admin/home/user-management/search")
                            .param("currentPage", "1")
                            .param("pageSize", "10"))
                    .andDo(print()) // 실제 응답 내용을 콘솔에 출력
                    .andExpect(status().isOk());
        } catch (Exception e) {
            throw new RuntimeException("Error during user search test", e);
        }
    }

    @Test
    @DisplayName("GET 요청시 차트 데이터 확인")
    void getChartData() {
        try {
            adminMockMvc.perform(get("/admin/home/user-management/chart")
                            .param("date", "2023-10-01"))
                    .andDo(print()) // 실제 응답 내용을 콘솔에 출력
                    .andExpect(status().isOk());
        } catch (Exception e) {
            throw new RuntimeException("Error during chart data test", e);
        }
    }

    @Test
    @DisplayName("GET 요청시 점주 관리 페이지 확인")
    void ownerManagement() {
        try {
            adminMockMvc.perform(get("/admin/home/owner-management"))
                    .andDo(print()) // 실제 응답 내용을 콘솔에 출력
                    .andExpect(status().isOk())
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
                            .param("status", "active"))
                    .andDo(print()) // 실제 응답 내용을 콘솔에 출력
                    .andExpect(status().isOk())
                    .andExpect(content().string("admin/owner-management/home"));
        } catch (Exception e) {
            throw new RuntimeException("Error during owner status update test", e);
        }
    }
}