package com.iot.service.impl;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.iot.dao.AttachmentDao;
import com.iot.dto.Attachment;
import com.iot.service.AttachmentService;

@Service("attachmentService")
public class AttachmentServiceImpl implements AttachmentService {

	@Autowired
	AttachmentDao dao;
	
	@Override	// 해당 게시글의 첨부파일 모두 가져오기
	public ArrayList<Attachment> getAttachment(String docType, int seq) {
		return dao.getAttachment(docType, seq);
	}

	@Override	// 첨부파일 다운로드
	public Attachment download(int attachSeq) {
		return dao.download(attachSeq);
	}

}
