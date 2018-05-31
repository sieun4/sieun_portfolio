package com.iot.controller;

import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.iot.service.LetterService;

@Controller
public class IndexController {

	@Autowired
	LetterService lService;
	
	@RequestMapping("/index.do")	// 기본 홈페이지 틀
	public ModelAndView home() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("index");
		return mv;
	}
	
	@RequestMapping("/home.do")		// 메인 화면
	public ModelAndView index(@RequestParam HashMap<String, String> params, HttpSession session) {
		ModelAndView mv = new ModelAndView();

		int count = 0;
		if(session.getAttribute("userId") != null) {	// 해당 회원의 새편지 조회
			count = lService.newCnt(String.valueOf(session.getAttribute("userId")));
		}
		
		mv.addObject("count", count);
		mv.setViewName("home");
		return mv;
	}
}
