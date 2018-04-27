package com.iot.service.impl;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.iot.dao.FriendDao;
import com.iot.dto.Friend;
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

}
