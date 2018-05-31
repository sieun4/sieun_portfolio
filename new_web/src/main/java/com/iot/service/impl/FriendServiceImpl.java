package com.iot.service.impl;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.iot.dao.FriendDao;
import com.iot.dto.Friend;
import com.iot.exception.AnomalyException;
import com.iot.service.FriendService;

@Service("friendService")
public class FriendServiceImpl implements FriendService {

	@Autowired
	FriendDao dao;
	
	@Override	// 친구 수 카운트
	public int count(HashMap<String, Object> p) {
		return dao.count(p);
	}

	@Override	// 친구 목록
	public ArrayList<Friend> list(HashMap<String, Object> p) {
		return dao.list(p);
	}

	@Override	// 친구 등록
	public int register(Friend f) throws Exception {
		int result = dao.register(f);
		if(result != 1) throw new AnomalyException(1, result); // (기대값, 실제값)
		return result;
	}

	@Override	// 이미 등록된 친구ID인지 확인
	public int chkId(String friendId, String userId) {
		return dao.chkId(friendId, userId);
	}

	@Override	// 친구 정보 가져오기
	public Friend getData(int seq) {
		return dao.getData(seq);
	}

	@Override	// 친구 삭제
	public int delete(int seq) throws Exception {
		int result = dao.delete(seq);
		if(result != 1) throw new Exception("친구 삭제 오류!!!!");
		return result;
	}

	@Override	// 친구 정보 수정
	public int update(Friend friend) throws Exception {
		int result = dao.update(friend);			// FreeBoard DB Update
		if(result != 1) throw new AnomalyException(1, result); // (기대값, 실제값)
		return result;
	}
}
