package com.iot.service.impl;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.iot.dao.LetterDao;
import com.iot.dto.Letter;
import com.iot.service.LetterService;

@Service("letterService")
@Transactional(rollbackFor= {Exception.class})
public class LetterServiceImpl implements LetterService {

	@Autowired
	LetterDao dao;
	
	@Override
	public int write(Letter letter) throws Exception {
		int result = dao.write(letter);
		if(result != 1) throw new Exception("게시글 저장 오류!!!!");		// 오류나면 콘솔에 출력
		return result;
	}

	@Override
	public int count(HashMap<String, Object> params) {
		return dao.count(params);
	}

	@Override
	public ArrayList<Letter> list(HashMap<String, Object> params) {
		return dao.list(params);
	}

	@Override
	public Letter read(int seq) {
		return dao.read(seq);
	}

	@Override
	public void newLetter(int seq) throws Exception {
		int result = dao.newLetter(seq);
		if(result != 1) throw new Exception("오류!!!!"); 
	}

	@Override
	public int newCnt(String userId) {
		int count = dao.newCnt(userId);
		return count;

	}

}
