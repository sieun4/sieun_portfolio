package com.iot.dao;

import java.util.ArrayList;
import java.util.HashMap;

import com.iot.dto.FreeBoard;

public interface FreeBoardDao {

	public int count(HashMap<String, Object> params);

	public ArrayList<FreeBoard> paging(HashMap<String, Object> params);

	public int updateHits(int seq);

	public void write(FreeBoard board);

	public int delete(int seq);

	public int update(FreeBoard board);

	public FreeBoard findBySeq(int seq);

	public int writeHasCo(int seq);

	public int delHasCo(int seq);

}
