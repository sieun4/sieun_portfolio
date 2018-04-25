package com.iot.dao;

import java.util.ArrayList;

import com.iot.dto.Comments;

public interface CommentsDao {

	public ArrayList<Comments> getComment(int commentDocSeq);

	public int deleteAll(int commentDocSeq);

	public int write(Comments c);

	public int delete(int commentSeq);

	public int delHasCo(int seq);

}
