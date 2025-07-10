package kr.co.solfood.user.comment;

import kr.co.solfood.common.constants.UrlConstants;
import kr.co.solfood.user.login.UserVO;
import lombok.extern.slf4j.Slf4j;
import oracle.jdbc.proxy.annotation.Post;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/user/comment")
public class CommentController {

    @Autowired
    private CommentService commentService;

    // 댓글 등록
    @PostMapping("/insert")
    @ResponseBody
    public Map<String,Object> insert(
            CommentVO vo,
            HttpSession sess
    ) {
        Map<String,Object> result = new HashMap<>();

        UserVO loginUser = (UserVO) sess.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);

        if(loginUser == null) {
            result.put("error", true);
            result.put("msg", "로그인이 필요합니다.");
            return result;
        }

        vo.setUsersId(loginUser.getUsersId());
        vo.setCommentStatus(1);

        int inserted =  commentService.insertComment(vo);

        if(inserted > 0) {
            result.put("success", true);
        } else {
            result.put("error", true);
            result.put("msg", "등록 실패");
        }

        return result;
    }

    // 댓글 조회
    @GetMapping("/list")
    @ResponseBody
    public List<CommentVO> getCommentList(
            @RequestParam int boardId
    ) {
        List<CommentVO> commentList = commentService.getCommentsByBoardId(boardId);

        log.info("{}commentList ==> ",commentList);
        return commentList;
    }

    // 댓글 삭제 
    @PostMapping("/delete")
    @ResponseBody
    public String deleteComment(@RequestParam int commentId){
        int result = commentService.deleteComment(commentId);
        return result == 1 ? "success" : "fail";
    }

}
