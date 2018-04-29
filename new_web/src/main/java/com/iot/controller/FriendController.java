package com.iot.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.iot.dto.Friend;
import com.iot.dto.Letter;
import com.iot.service.FriendService;
import com.iot.service.UserService;

@Controller
public class FriendController {

	private Logger log = Logger.getLogger(FreeBoardController.class);

	@Autowired
	FriendService service;
	
	@Autowired
	UserService uService;

	@RequestMapping("/friend/list.do")
	public ModelAndView list(@RequestParam HashMap<String, String> params, HttpSession session) { 
		log.debug("/friend/list.do - params : " + params);
		ModelAndView mv = new ModelAndView();
	
		if (session.getAttribute("userId") == null) { 	// 로그인 안 한 경우	
			mv.setViewName("error/error");
			mv.addObject("nextLocation", "/goLogin.do");
			mv.addObject("msg", "로그인 후 이용해주세요 :)");
			return mv;
		}
		
		// jsp에서 보낸 파라미터를 HashMap으로 받음
		// jsp에서 값을 보내지 않으면 currentPageNo의 if문이 실행되지 않음

		// 검색 기능을 사용했을 경우 DAO로 보낼 파라미터
		HashMap<String, Object> p = new HashMap<String, Object>();
		p.put("searchType", params.get("searchType"));
		p.put("searchText", params.get("searchText"));

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

		// 페이지별로 불러 올 게시글 정보를 불러오기 위해 DAO로 보낼 파라미터
		p.put("startArticleNo", startArticleNo);
		p.put("pageArticle", pageArticle);

		ArrayList<Friend> result = service.list(p);

		mv.addObject("result", result);
		mv.addObject("totalArticle", totalArticle);
		mv.addObject("totalPage", totalPage);
		mv.addObject("currentPageNo", currentPageNo);	
		mv.addObject("pageBlockSize", pageBlockSize);
		mv.addObject("pageBlockStart", pageBlockStart);
		mv.addObject("pageBlockEnd", pageBlockEnd);
		mv.addObject("searchType", params.get("searchType"));
		mv.addObject("searchText", params.get("searchText"));
		mv.setViewName("/friend/list");
		return mv;
	}

	@RequestMapping("/friend/goRegister")
	public ModelAndView goRegister(@RequestParam HashMap<String, String> params, HttpSession session) { 
		log.debug("/friend/goRegister.do - params : " + params);
		ModelAndView mv = new ModelAndView();
		
		if (session.getAttribute("userId") == null) { 	// 로그인 안 한 경우	
			mv.setViewName("error/error");
			mv.addObject("nextLocation", "/goLogin.do");
			mv.addObject("msg", "로그인 후 이용해주세요 :)");
			return mv;
		}
		
		mv.addObject("userId", session.getAttribute("userId"));
		mv.setViewName("friend/register");
		return mv;
	}
	
	@RequestMapping("/friend/doRegister.do")
	@ResponseBody
	public int doRegister(@RequestParam HashMap<String, String> params, HttpSession session) { 
		log.debug("/friend/doRegister.do - params : " + params);
		ModelAndView mv = new ModelAndView();
		
		// result == 0 : 존재하는 회원 아이디가 아님
		// result == 1 : 이미 등록된 친구 
		// result == 2 : 아이디에 영문 대문자 사용했을 경우
		// result == 3 : 등록 오류
		// result == 4 : 정상 등록
		
		String friendId = params.get("friendId");

		for(int i=0; i<friendId.length(); i++) {
			if('A' <= friendId.charAt(i) && friendId.charAt(i) <= 'Z')
				return 2;
		}
		
		if(uService.chkId(friendId) == 0) {
			return 0;
		}
		else {
			
			if(service.chkId(friendId) != 0)
				return 1;
				
			try {	
				Friend f = new Friend();
				f.setUserId(String.valueOf(session.getAttribute("userId")));
				f.setFriendId(params.get("friendId"));
				f.setFriendName(params.get("friendName"));
				f.setMemo(params.get("memo"));
				service.register(f);			
				return 4;
			} catch(Exception e) {
				e.printStackTrace();			// 오류나면 service에서 보낸 문구를 콘솔에 출력
				mv.setViewName("friend/register");
				mv.addObject("msg", "<font color=red><b>새친구 추가에 오류가 발생했습니다.</b></font>");
				return 3;
			}
		}
	}
	
	@RequestMapping("/friend/read.do")
	public ModelAndView read(@RequestParam HashMap<String, String> params, HttpSession session) { 
		log.debug("/friend/read.do - params : " + params);
		ModelAndView mv = new ModelAndView();
		
		if (session.getAttribute("userId") == null) { 	// 로그인 안 한 경우	
			mv.setViewName("error/error");
			mv.addObject("nextLocation", "/goLogin.do");
			mv.addObject("msg", "로그인 후 이용해주세요 :)");
			return mv;
		}
		
		mv.setViewName("friend/read");
		return mv;
	}
}
