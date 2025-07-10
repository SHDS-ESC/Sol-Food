package kr.co.solfood.user.board;

import kr.co.solfood.admin.login.AdminVO;
import kr.co.solfood.common.constants.UrlConstants;
import kr.co.solfood.user.board.response.BoardListResponseVO;
import kr.co.solfood.user.login.UserVO;
import kr.co.solfood.user.store.response.StoreListResponseVO;
import kr.co.solfood.util.PageDTO;
import kr.co.solfood.util.PageMaker;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;


@Slf4j
@Controller
@RequestMapping("/user/board")
public class BoardController {
    
    @Autowired
    private BoardService boardService;

    // 게시글 목록 화면 get
    @GetMapping("/list")
    public String list() {
        return "user/board/list";
    }

    // 게시글 목록 리스트 get
    @GetMapping("/api/list")
    @ResponseBody
    public BoardListResponseVO list(
            ModelAndView mv,
            HttpSession sess,
            @RequestParam(value = "offset", defaultValue = "0") int offset,
            @RequestParam(value = "pageSize", defaultValue = "10") int pageSize
    ) {

        
        // 게시판 진행 세션 플래그 설정 (S3 업로드 보안용)
        sess.setAttribute("s3InProgress", true);
        sess.setAttribute("uploadCount", 0);
        sess.setMaxInactiveInterval(30 * 60); // 30분 후 만료

        
        PageDTO pageDTO = new PageDTO();
        pageDTO.setCurrentPage(offset / pageSize + 1);
        pageDTO.setPageSize(pageSize);

        PageMaker<BoardVO> pageMaker;

//        UserVO loginUser = (UserVO) sess.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        pageMaker = boardService.getBoardList(pageDTO);

        boolean hasNext = offset + pageSize <= pageMaker.getCount();

        return BoardListResponseVO.success(
                pageMaker.getList(),
                hasNext,
                offset,
                pageSize,
                pageMaker.getCount()
        );
    }


    // 게시글 수정 화면 get
    @GetMapping("/edit")
    public String boardEdit(@RequestParam int boardId,
                            HttpSession sess,
                            Model model) {

        UserVO loginUser = (UserVO) sess.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        if (loginUser == null) {
            return "redirect:/user/login"; // 비로그인 사용자는 로그인 페이지로
        }

        BoardVO vo = boardService.getBoardDetail(boardId);

        // 작성자 본인인지 검증
        if (vo == null || vo.getUsersId() != loginUser.getUsersId()) {
            return "redirect:/user/board/list"; // 본인 글이 아니면 리스트로
        }

        sess.setAttribute("s3InProgress", true);
        sess.setAttribute("uploadCount", 0);
        sess.setMaxInactiveInterval(30 * 60);

        model.addAttribute("board", vo);
        return "user/board/edit";
    }


    // 게시글 작성 화면 get
    @GetMapping("/add")
    public ModelAndView add(
            ModelAndView mv,
            HttpSession sess
    ){

        mv.setViewName("user/board/add");
        return mv;
    }

    // 게시글 수정 post
    @PostMapping("/edit")
    public ModelAndView edit(@ModelAttribute BoardVO req,
                             HttpSession sess,
                             ModelAndView mv) {
        UserVO loginUser = (UserVO) sess.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        if (loginUser == null) {
            mv.setViewName("redirect:/user/login");
            return mv;
        }

        req.setUsersId((int) loginUser.getUsersId());

        log.info("req:{}",req);

        if (req.getBoardImage() == null || req.getBoardImage().trim().isEmpty()) {
            // 기존 이미지 유지
            BoardVO origin = boardService.getBoardDetail(req.getBoardId());
            req.setBoardImage(origin.getBoardImage());
        }

        int result = boardService.updateBoard(req);

        sess.removeAttribute("s3InProgress");
        sess.removeAttribute("uploadCount");

        if (result == 1) {
            mv.setViewName("redirect:/user/board/detail?boardId=" + req.getBoardId());
        } else {
            mv.addObject("msg", "수정에 실패했습니다.");
            mv.setViewName("/user/board/edit");
        }

        return mv;
    }



    // 게시글 작성 처리 post
    @PostMapping("/add")
    public ModelAndView add(
            @ModelAttribute BoardVO req,
            ModelAndView mv,
            HttpSession sess
    ) {
        UserVO loginUser = (UserVO) sess.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        req.setUsersId((int) loginUser.getUsersId());
        int result = boardService.save(req);

        // 게시판 완료 후 세션 정리
        sess.removeAttribute("s3InProgress");
        sess.removeAttribute("uploadCount");

        if(result == 1) {
            mv.addObject("msg","성공");
            mv.setViewName("redirect:/user/board/list");
        }
        else {
            mv.addObject("msg","실패");
        }

        return mv;
    }

    // 게시글 상세 조회
    @GetMapping("/detail")
    public ModelAndView boardDetail(
            @RequestParam int boardId,
            ModelAndView mv,
            HttpSession sess
    ) {
        /*작성자*/
        UserVO loginUser = (UserVO) sess.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        AdminVO adminUser = (AdminVO) sess.getAttribute(UrlConstants.Session.ADMIN_LOGIN_SESSION);

        /* 서비스 : 조회수 */
        boardService.updateViewCount(boardId);

        /* 서비스 : 상세 조회 */
        BoardVO vo = boardService.getBoardDetail(boardId);
//        vo.setBoardWirter(loginUser.getUsersNickname());

//      /* 로그인 사용자와 작성자 비교 */
        boolean isAuthor = (loginUser != null &&  loginUser.getUsersId() == vo.getUsersId()) || adminUser != null;
        mv.addObject("isAuthor", isAuthor);
        mv.addObject("board", vo);
        log.info("boardboardboardboardboardboard vo:{}",vo);
        mv.setViewName("/user/board/detail");
        return mv;
    }

    // 게시글 삭제
    @PostMapping("/delete")
    public String delete(
            @RequestParam int boardId,
            RedirectAttributes redirectAttributes){
        boardService.deleteBoard(boardId);
        redirectAttributes.addFlashAttribute("msg","삭제되었습니다");
        return "redirect:/user/board/list";
    }




}
