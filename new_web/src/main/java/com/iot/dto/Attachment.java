package com.iot.dto;

import org.apache.ibatis.type.Alias;

@Alias("Attachment")
public class Attachment {
	
	private int attachSeq;
	private String attachDocType;
	private int attachDocSeq;
	private String filename;
	private String fakeName;
	private long fileSize;
	private String contentType;
	private String createDate;
	
	public int getAttachSeq() {
		return attachSeq;
	}
	public void setAttachSeq(int attachSeq) {
		this.attachSeq = attachSeq;
	}
	public String getAttachDocType() {
		return attachDocType;
	}
	public void setAttachDocType(String attachDocType) {
		this.attachDocType = attachDocType;
	}
	public int getAttachDocSeq() {
		return attachDocSeq;
	}
	public void setAttachDocSeq(int attachDocSeq) {
		this.attachDocSeq = attachDocSeq;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public String getFakeName() {
		return fakeName;
	}
	public void setFakeName(String fakeName) {
		this.fakeName = fakeName;
	}
	public long getFileSize() {
		return fileSize;
	}
	public void setFileSize(long l) {
		this.fileSize = l;
	}
	public String getContentType() {
		return contentType;
	}
	public void setContentType(String contentType) {
		this.contentType = contentType;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	@Override
	public String toString() {
		return "Attachment [attachSeq=" + attachSeq + ", attachDocType=" + attachDocType + ", attachDocSeq="
				+ attachDocSeq + ", filename=" + filename + ", fakeName=" + fakeName + ", fileSize=" + fileSize
				+ ", contentType=" + contentType + ", createDate=" + createDate + "]";
	}
}