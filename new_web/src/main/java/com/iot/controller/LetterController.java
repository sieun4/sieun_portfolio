package com.iot.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.iot.dto.FreeBoard;
import com.iot.dto.Friend;
import com.iot.dto.Letter;
import com.iot.service.FriendService;
import com.iot.service.LetterService;

@Controller
public class LetterController {

	private Logger log = Logger.getLogger(FreeBoardController.class);

	@Autowired
	LetterService service;

	@RequestMapping("/letter/goWrite.do")
	public ModelAndView goWrite(@RequestParam HashMap<String, String> params, HttpSession session) {
		log.debug("/letter/goWrite.do - params : " + params);

		ModelAndView mv = new ModelAndView();
		
		if (session.getAttribute("userId") == null) { 	// 로그인 안 한 경우	
			mv.setViewName("error/error");
			mv.addObject("nextLocation", "/goLogin.do");
			mv.addObject("msg", "로그인 후 이용해주세요 :)");
			return mv;
		}
		
		mv.setViewName("letter/write");
		return mv;
	}
	
	@RequestMapping("/letter/doWrite.do")
	public ModelAndView doWrite(@RequestParam HashMap<String, String> params, HttpSession session) {
		log.debug("/letter/doWrite.do - params : " + params);

		ModelAndView mv = new ModelAndView();
		
		if (session.getAttribute("userId") == null) { 	// 로그인 안 한 경우	
			mv.setViewName("error/error");
			mv.addObject("nextLocation", "/goLogin.do");
			mv.addObject("msg", "로그인 후 이용해주세요 :)");
			return mv;
		}
		
		Letter letter = new Letter();
		letter.setToId(params.get("toId"));
		letter.setTitle(params.get("title"));
		// text(편지 내용)은 수정해서 넣어주기
		String text = params.get("text");
		text = text.replaceAll("\r\n", "<br>");		// 줄 바꿈 변환
		letter.setText(text);
		letter.setFromId(String.valueOf(session.getAttribute("userId")));
		letter.setFromNickname(String.valueOf(session.getAttribute("nickname")));
		
		try {	
			service.write(letter);			
		} catch(Exception e) {
			e.printStackTrace();			// 오류나면 service에서 보낸 문구를 콘솔에 출력
			mv.setViewName("letter/write");
			mv.addObject("msg", "<font color=red><b>편지 전송에 오류가 발생했습니다.</b></font>");
			return mv;
		}
		mv.setViewName("error/error");
		mv.addObject("msg", params.get("toId") + "님께 편지가 전달되었습니다 :)");
		mv.addObject("nextLocation", "/index.do");
		return mv;
	}
	
