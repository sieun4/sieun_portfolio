package com.iot.dao;

import java.util.ArrayList;
import java.util.HashMap;

import com.iot.dto.Letter;

public interface LetterDao {

	public int write(Letter letter);

	public int count(HashMap<String, Object> params);

	public ArrayList<Letter> list(HashMap<String, Object> params);

	public Letter read(int seq);

	public int newLetter(int seq);

	public int newCnt(String userId);

}
