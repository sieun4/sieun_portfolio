package com.iot.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import com.iot.dto.FreeBoard;
import com.iot.dto.Attachment;
import com.iot.dto.Comments;
import com.iot.service.AttachmentService;
import com.iot.service.CommentsService;
import com.iot.service.FreeBoardService;
import com.iot.service.TagService;
import com.iot.util.FileUtil;

@Controller
public class FreeBoardController {
	
	private Logger log = Logger.getLogger(FreeBoardController.class);

	@Autowired
	FreeBoardService service;
	
	@Autowired
	AttachmentService aService;
	
	@Autowired
	CommentsService cService;
	
	@Autowired
	TagService tService;
	
	@Autowired
	FileUtil fileUtil;
	
	@RequestMapping("/free/list.do")	// 자유게시판 리스트
	public ModelAndView list(@RequestParam HashMap<String, String> params, HttpSession session) {
		log.debug("/free/list.do - params : " + params);
		
		// jsp에서 보낸 파라미터를 HashMap으로 받음
		// jsp에서 값을 보내지 않으면 currentPageNo의 if문이 실행되지 않음
		// 검색 기능을 사용했을 경우 DAO로 보낼 파라미터
		HashMap<String, Object> p = new HashMap<String, Object>();
		p.put("searchType", params.get("searchType"));
		p.put("searchText", params.get("searchText"));

		int totalArticle = service.count(p);	// 총 게시글 수
		int pageArticle = 10;					// 한 페이지에 보여줄 게시글 수
		int currentPageNo = 1;					// jsp에서 값을 받지 않았을 때의 현재페이지 기본 설정
		if(params.containsKey("currentPageNo"))
			currentPageNo = Integer.parseInt(params.get("currentPageNo").trim());

		// 총 페이지 수 = 총 게시글 수 / 한 페이지 게시글 수 (나머지가 0이 아닐 경우 +1)
		int totalPage = totalArticle / pageArticle;
		totalPage = (totalArticle % pageArticle == 0) ? totalPage : totalPage + 1;

		int startArticleNo = (currentPageNo - 1) * pageArticle;	// 시작글 번호

		int pageBlockSize = 10;	
		// 시작 = (현재-1) / 블럭수 * 블럭수 + 1
		int pageBlockStart = (currentPageNo - 1) / pageBlockSize * pageBlockSize + 1;	
		// 종료 = (현재-1) / 블럭수 * 블럭수 + 블럭수
		int pageBlockEnd = (currentPageNo - 1) / pageBlockSize * pageBlockSize + pageBlockSize;	
		// 종료값이 총페이지수보다 크거나 같으면 총페이지수
		pageBlockEnd = (pageBlockEnd >= totalPage) ? totalPage : pageBlockEnd; 

		// 페이지별로 불러 올 게시글 정보를 불러오기 위해 DAO로 보낼 파라미터
		p.put("startArticleNo", startArticleNo);
		p.put("pageArticle", pageArticle);

		ArrayList<FreeBoard> result = service.paging(p);

		ModelAndView mv = new ModelAndView();
		mv.addObject("result", result);
		mv.addObject("totalArticle", totalArticle);
		mv.addObject("totalPage", totalPage);
		mv.addObject("currentPageNo", currentPageNo);	
		mv.addObject("pageBlockSize", pageBlockSize);
		mv.addObject("pageBlockStart", pageBlockStart);
		mv.addObject("pageBlockEnd", pageBlockEnd);
		mv.addObject("searchType", params.get("searchType"));
		mv.addObject("searchText", params.get("searchText"));
		mv.setViewName("/free/list");
		return mv;
	}
	
