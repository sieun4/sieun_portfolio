package com.iot.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.iot.dto.User;

public interface UserService {

	public boolean comparePw(String userId, String comparePw) throws Exception;

	public User getUser(String userId);

	public int join(User user) throws Exception;

	public int chkId(String userId);

	public void delete(String userId, String comparePw) throws Exception;

	public User goEdit(String userId, String comparePw) throws Exception;

	public int editUser(User user) throws Exception;

	public int count(HashMap<String, Object> params);

	public ArrayList<User> list(HashMap<String, String> params);

}
