package kr.co.solfood.admin.home;

import config.MvcConfig;
import kr.co.solfood.admin.dto.OwnerSearchDTO;
import kr.co.solfood.admin.dto.StoreStatusUpdateDTO;
import kr.co.solfood.admin.dto.UserSearchRequestDTO;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = {MvcConfig.class})
@WebAppConfiguration
@Slf4j
@Transactional
class AdminMapperTest {

    private final AdminMapper adminMapper;

    @Autowired
    AdminMapperTest(AdminMapper adminMapper) {
        this.adminMapper = adminMapper;
    }

    @Test
    @DisplayName("유저 검색 결과 검증 테스트")
    void getUsers() {
        // Given
        UserSearchRequestDTO userSearchRequestDTO = new UserSearchRequestDTO();
        userSearchRequestDTO.setQuery("testUser");

        // When
        var users = adminMapper.getUsers(userSearchRequestDTO);

        // Then
        assertNotNull(users);
        assertTrue(users.isEmpty()); // Assuming no users match "testUser"
    }

    @Test
    @DisplayName("유저 검색 결과 카운트 검증 테스트")
    void getUsersCount() {
        // Given
        UserSearchRequestDTO userSearchRequestDTO = new UserSearchRequestDTO();
        userSearchRequestDTO.setQuery("");

        // When
        int count = adminMapper.getUsersCount(userSearchRequestDTO);

        // Then
        assertTrue(count >= 0, "카운트는 0 이상이어야 합니다.");
    }

    @Test
    @DisplayName("유저 상태 업데이트 검증 테스트")
    void userManagementChartByYears() {
        var chartData = adminMapper.userManagementChartByYears();
        assertNotNull(chartData);
    }

    @Test
    @DisplayName("유저 상태 업데이트 검증 테스트")
    void userManagementChartByMonths() {
        var chartData = adminMapper.userManagementChartByMonths();
        assertNotNull(chartData);
    }

    @Test
    @DisplayName("유저 상태 업데이트 검증 테스트")
    void userManagementChartByDays() {
        var chartData = adminMapper.userManagementChartByDays();
        assertNotNull(chartData);
    }

    @Test
    @DisplayName("점주 검색 결과 검증 테스트")
    void getOwners() {
        // Given
        OwnerSearchDTO ownerSearchRequestDTO = new OwnerSearchDTO();
        ownerSearchRequestDTO.setQuery("testOwner");

        // When
        var owners = adminMapper.getOwners(ownerSearchRequestDTO);

        // Then
        assertNotNull(owners);
        assertTrue(owners.isEmpty()); // Assuming no owners match "testOwner"
    }

    @Test
    @DisplayName("점주 검색 결과 카운트 검증 테스트")
    void getOwnersCount() {
        // Given
        OwnerSearchDTO ownerSearchRequestDTO = new OwnerSearchDTO();
        ownerSearchRequestDTO.setQuery("");

        // When
        int count = adminMapper.getOwnersCount(ownerSearchRequestDTO);

        // Then
        assertTrue(count >= 0, "카운트는 0 이상이어야 합니다.");
    }

    @Test
    @DisplayName("점주 상태 업데이트 검증 테스트")
    void updateStoreStatus() {
        // Given
        StoreStatusUpdateDTO storeStatusUpdateDTO = new StoreStatusUpdateDTO(1L, "승인완료");

        // When
        int updatedCount = adminMapper.updateStoreStatus(storeStatusUpdateDTO);

        // Then
        assertEquals(1, updatedCount); // Assuming no owners exist with ID 1
    }
}