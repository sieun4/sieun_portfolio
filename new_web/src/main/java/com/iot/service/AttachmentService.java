package com.iot.service;

import java.util.ArrayList;

import com.iot.dto.Attachment;

public interface AttachmentService {

	public ArrayList<Attachment> getAttachment(String docType, int seq);

	public Attachment download(int attachSeq);

}