	@RequestMapping("/free/read.do")
	public ModelAndView read(@RequestParam HashMap<String, String> params) {
		log.debug("/free/read.do - params : " + params);

		ModelAndView mv = new ModelAndView();

		// 글번호
		int seq = Integer.parseInt(params.get("seq"));

		// 특정 게시글 / 첨부 파일 / 댓글 DTO
		FreeBoard board = null;
		ArrayList<Attachment> att = null;
		ArrayList<Comments> c = null;
		try {
			// 게시글 1건 조회 & 조회된 글 조회수 +1
			board = service.read(seq);
			// 파일이 존재한다면(1) 파일 가져오기
			if(board.getHasFile().equals("1")) 			
				att = aService.getAttachment("free", board.getSeq());	
			// 댓글이 존재한다면(1이상) 댓글 가져오기
			if(board.getHasComment() > 0) {
				c = cService.getComment(seq);;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.addObject("currentPageNo", params.get("currentPageNo"));
		mv.addObject("msg", params.get("msg"));
		mv.addObject("board", board);				// 게시글 정보 보내기
		mv.addObject("att", att);					// 첨부파일 보내기
		mv.addObject("c", c);						// 댓글 보내기
		mv.setViewName("free/read");
		return mv;
	}
	
	@RequestMapping("/free/goWrite.do")		// 글쓰기 버튼을 눌렀을 때 보여주는 글쓰기 창
	public ModelAndView goWrite(@RequestParam HashMap<String, String> params, HttpSession session) {
		log.debug("/free/goWrite.do - params : " + params);

		ModelAndView mv = new ModelAndView();

		if (session.getAttribute("userId") == null) { 	// 로그인 안 한 경우	
			mv.setViewName("error/error");
			mv.addObject("nextLocation", "/goLogin.do");
			mv.addObject("msg", "로그인 후 이용해 주세요 :)");
			return mv;
		}
		
		mv.addObject("currentPageNo", params.get("currentPageNo"));		// 글쓰기 취소 했을 때를 위해 현재 페이지 값 넘기기
		mv.setViewName("free/write");
		return mv;
	}
	
	@RequestMapping("/free/doWrite.do")		// 글 작성 후 완료 버튼 눌렀을 때 (글 저장)
	public ModelAndView doWrite(@RequestParam HashMap<String, String> params, 
			HttpSession session, MultipartHttpServletRequest mReq) {
		log.debug("/free/doWrite.do - params : " + params);

		ModelAndView mv = new ModelAndView();
		if (session.getAttribute("userId") == null) { 	// 로그인 안 한 경우	
			RedirectView rv = new RedirectView("/new_web/goLogin.do");
			mv.addObject("msg", "로그인 후 이용해 주세요 :)");
			mv.setView(rv);
			return mv;
		}

		List<MultipartFile> files = mReq.getFiles("file");	// 첨부파일 받아오기
		String hasFile = "0";
		for(MultipartFile  f : files) {
			hasFile = (f.isEmpty()) ? "0" : "1";	// 첨부파일이 있는 경우 hasFile에 1입력
			if(hasFile.equals("1")) break;
		}

		// FreeBoard DTO에 입력값 넣기
		FreeBoard board = new FreeBoard();
		board.setUserId(String.valueOf(session.getAttribute("userId")));
		board.setNickname(String.valueOf(session.getAttribute("nickname")));
		board.setTitle(params.get("title"));
		board.setHasFile(hasFile);
		// contents(글내용)은 수정해서 넣어주기
		String contents = params.get("contents");
		contents = contents.replaceAll("\r\n", "<br>");		// 줄 바꿈 변환
		board.setContents(contents);

		try {	
			service.write(board, files);			
		} catch(Exception e) {
			e.printStackTrace();			// 오류나면 service에서 보낸 문구를 콘솔에 출력
			mv.setViewName("free/write");
			mv.addObject("msg", "<font color=red><b>글을 등록하는 중 오류가 발생했습니다.</b></font>");
			mv.addObject("currentPageNo", params.get("currentPageNo"));
			return mv;
		}

		// 정상적으로 등록 되었을 땐 list로
		RedirectView rv = new RedirectView("/new_web/free/list.do");
		mv.setView(rv);		// setView는 controller / setViewName은 화면을 보기 위한 jsp로
		return mv;
	}
	
	@RequestMapping("/free/delete.do")		// 글 삭제
	public ModelAndView delete(@RequestParam HashMap<String, String> params, HttpSession session) {
		log.debug("/free/delete.do - params : " + params);
		ModelAndView mv = new ModelAndView();

		if (session.getAttribute("userId") == null) { 	// 로그인 안 한 경우	
			RedirectView rv = new RedirectView("/new_web/goLogin.do");
			mv.addObject("msg", "로그인 후 이용해 주세요 :)");
			mv.setView(rv);
			return mv;
		}

		String userId = String.valueOf(session.getAttribute("userId"));
		String password = params.get("password");
		int seq = Integer.parseInt(params.get("seq"));

		try {						// delete메서드 수행
			service.delete(seq, userId, password);
		} catch(Exception e) {		// 비밀번호가 맞지 않으면 다시 read.do로
			String url = "/new_web/free/read.do?seq=" + params.get("seq");
			url += "&currentPageNo=" + params.get("currentPageNo");
			RedirectView rv = new RedirectView(url);
			String msg = "";
			switch(e.getMessage()) {
			case "DELETE_ANOMALY":
				msg = "<font color=red><b>삭제 중 오류가 발생했습니다.</b></font>";
				break;
			case "NOT_EQ_PASSWORD":
				msg = "<font color=red><b>비밀번호가 일치하지 않습니다.</b></font>";
				break;
			}
			mv.addObject("msg", msg);
			mv.setView(rv);
			return mv;
		}
		// 삭제 후 리스트 URL 호출
		RedirectView rv = new RedirectView("/new_web/free/list.do");
		mv.setView(rv);
		return mv;
	}
	
	@RequestMapping("/free/goUpdate.do")	// 글 수정하기 화면으로
	public ModelAndView goUpdate(@RequestParam HashMap<String, String> params, HttpSession session) {
		log.debug("/free/goUpdate.do - params : " + params);
		ModelAndView mv = new ModelAndView();

		if (session.getAttribute("userId") == null) { 	// 로그인 안 한 경우	
			RedirectView rv = new RedirectView("/new_web/goLogin.do");
			mv.setView(rv);

			mv.addObject("msg", "로그인 후 이용해 주세요 :)");
			return mv;
		}
		
		// 수정 화면에서 첨부 파일 삭제 후 다시 비밀번호를 입력하지 않고 수정 화면으로 돌아오기 위해
		String pass = "";
		if(params.containsKey("pass")) pass = params.get("pass");

		String userId = String.valueOf(session.getAttribute("userId"));
		String password = params.get("password");
		int seq = Integer.parseInt(params.get("seq"));
		
		FreeBoard board  = null;
		ArrayList<Attachment> att = null;
		try {
			board = service.goUpDate(seq, userId, password, pass);			// 글 불러오기
			String contents = board.getContents();
			contents = contents.replaceAll("(?i)<br */?>", "\r\n");		// 줄 바꿈 변환
			board.setContents(contents);
			if(board.getHasFile().equals("1")) 			// 파일이 존재한다면 1
				att = aService.getAttachment("free", board.getSeq());	// 파일 가져오기				

		} catch(Exception e) {	// 비밀번호가 맞지 않으면 다시 read.do로
			String url = "/new_web/free/read.do?seq=" + params.get("seq");
			url += "&currentPageNo=" + params.get("currentPageNo");
			RedirectView rv = new RedirectView(url);
			mv.addObject("msg", "<font color=red><b>비밀번호가 일치하지 않습니다.</b></font>");
			mv.setView(rv);
			return mv;
		}
		mv.addObject("board", board);								// 수정할 Board 데이터 넘겨주기
		mv.addObject("att", att);									// 첨부파일 보내기
		mv.addObject("currentPageNo", params.get("currentPageNo"));	// 현재페이지 값 넘겨주기
		mv.setViewName("free/update");								// update.jsp 호출
		return mv;
	}
	
	@RequestMapping("/free/doUpdate.do")	// 수정 완료한 글 저장
	public ModelAndView doUpdate(@RequestParam HashMap<String, String> params, 
			HttpSession session, MultipartHttpServletRequest mReq) {
		log.debug("/free/doUpdate.do - params : " + params);
		ModelAndView mv = new ModelAndView();

		if (session.getAttribute("userId") == null) { 	// 로그인 안 한 경우	
			RedirectView rv = new RedirectView("/new_web/goLogin.do");
			mv.addObject("msg", "로그인 후 이용해 주세요 :)");
			mv.setView(rv);
			return mv;
		}
		int seq = Integer.parseInt(params.get("seq"));
		FreeBoard board = service.findBySeq(seq);			// 원래 글 정보 가져오기

		List<MultipartFile> files = null;
		if(board.getHasFile().equals("0")) {			
			files = mReq.getFiles("file");
			String hasFile = "0";
			for(MultipartFile  f : files) {
				hasFile = (f.isEmpty()) ? "0" : "1";		// 첨부파일이 있는 경우 hasFile에 1입력
				if(hasFile.equals("1")) break;
			}
			board.setHasFile(hasFile);
		}

		board.setTitle(params.get("title"));				// 바뀐 글 정보 입력하기
		// contents(글내용)은 수정해서 넣어주기
		String contents = params.get("contents");
		contents = contents.replaceAll("\r\n", "<br>");		// 줄 바꿈 변환
		board.setContents(contents);

		try {								// update 실행
			service.update(board, files);
		} catch(Exception e) {
			e.printStackTrace();			// 오류나면 service에서 보낸 문구를 콘솔에 출력
			mv.addObject("board", board);
			mv.addObject("msg", "<font color=red><b>글을 수정하는 중 오류가 발생했습니다.</b></font>");
			mv.setViewName("free/update");
			return mv;
		}
		RedirectView rv = new RedirectView("/new_web/free/read.do");
		mv.addObject("currentPageNo", params.get("currentPageNo"));
		mv.addObject("seq", params.get("seq"));
		mv.setView(rv);		// setView는 controller로 / setViewName은 화면을 보기 위한 jsp로
		return mv;
	}
	
	@RequestMapping("/free/writeComment.do")	// 댓글 쓰기
	public ModelAndView writeComment(HttpSession session, @RequestParam HashMap<String, String> params) {
		log.debug("/free/writeComment.do - params : " + params);
		ModelAndView mv = new ModelAndView();

		if (session.getAttribute("userId") == null) { 	// 로그인 안 한 경우	
			mv.setViewName("error/error");
			mv.addObject("nextLocation", "/goLogin.do");
			mv.addObject("msg", "로그인 후 이용해 주세요 :)");
			return mv;
		}
		
		mv.addObject("currentPageNo", params.get("currentPageNo"));
		mv.addObject("seq", Integer.parseInt(params.get("seq")));

		// 댓글 정보 DTO에 저장하기
		Comments c = new Comments();					
		c.setCommentDocSeq(Integer.parseInt(params.get("seq")));
		// comment(덧글내용)은 수정해서 넣어주기
		String comment = params.get("comment");
		comment = comment.replaceAll("\r\n", "<br>");				// 줄 바꿈 변환
		c.setComment(comment);
		c.setUserId(String.valueOf(session.getAttribute("userId")));
		c.setNickname(String.valueOf(session.getAttribute("nickname")));

		try {
			cService.write(c);			
		} catch(Exception e) {
			e.printStackTrace();			// 오류나면 service에서 보낸 문구를 콘솔에 출력
			mv.addObject("msg", "<font color=red><b>댓글을 등록하는 중 오류가 발생했습니다.</b></font>");
		}

		// 정상적으로 등록 되었을 땐 글읽기 페이지로
		RedirectView rv = new RedirectView("/new_web/free/read.do");
		mv.setView(rv);		// setView는 controller / setViewName은 화면을 보기 위한 jsp로
		return mv;
	}
	
	@RequestMapping("/free/fileDownload.do")	// 글 읽기 화면에서 첨부파일 다운 받기
	@ResponseBody
	public byte[] fileDownload(@RequestParam HashMap<String, String> params, HttpServletResponse rep) {
		log.debug("/free/fileDownload.do - params : " + params);

		// 첨부파일 seq 꺼내기
		int attachSeq = Integer.parseInt(params.get("attachSeq"));
		// seq 해당하는 첨부파일 1건 가져오기
		Attachment att = aService.download(attachSeq);
		// response에 정보 입력하는 fUtil.download 메서드 호출해서 return
		return fileUtil.download(att, rep);
	}
	
	@RequestMapping("/free/delAttach.do")	// 첨부파일 삭제
	public ModelAndView delAttach(@RequestParam HashMap<String, String> params, HttpSession session) {
		log.debug("/free/delAttach.do - params : " + params);
		ModelAndView mv = new ModelAndView();
		
		if (session.getAttribute("userId") == null) { 	// 로그인 안 한 경우	
			mv.setViewName("error/error");
			mv.addObject("nextLocation", "/goLogin.do");
			mv.addObject("msg", "로그인 후 이용해 주세요 :)");
			return mv;
		}
		
		int attachSeq = Integer.parseInt(params.get("attachSeq"));
		try {
			int seq = service.delAttachedFile(attachSeq);
			mv.addObject("seq", seq);
			mv.addObject("currentPageNo", params.get("currentPageNo"));
			mv.addObject("pass", true);	// 글 수정 화면으로 돌아갈 때 비밀 번호를 재입력 하지 않기 위해서
			RedirectView rv = new RedirectView("/new_web/free/goUpdate.do");
			mv.setView(rv);		// 삭제 후 글 수정 화면으로 돌아가기
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	@RequestMapping("/free/delComment.do")		// 댓글 삭제
	public ModelAndView delComment(HttpSession session, @RequestParam HashMap<String, String> params) {
		log.debug("/free/delComment.do - params : " + params);
		ModelAndView mv = new ModelAndView();
		
		if (session.getAttribute("userId") == null) { 	// 로그인 안 한 경우	
			mv.setViewName("error/error");
			mv.addObject("nextLocation", "/goLogin.do");
			mv.addObject("msg", "로그인 후 이용해 주세요 :)");
			return mv;
		}
		
		int seq = Integer.parseInt(params.get("seq"));
		int commentSeq = Integer.parseInt(params.get("commentSeq"));
		try {
			cService.delete(commentSeq, seq);
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.addObject("currentPageNo", params.get("currentPageNo"));
		mv.addObject("seq", Integer.parseInt(params.get("seq")));
		RedirectView rv = new RedirectView("/new_web/free/read.do");
		mv.setView(rv);
		return mv;
	}
}