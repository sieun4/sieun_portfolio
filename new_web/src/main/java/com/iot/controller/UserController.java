package com.iot.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import com.iot.dto.Letter;
import com.iot.dto.User;
import com.iot.service.LetterService;
import com.iot.service.UserService;

@Controller
public class UserController {

	private Logger log = Logger.getLogger(UserController.class);

	@Autowired
	UserService service;
	
	@Autowired
	LetterService lService;

	@RequestMapping("/goLogin.do")	// 로그인 화면으로
	public ModelAndView index(HttpSession session) {
		ModelAndView mv = new ModelAndView();

		if (session.getAttribute("userId") != null) { 	// 이미 로그인 한 경우	
			mv.setViewName("error/error");
			mv.addObject("msg", "이미 로그인 하셨습니다 :)");
			mv.addObject("nextLocation", "/index.do");
			return mv;
		}											
		mv.setViewName("user/login");					// 로그인 페이지로
		return mv;
	}

	@RequestMapping("/doLogin.do")	// 로그인하기
	public ModelAndView doLogin(@RequestParam HashMap<String, String> params, HttpSession session) {
		log.debug("login.do - params : " + params);
		ModelAndView mv = new ModelAndView();

		if (session.getAttribute("userId") != null) { 	// 이미 로그인 한 경우	
			mv.setViewName("error/error");
			mv.addObject("msg", "이미 로그인 하셨습니다 :)");
			mv.addObject("nextLocation", "/index.do");
			return mv;
		}

		String userId = params.get("userId");
		String comparePw = params.get("password");

		try {	// 비밀번호 확인 메서드 호출
			if (service.comparePw(userId, comparePw)) { // 비밀번호 일치
				User user = service.getUser(userId);
				// session은 request보다 넓은 영역
				// session은 페이지 이동이 상관 없음
				session.setAttribute("userId", user.getUserId());
				session.setAttribute("isAdmin", user.getIsAdmin());
				session.setAttribute("nickname", user.getNickname());
				RedirectView rv = new RedirectView("/new_web/index.do");
				mv.setView(rv);

			} else { // 비밀번호 불일치
				mv.setViewName("error/error");
				mv.addObject("msg", "비밀번호가 일치하지 않습니다.");
				mv.addObject("nextLocation", "/goLogin.do");
				return mv;
			}
		} catch (Exception e) {	// 없는 아이디일 경우
			switch (e.getMessage()) {
			case "NOT_FOUND_USER_ID":
				mv.setViewName("error/error");
				mv.addObject("msg", "존재하지 않는 ID입니다.");
				mv.addObject("nextLocation", "/goLogin.do");
				return mv;
			}
		}
		return mv;
	}

	@RequestMapping("/logout.do")	// 로그아웃  하기
	public ModelAndView logout(HttpSession session) {
		ModelAndView mv = new ModelAndView();

		if (session.getAttribute("userId") == null) { 	// 로그인 하지 않은 경우	
			mv.setViewName("error/error");
			mv.addObject("msg", "로그인 후 이용해주세요 :)");
			mv.addObject("nextLocation", "/goLogin.do");
			return mv;
		}		

		session.invalidate(); // 세선을 유효하지 않은 상태로 만들어서 정보가 다 사라짐
		RedirectView rv = new RedirectView("/new_web/goLogin.do");
		mv.setView(rv);
		return mv;
	}

	@RequestMapping("/goJoin.do")	// 회원가입 하러 가기
	public ModelAndView goJoin(@RequestParam HashMap<String, String> params, HttpSession session) {
		log.debug("/goJoin.do - params : " + params);
		ModelAndView mv = new ModelAndView();

		if (session.getAttribute("userId") != null) { 	// 로그인 한 경우	
			mv.setViewName("error/error");
			mv.addObject("msg", "회원가입은 로그아웃 후 이용해주세요 :)");
			mv.addObject("nextLocation", "/index.do");
			return mv;
		}							
		mv.setViewName("user/join");	// 로그인 안 한 경우 정상적으로 회원가입 페이지로
		return mv;
	}

