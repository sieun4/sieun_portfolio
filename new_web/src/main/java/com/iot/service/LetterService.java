package com.iot.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.iot.dto.Letter;

public interface LetterService {

	public int write(Letter letter) throws Exception;

	public int count(HashMap<String, Object> params);

	public ArrayList<Letter> list(HashMap<String, Object> p);

	public Letter read(int seq);

	public void newLetter(int seq) throws Exception;

	public int newCnt(String userId);
}
