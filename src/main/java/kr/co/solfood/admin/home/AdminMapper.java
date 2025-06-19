package kr.co.solfood.admin.home;

import kr.co.solfood.user.login.UserVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface AdminMapper {
    List<UserVO> getUsers(String query);
}
