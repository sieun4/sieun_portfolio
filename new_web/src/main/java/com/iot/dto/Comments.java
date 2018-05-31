package com.iot.dto;

import org.apache.ibatis.type.Alias;

@Alias("Comments")
public class Comments {

	private int commentSeq;
	private int commentDocSeq;
	private String userId;
	private String nickname;
	private String comment;
	private String writeDate;
	
	public int getCommentSeq() {
		return commentSeq;
	}
	public void setCommentSeq(int commentSeq) {
		this.commentSeq = commentSeq;
	}
	public int getCommentDocSeq() {
		return commentDocSeq;
	}
	public void setCommentDocSeq(int commentDocSeq) {
		this.commentDocSeq = commentDocSeq;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public String getWriteDate() {
		return writeDate;
	}
	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}	
}