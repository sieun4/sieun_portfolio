package com.iot.dao;

import java.util.ArrayList;

import com.iot.dto.Attachment;

public interface AttachmentDao {

	public ArrayList<Attachment> getAttachment(String docType, int seq);

	public int insert(Attachment att);

	public int delete(int attachSeq);

	public Attachment download(int attachSeq);

}
