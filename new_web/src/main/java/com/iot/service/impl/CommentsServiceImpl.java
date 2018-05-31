package com.iot.service.impl;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.iot.dao.CommentsDao;
import com.iot.dao.FreeBoardDao;
import com.iot.dto.Comments;
import com.iot.service.CommentsService;

@Service("commentsServiceImpl")
@Transactional(rollbackFor= {Exception.class})	// error가 생기면 메서드 전체 rollback
public class CommentsServiceImpl implements CommentsService {

	@Autowired
	CommentsDao dao;

	@Autowired
	FreeBoardDao fDao;

	@Override	// 댓글 목록
	public ArrayList<Comments> getComment(int commentDocSeq) {
		return dao.getComment(commentDocSeq);
	}

	@Override	// 댓글 쓰기
	public int write(Comments c) throws Exception {
		int hasCo = fDao.writeHasCo(c.getCommentDocSeq());	// 댓글 갯수 수정
		if(hasCo != 1) throw new Exception("댓글 갯수 수정 오류!!!");
		int result = dao.write(c);		// 댓글 저장
		if(result != 1) throw new Exception("댓글 저장 오류!!!!");		// 오류나면 콘솔에 출력
		return result;
	}

	@Override	// 댓글 삭제
	public int delete(int commentSeq, int seq) throws Exception {
		int hasCo = fDao.delHasCo(seq);		// 댓글 갯수 수정
		if(hasCo != 1) throw new Exception("댓글 갯수 수정 오류!!!!");
		int result = dao.delete(commentSeq);	// 댓글 삭제
		if(result != 1) throw new Exception("댓글 삭제 오류!!!!");
		return result;
	}
}