	@RequestMapping("/doJoin.do")	// 회원가입 하기
	public ModelAndView doJoin(@RequestParam HashMap<String, String> params, HttpSession session) {
		log.debug("/doJoin.do - params : " + params); // 파라미터 출력해보기
		ModelAndView mv = new ModelAndView();

		if (session.getAttribute("userId") != null) { 	// 로그인 한 경우	
			mv.setViewName("error/error");
			mv.addObject("msg", "회원가입은 로그아웃 후 이용해주세요 :)");
			mv.addObject("nextLocation", "/index.do");
			return mv;
		}	
		
		User user = new User();			// 회원정보 저장하기
		user.setUserId(params.get("userId"));
		user.setUserName(params.get("userName"));
		user.setUserPw(params.get("userPw"));
		user.setNickname(params.get("nickname"));

		Letter letter = new Letter();	// 회원가입 축하 편지 보내기
		letter.setFromId("SIEUN");
		letter.setFromNickname("관리자");
		letter.setText("회원가입을 축하드립니다! <br>계속해서 다양한 기능들을 업데이트할 예정이니 많이 이용해주세요 :D");
		letter.setTitle("회원가입을 축하드립니다!");
		letter.setToId(user.getUserId());
		letter.setToNickname(user.getNickname());

		try {
			service.join(user);
			lService.write(letter);
		} catch (Exception e) {
			e.printStackTrace(); // 오류나면 service에서 보낸 문구를 콘솔에 출력
			mv.setViewName("login");
			mv.addObject("msg", "<font color=red><b>글을 등록하는 중 오류가 발생했습니다.</b></font>");
			return mv;
		}		
		mv.setViewName("error/error");
		mv.addObject("msg", "가입이 완료되었습니다! 로그인 후 다양한 기능을 이용해 보세요 :)");
		mv.addObject("nextLocation", "/goLogin.do");	// 로그인 화면으로
		return mv;
	}

	@RequestMapping("/chkId.do") 	// ID 중복 확인
	@ResponseBody
	public int chkId(@RequestParam HashMap<String, String> params) {
		log.debug("/chkId.do - params : " + params); // 파라미터 출력해보기
		
		String userId = params.get("userId");
		
		for(int i=0; i<userId.length(); i++) {	// ID로 영문 대문자는 사용할 수 없음
			if('A' <= userId.charAt(i) && userId.charAt(i) <= 'Z')
				return 2;
		}
		
		return service.chkId(userId);	// 중복 되는 ID가 있는지(1 또는 0) 결과 반환
	}

	@RequestMapping("/user/getInfo.do")	// 마이 페이지 (본인 정보 조회)
	public ModelAndView getInfo(@RequestParam HashMap<String, String> params, HttpSession session) {
		log.debug("/user/getInfo.do - params : " + params); // 파라미터 출력해보기
		ModelAndView mv = new ModelAndView();

		if(session.getAttribute("userId") == null) { 		// 로그인 안 한 경우	
			mv.setViewName("error/error");
			mv.addObject("msg", "로그인 후 이용해 주세요 :)");
			mv.addObject("nextLocation", "/goLogin.do");
			return mv;
		}

		// 사용자 정보를 가져온다
		User user = service.getUser(String.valueOf(session.getAttribute("userId")));
		mv.addObject("user", user);
		mv.addObject("msg", params.get("msg"));
		mv.setViewName("user/readUserInfo");
		return mv;
	}

	@RequestMapping("/user/delete.do")			// 탈퇴하기
	public ModelAndView quitService(@RequestParam HashMap<String, String> params, HttpSession session) {
		log.debug("/user/delete.do - params : " + params); 
		ModelAndView mv = new ModelAndView();

		if (session.getAttribute("userId") == null) { 	// 로그인 안 한 경우	
			mv.setViewName("error/error");
			mv.addObject("nextLocation", "/goLogin.do");
			mv.addObject("msg", "로그인 후 이용해 주세요 :)");
			return mv;
		}

		String userId = String.valueOf(session.getAttribute("userId"));
		String comparePw = params.get("password");

		try {						// 탈퇴 메서드 수행
			service.delete(userId, comparePw);
		} catch(Exception e) {		// 비밀번호가 맞지 않거나 오류 발생시 다시 마이 페이지로
			RedirectView rv = new RedirectView("/new_web/user/getInfo.do");
			String msg = "";
			switch(e.getMessage()) {
			case "DELETE_ANOMALY":
				msg = "삭제 중 오류가 발생했습니다.";
				break;
			case "NOT_EQ_PASSWORD":
				msg = "비밀번호가 일치하지 않습니다.";
				break;
			}
			mv.addObject("msg", msg);
			mv.setView(rv);
			return mv;
		}
		session.invalidate(); // 세선을 유효하지 않은 상태로 만들어서 정보가 다 사라짐
		mv.setViewName("error/error");
		mv.addObject("msg", "정상적으로 탈퇴되었습니다 :)");
		mv.addObject("nextLocation", "/goJoin.do");	// 탈퇴가 완료되면 회원가입 화면으로
		return mv;
	}

