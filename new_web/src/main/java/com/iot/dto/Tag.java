package com.iot.dto;

import org.apache.ibatis.type.Alias;

@Alias("Tag")
public class Tag {

	private int seq;
	private String name;
	
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
}
