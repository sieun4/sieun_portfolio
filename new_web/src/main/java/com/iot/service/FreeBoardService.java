package com.iot.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.iot.dto.FreeBoard;

public interface FreeBoardService {

	public int count(HashMap<String, Object> params);

	public ArrayList<FreeBoard> paging(HashMap<String, Object> params);

	public FreeBoard read(int seq) throws Exception;

	public void write(FreeBoard board, List<MultipartFile> files);

	public void delete(int seq, String userId, String password) throws Exception;

	public FreeBoard goUpDate(int seq, String userId, String password, String pass) throws Exception;

	public int update(FreeBoard board, List<MultipartFile> files) throws Exception;

	public FreeBoard findBySeq(int seq);

	public int delAttachedFile(int attachSeq) throws Exception;

}
