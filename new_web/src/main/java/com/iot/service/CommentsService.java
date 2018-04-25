package com.iot.service;

import java.util.ArrayList;

import com.iot.dto.Comments;

public interface CommentsService {

	public ArrayList<Comments> getComment(int seq);

	public int write(Comments c) throws Exception;

	public int delete(int commentSeq, int seq) throws Exception;

}
