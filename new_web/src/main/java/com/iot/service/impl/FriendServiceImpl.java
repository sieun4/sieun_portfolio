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
	
	@Override
	public int count(HashMap<String, Object> p) {
		return dao.count(p);
	}

	@Override
	public ArrayList<Friend> list(HashMap<String, Object> p) {
		return dao.list(p);
	}

	@Override
	public int register(Friend f) throws Exception {
		int result = dao.register(f);
		if(result != 1) throw new AnomalyException(1, result); // (기대값, 실제값)
		return result;
	}

	@Override
	public int chkId(String friendId, String userId) {
		return dao.chkId(friendId, userId);
	}

	@Override
	public Friend getData(int seq) {
		return dao.getData(seq);
	}

	@Override
	public int delete(int seq) throws Exception {
		int result = dao.delete(seq);
		if(result != 1) throw new Exception("친구 삭제 오류!!!!");
		return result;
	}

	@Override
	public int update(Friend friend) throws Exception {
		int result = dao.update(friend);			// FreeBoard DB Update
		if(result != 1) throw new AnomalyException(1, result); // (기대값, 실제값)
		return result;
	}
}
