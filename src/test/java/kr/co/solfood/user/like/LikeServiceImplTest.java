package kr.co.solfood.user.like;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class LikeServiceImplTest {

    @InjectMocks
    private LikeServiceImpl likeService;

    @Mock
    private LikeMapper likeMapper;

    @Test
    void 찜추가() {
        // Given
        int usersId = 1;
        int storeId = 100;

        // likeMapper.addLike(usersId, storeId)가 1을 반환하도록 Mock 세팅
        when(likeMapper.existLike(usersId, storeId)).thenReturn(0); // 중복 없음
        when(likeMapper.addLike(usersId, storeId)).thenReturn(1);    // insert 성공

        // When
        boolean result = likeService.addLike(usersId, storeId);

        // Then
        assertTrue(result, "찜 추가가 실패했습니다.");
    }

    @Test
    void cancelLike() {
        // Given
        int usersId = 1;
        int storeId = 100;

        when(likeMapper.cancelLike(usersId, storeId)).thenReturn(1); // delete 성공

        // When
        boolean result = likeService.cancelLike(usersId, storeId);

        // Then
        assertTrue(result, "찜 취소가 실패했습니다.");
    }
}