	@RequestMapping("/letter/list.do")
	public ModelAndView list(@RequestParam HashMap<String, String> params, HttpSession session) {
		log.debug("/letter/list.do - params : " + params);
		ModelAndView mv = new ModelAndView();

		if (session.getAttribute("userId") == null) { 	// 로그인 안 한 경우	
			mv.setViewName("error/error");
			mv.addObject("nextLocation", "/goLogin.do");
			mv.addObject("msg", "로그인 후 이용해주세요 :)");
			return mv;
		}
		
		// jsp에서 보낸 파라미터를 HashMap으로 받음
		// jsp에서 값을 보내지 않으면 currentPageNo의 if문이 실행되지 않음

		// DAO로 보낼 파라미터
		HashMap<String, Object> p = new HashMap<String, Object>();
		p.put("searchType", params.get("searchType"));
		p.put("searchText", params.get("searchText"));
		if(params.get("toId") != null)
			p.put("toId", params.get("toId"));
		if(params.get("fromId") != null)
			p.put("fromId", params.get("fromId"));
		
		int totalArticle = service.count(p);		// 총 게시글 수
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
		int pageBlockStart = 
				(currentPageNo - 1) / pageBlockSize * pageBlockSize + 1;	
		// 종료 = (현재-1) / 블럭수 * 블럭수 + 블럭수
		int pageBlockEnd = 
				(currentPageNo - 1) / pageBlockSize * pageBlockSize + pageBlockSize;	
		// 종료값이 총페이지수보다 크거나 같으면 총페이지수
		pageBlockEnd = (pageBlockEnd >= totalPage) ? totalPage : pageBlockEnd; 

		// DAO로 보낼 파라미터
		p.put("startArticleNo", startArticleNo);
		p.put("pageArticle", pageArticle);
		
		ArrayList<Letter> letter = service.list(p);
		
		mv.addObject("letter", letter);
		mv.addObject("totalArticle", totalArticle);
		mv.addObject("totalPage", totalPage);
		mv.addObject("currentPageNo", currentPageNo);	
		mv.addObject("pageBlockSize", pageBlockSize);
		mv.addObject("pageBlockStart", pageBlockStart);
		mv.addObject("pageBlockEnd", pageBlockEnd);
		mv.addObject("searchType", params.get("searchType"));
		mv.addObject("searchText", params.get("searchText"));

		if(params.get("toId") != null) {
			mv.addObject("toId", params.get("toId"));
			mv.setViewName("letter/toList");			
		}
		if(params.get("fromId") != null) {
			mv.addObject("fromId", params.get("fromId"));
			mv.setViewName("letter/fromList");			
		}
		return mv;
	}
	
	@RequestMapping("/letter/read.do")
	public ModelAndView read(@RequestParam HashMap<String, String> params, HttpSession session) {
		log.debug("/letter/read.do - params : " + params);
		ModelAndView mv = new ModelAndView();

		if (session.getAttribute("userId") == null) { 	// 로그인 안 한 경우	
			mv.setViewName("error/error");
			mv.addObject("nextLocation", "/goLogin.do");
			mv.addObject("msg", "로그인 후 이용해 주세요 :)");
			return mv;
		}
		
		// 글번호
		int seq = Integer.parseInt(params.get("seq"));

		// 특정 편지 DTO
		Letter letter = null;
		try {
			letter = service.read(seq);
			if(letter.getHit().equals("읽지않음") 
					&& (session.getAttribute("userId")).equals(letter.getToId()))
				service.newLetter(seq);
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.addObject("letter", letter);			// 편지 정보 보내기
		mv.setViewName("letter/read");
		return mv;
	}
	
	@RequestMapping("/letter/toDeveloper.do")
	public ModelAndView toDeveloper(@RequestParam HashMap<String, String> params, HttpSession session) {
		log.debug("/letter/toDeveloper.do - params : " + params);

		ModelAndView mv = new ModelAndView();
		
		if (session.getAttribute("userId") == null) { 	// 로그인 안 한 경우	
			mv.setViewName("error/error");
			mv.addObject("nextLocation", "/goLogin.do");
			mv.addObject("msg", "로그인 후 이용해주세요 :)");
			return mv;
		}
		
		Letter letter = new Letter();
		letter.setToId("SIEUN");
		letter.setToNickname("관리자");
		letter.setTitle(params.get("title"));
		// text(편지 내용)은 수정해서 넣어주기
		String text = params.get("text");
		text = text.replaceAll("\r\n", "<br>");		// 줄 바꿈 변환
		letter.setText(text);
		letter.setFromId(String.valueOf(session.getAttribute("userId")));
		letter.setFromNickname(String.valueOf(session.getAttribute("nickname")));
		
		try {	
			service.write(letter);			
		} catch(Exception e) {
			e.printStackTrace();			// 오류나면 service에서 보낸 문구를 콘솔에 출력
			mv.setViewName("index");
			mv.addObject("msg", "<font color=red><b>편지 전송에 오류가 발생했습니다.</b></font>");
			return mv;
		}
		mv.setViewName("error/error");
		mv.addObject("msg", "관리자에게 편지가 전달되었습니다 :)");
		mv.addObject("nextLocation", "/index.do");
		return mv;
	}
}
