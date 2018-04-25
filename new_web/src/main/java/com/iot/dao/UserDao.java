package com.iot.dao;

import com.iot.dto.User;

public interface UserDao {

	public int chkId(String userId);

	public User getUser(String userId);

	public String encPw(String comparePw);

	public int join(User user);

	public int delete(int seq);

	public int editUser(User user);
}