	@RequestMapping("/user/goEdit.do")	// 개인 정보 수정하러 가기
	public ModelAndView goEdit(@RequestParam HashMap<String, String> params, HttpSession session) {
		log.debug("/user/goEdit.do - params : " + params);
		ModelAndView mv = new ModelAndView();

		if(session.getAttribute("userId") == null) { 		// 로그인 안 한 경우	
			mv.setViewName("error/error");
			mv.addObject("msg", "로그인 후 이용해 주세요 :)");
			mv.addObject("nextLocation", "/goLogin.do");
			return mv;
		}

		String userId = String.valueOf(session.getAttribute("userId"));
		String comparePw = params.get("password");
		User user;
		try {						// 수정할 정보 불러오기
			user = service.goEdit(userId, comparePw);
		} catch(Exception e) {		// 비밀번호가 맞지 않으면 다시 마이 페이지로
			RedirectView rv = new RedirectView("/new_web/user/getInfo.do");
			mv.addObject("msg", "비밀번호가 일치하지 않습니다.");
			mv.addObject("userId", userId);
			mv.setView(rv);
			return mv;
		}
		mv.addObject("user", user);
		mv.setViewName("user/editUser");	// 개인 정보 수정 페이지로
		return mv;
	}
	
	@RequestMapping("/user/doEdit.do")	// 개인 정보 수정하기
	public ModelAndView doEdit(@RequestParam HashMap<String, String> params, HttpSession session) {
		log.debug("/user/doEdit.do - params : " + params); 
		ModelAndView mv = new ModelAndView();

		User user = service.getUser(String.valueOf(session.getAttribute("userId")));
		user.setUserPw(params.get("userPw"));
		user.setNickname(params.get("nickname"));
		user.setEmail(params.get("email"));
		try {
			service.editUser(user);
		} catch(Exception e) {
			e.printStackTrace();			// 오류나면 service에서 보낸 문구를 콘솔에 출력
			mv.addObject("user", user);
			mv.addObject("msg", "글을 수정하는 중 오류가 발생했습니다.");
			RedirectView rv = new RedirectView("/new_web/user/goEditUser.do");
			mv.setView(rv);
			return mv;
		}
		session.invalidate(); 		// 세선을 유효하지 않은 상태로 만들어서 정보가 다 사라짐
		mv.setViewName("error/error");
		mv.addObject("msg", "수정이 완료되었습니다. 다시 로그인 해주세요 :)");
		mv.addObject("nextLocation", "/goLogin.do");	// 개인 정보 수정 완료 후 로그인 화면으로
		return mv;
	}
	
	@RequestMapping("/user/list.do")	// 회원 리스트 화면으로 (관리자만)
	public ModelAndView list(@RequestParam Map<String, String> params, HttpSession session) {
		log.debug("/user/list.do params : " + params);
		ModelAndView mv = new ModelAndView();
		
		if(session.getAttribute("userId") == null) { 		// 로그인 안 한 경우	
			mv.setViewName("error/error");
			mv.addObject("msg", "로그인 후 이용해 주세요 :)");
			mv.addObject("nextLocation", "/goLogin.do");
			return mv;
		}
		if(!session.getAttribute("isAdmin").equals("1")) {	// 관리자가 아닌 경우 조회 불가	
			mv.setViewName("error/error");
			mv.addObject("msg", "권한이 없습니다 ㅠㅠ");
			mv.addObject("nextLocation", "/index.do");
			return mv;
		}
		mv.setViewName("user/list");
		return mv;
	}
	
	@RequestMapping("/user/getUserData.do")		// 회원 리스트에서 보여질 데이터 (관리자만)
	@ResponseBody	// 비동기
	public HashMap<String, Object> getUserData(@RequestParam HashMap<String, String> params) {
		log.debug("/user/getUserData.do params : " + params);
		
		// DAO로 보낼 파라미터
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("searchType", params.get("searchType"));
		resultMap.put("searchText", params.get("searchText"));
		
		// jsp에서 보낸 파라미터를 HashMap으로 받음
		// jsp에서 값을 보내지 않으면 currentPageNo의 if문이 실행되지 않음
		int totalCount = service.count(resultMap);		// 총 게시글 수
		int pageArticle = Integer.parseInt(params.get("rows").toString());	// 한 페이지에 보여줄 게시글 수
		int currentPage = Integer.parseInt(params.get("page").toString());	// jsp에서 값을 받지 않았을 때의 현재페이지 기본 설정

		// 총 페이지 수 = 총 게시글 수 / 한 페이지 게시글 수 (나머지가 0이 아닐 경우 +1)
		int totalPage = totalCount / pageArticle;
		totalPage = (totalCount % pageArticle == 0) ? totalPage : totalPage + 1;

		int start = (currentPage - 1) * pageArticle;	// 시작글 번호

		params.put("start", String.valueOf(start));
		
		ArrayList<User> result = service.list(params);
		
		// DAO로 보낼 파라미터
		resultMap.put("page", currentPage);		// 현재 페이지
		resultMap.put("total", totalPage);		// 총 페이지 수
		resultMap.put("records", totalCount);	// 총 데이터 건수
		resultMap.put("rows", result);			// 보여줄 데이터 15건
		return resultMap;	// @ResponseBody 안 쓰면 값 안 넘어가는데 에러도 안 남. 주의!!!
	}
}