package com.iot.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.iot.dto.FreeBoard;
import com.iot.dto.Friend;

public interface FriendService {

	public int count(HashMap<String, Object> p);

	public ArrayList<Friend> list(HashMap<String, Object> p);

	public int register(Friend f) throws Exception;

	public int chkId(String friendId);

}
