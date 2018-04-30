package com.iot.dao;

import java.util.ArrayList;
import java.util.HashMap;

import com.iot.dto.FreeBoard;
import com.iot.dto.Friend;

public interface FriendDao {

	public int count(HashMap<String, Object> p);

	public ArrayList<Friend> list(HashMap<String, Object> p);

	public int register(Friend f);

	public int chkId(String friendId, String userId);

	public Friend getData(int seq);

	public int delete(int seq);

	public int update(Friend friend);

}
