package com.iot.dto;

import org.apache.ibatis.type.Alias;

@Alias("Letter")
public class Letter {

	private int seq;
	private String toId;
	private String toNickname;
	private String title;
	private String text;
	private String date;
	private String fromId;
	private String fromNickname;
	private String hit;
	
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getToId() {
		return toId;
	}
	public void setToId(String toId) {
		this.toId = toId;
	}
	public String getToNickname() {
		return toNickname;
	}
	public void setToNickname(String toNickname) {
		this.toNickname = toNickname;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getFromId() {
		return fromId;
	}
	public void setFromId(String fromId) {
		this.fromId = fromId;
	}
	public String getFromNickname() {
		return fromNickname;
	}
	public void setFromNickname(String fromNickname) {
		this.fromNickname = fromNickname;
	}
	public String getHit() {
		return hit;
	}
	public void setHit(String hit) {
		this.hit = hit;
	}
}
