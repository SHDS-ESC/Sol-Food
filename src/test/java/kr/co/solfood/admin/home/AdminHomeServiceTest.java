package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.OwnerSearchDTO;
import kr.co.solfood.admin.dto.OwnerStatusUpdateDTO;
import kr.co.solfood.admin.dto.UserSearchRequestDTO;
import lombok.extern.log4j.Log4j;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;

/**
 * AdminHomeServiceTest
 * <p>
 * 관리자 홈 서비스 테스트 클래스
 * <p>
 * 이 클래스는 관리자 홈 서비스의 메서드들을 테스트합니다.
 */
@ExtendWith(MockitoExtension.class)
@Log4j
@Transactional
class AdminHomeServiceTest {
    @Mock
    private AdminMapper adminMapper;

    @InjectMocks
    private AdminHomeServiceImpl adminHomeService;

    @Test
    @DisplayName("유저 검색 결과 검증 테스트")
    void getUsers() {
        // Given
        String query = "testUser";

        UserSearchRequestDTO userSearchRequestDTO = new UserSearchRequestDTO();
        userSearchRequestDTO.setQuery(query);

        // When
        given(adminMapper.getUsers(any(UserSearchRequestDTO.class)))
                .willReturn(new ArrayList<>());

        given(adminMapper.getUsersCount(any(UserSearchRequestDTO.class)))
                .willReturn(1);

        // Then
        Assertions.assertDoesNotThrow(() -> adminHomeService.getUsers(userSearchRequestDTO));

        assertEquals(1, adminHomeService.getUsers(userSearchRequestDTO).getCount());
    }

    @Test
    @DisplayName("유저 관리 차트 데이터 검증 테스트")
    void userManagementChart() {
        // Given
        String date = "월간";

        // When
        given(adminMapper.userManagementChartByMonths())
                .willReturn(new ArrayList<>());

        // Then
        Assertions.assertDoesNotThrow(() -> adminHomeService.userManagementChart(date));

        assertTrue(adminHomeService.userManagementChart(date).isEmpty());
    }

    @Test
    @DisplayName("점주 검색 결과 검증 테스트")
    void getOwners() {
        // Given
        String query = "testOwner";

        OwnerSearchDTO ownerSearchRequestDTO = new OwnerSearchDTO();
        ownerSearchRequestDTO.setQuery(query);

        // When
        given(adminMapper.getOwners(any(OwnerSearchDTO.class)))
                .willReturn(new ArrayList<>());

        given(adminMapper.getOwnersCount(any(OwnerSearchDTO.class)))
                .willReturn(1);

        // Then
        Assertions.assertDoesNotThrow(() -> adminHomeService.getOwners(ownerSearchRequestDTO));

        assertEquals(1, adminHomeService.getOwners(ownerSearchRequestDTO).getCount());
    }

    /**
     * 승인완료, 승인거부, 승인대기 등 유효한 상태는
     * 예외 없이 정상 처리되어야 한다.
     */
    @ParameterizedTest
    @ValueSource(strings = {"승인완료", "승인대기", "승인거절"})
    @DisplayName("updateOwnerStatus - 유효한 상태 값은 예외 없이 처리되어야 한다.")
    void updateOwnerStatus_validStatuses_noException(String validStatus) {
        // given
        OwnerStatusUpdateDTO dto = new OwnerStatusUpdateDTO(1L, validStatus);
        given(adminMapper.updateOwnerStatus(any(OwnerStatusUpdateDTO.class)))
                .willReturn(1);  // DB 업데이트 성공 상황 시뮬레이션

        // then
        assertDoesNotThrow(() -> adminHomeService.updateOwnerStatus(dto));
    }

    /**
     * 잘못된 상태 값이 들어오면 IllegalArgumentException 을 던져야 한다.
     */
    @ParameterizedTest
    @ValueSource(strings = {"잘못된상태", "", "INVALID"})
    @DisplayName("updateOwnerStatus - 유효하지 않은 상태 값은 IllegalArgumentException 을 던져야 한다.")
    void updateOwnerStatus_invalidStatuses_throws(String invalidStatus) {
        // given
        OwnerStatusUpdateDTO dto = new OwnerStatusUpdateDTO(1L, invalidStatus);

        // then
        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> adminHomeService.updateOwnerStatus(dto)
        );

        assertEquals("유효하지 않은 ownerStatusUpdateDTO 입니다.", ex.getMessage());
    }
}