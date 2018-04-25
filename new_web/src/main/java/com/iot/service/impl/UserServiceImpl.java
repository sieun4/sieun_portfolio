package com.iot.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.iot.dao.LetterDao;
import com.iot.dao.UserDao;
import com.iot.dto.User;
import com.iot.exception.AnomalyException;
import com.iot.service.UserService;

@Service("userService")
@Transactional(rollbackFor= {Exception.class})
// Transactional : 매서드마다 적용할 수도 있지만 클래스 위에 쓰면 클래스 안에 있는 모드 메서드에 적용
public class UserServiceImpl implements UserService {

	@Autowired
	UserDao dao;
	
	@Autowired
	LetterDao lDao;
	
	@Override
	public boolean comparePw(String userId, String comparePw) throws Exception {
		int result = dao.chkId(userId);							// ID가 존재하는지 확인
		if(result != 1) throw new Exception("NOT_FOUND_USER_ID");
		
		User user = dao.getUser(userId);
		String compare = dao.encPw(comparePw);
		return compare.equals(user.getUserPw());
	}

	@Override
	public User getUser(String userId) {
		return dao.getUser(userId);
	}

	@Override
	public int join(User user) throws Exception {
		int result = dao.join(user);
		if(result != 1) throw new AnomalyException(1, result); // (기대값, 실제값)
		return result;
	}

	@Override
	public int chkId(String userId) {
		return dao.chkId(userId);
	}

	@Override
	public void delete(String userId, String comparePw) throws Exception {
		// 사용자가 입력한 비밀번호 암호화
		String encryptedPw = dao.encPw(comparePw);	
		// 비밀번호 비교
		User user = dao.getUser(userId);
		if(encryptedPw.equals(user.getUserPw())) {	// 비밀번호가 맞으면 지우기
			// 게시글 지우기
			int fResult = dao.delete(user.getSeq());
			if(fResult != 1) throw new Exception("DELETE_ANOMALY");		// 삭제 이상
		}
		else {	// 비밀번호가 다름
			throw new Exception("NOT_EQ_PASSWORD");
		}		
	}

	@Override
	public User goEdit(String userId, String comparePw) throws Exception {
		String encryptedPw = dao.encPw(comparePw);		// 사용자가 입력한 비밀번호 암호화
		User user = dao.getUser(userId);				// 수정할 회원 정보
		if(!encryptedPw.equals(user.getUserPw()))		// 비밀번호 확인
			throw new Exception("NOT_EQ_PASSWORD");		// 비밀번호가 다름
		return user;
	}

	@Override
	public int editUser(User user) throws Exception {
		int result = dao.editUser(user);
		if(result != 1) throw new AnomalyException(1, result); // (기대값, 실제값)
		return result;
	}
}
