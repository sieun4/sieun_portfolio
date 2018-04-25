package com.iot.dto;

import org.apache.ibatis.type.Alias;

@Alias("FreeBoard")
public class FreeBoard {

	private int seq;
	private String userId;
	private String nickname;
	private String title;
	private String contents;
	private int hits;
	private String hasFile;
	private String writeDate;
	private String updateDate;
	private int hasComment;
	
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public int getHits() {
		return hits;
	}
	public void setHits(int hits) {
		this.hits = hits;
	}
	public String getHasFile() {
		return hasFile;
	}
	public void setHasFile(String hasFile) {
		this.hasFile = hasFile;
	}
	public String getWriteDate() {
		return writeDate;
	}
	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getHasComment() {
		return hasComment;
	}
	public void setHasComment(int hasComment) {
		this.hasComment = hasComment;
	}
}
