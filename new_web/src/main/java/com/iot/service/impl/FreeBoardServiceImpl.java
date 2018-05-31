package com.iot.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.iot.dao.AttachmentDao;
import com.iot.dao.CommentsDao;
import com.iot.dao.FreeBoardDao;
import com.iot.dao.UserDao;
import com.iot.dto.FreeBoard;
import com.iot.dto.User;
import com.iot.exception.AnomalyException;
import com.iot.dto.Attachment;
import com.iot.service.FreeBoardService;
import com.iot.util.FileUtil;

@Service("freeBoardService")
@Transactional(rollbackFor= {Exception.class})
public class FreeBoardServiceImpl implements FreeBoardService {

	@Autowired
	FreeBoardDao dao;

	@Autowired
	AttachmentDao aDao;

	@Autowired
	UserDao uDao;

	@Autowired
	CommentsDao cDao;

	@Autowired
	FileUtil fileUtil;

	@Override	// 게시글 수 카운트
	public int count(HashMap<String, Object> params) {	
		return dao.count(params);
	}

	@Override	// 게시글 목록
	public ArrayList<FreeBoard> paging(HashMap<String, Object> params) {
		return dao.paging(params);
	}	

	@Override	// 게시글 읽기
	public FreeBoard read(int seq) throws Exception {
		// 특정 게시글의 조회수 증가
		int result = dao.updateHits(seq);
		// 에외가 발생한 경우 더 이상 코드가 실행되지 않고 호출한 service로
		if(result != 1) throw new Exception("조회수 증가 오류!!!!"); 

		// 특정 게시글 (조회수 증가 후) 조회
		FreeBoard board = dao.findBySeq(seq);
		return board;
	}	

	@Override	// 글 쓰기
	public void write(FreeBoard board, List<MultipartFile> files) {
		dao.write(board);						// 게시글 DB에 입력
		if(board.getHasFile().equals("1")) {	// 파일이 있는 경우
			for(MultipartFile f : files) {
				if(!f.isEmpty()) {				// 파일 수만큼 for문 반복
					Attachment att = new Attachment();
					att.setAttachDocType("free");
					att.setAttachDocSeq(board.getSeq());
					att.setFilename(f.getOriginalFilename());
					att.setFileSize(f.getSize());
					String fakeName = UUID.randomUUID().toString();
					att.setFakeName(fakeName);
					aDao.insert(att);					// 첨부파일 정보 DB에 입력
					fileUtil.copyToFolder(f, fakeName);	// 실제 파일 복사
				}
			}
		}
	}

	@Override	// 게시글 삭제
	public void delete(int seq, String userId, String password) throws Exception {
		// 사용자가 입력한 비밀번호 암호화
		String encryptedPw = uDao.encPw(password);
		// 삭제할 게시글
		FreeBoard board = dao.findBySeq(seq);	
		// 비밀번호 비교
		User user = uDao.getUser(userId);
		if(encryptedPw.equals(user.getUserPw())) {	// 비밀번호가 맞으면 지우기
			// 게시글 지우기
			int fResult = dao.delete(seq);
			if(fResult != 1) throw new Exception("DELETE_ANOMALY");		// 삭제 이상
			// 삭제할 첨부파일 가져오기
			ArrayList<Attachment> att = aDao.getAttachment("free", seq);
			for(Attachment a : att) {	// 첨부파일 삭제하기
				int aResult = aDao.delete(a.getAttachSeq());			// 첨부파일 DB에서 삭제
				if(aResult != 1) throw new Exception("DELETE_ANOMALY");	// 삭제 이상	
				fileUtil.delete(a);	// 저장된 실제 첨부파일 삭제하기
			}
			// 댓글 삭제
			cDao.deleteAll(seq);
		}
		else {	// 비밀번호가 다름
			throw new Exception("NOT_EQ_PASSWORD");
		}
	}

	@Override	// 글 수정하기 위해 비밀번호 비교하고 게시글 불러오기
	public FreeBoard goUpDate(int seq, String userId, String password, String pass) throws Exception {
		// 사용자가 입력한 비밀번호 암호화
		String encryptedPw = uDao.encPw(password);
		// 수정할 게시글
		FreeBoard board = dao.findBySeq(seq);
		// 비밀번호 비교
		User user = uDao.getUser(userId);
		if(!pass.equals("true") && !encryptedPw.equals(user.getUserPw())) {	// 비밀번호가 틀리면
			throw new Exception("NOT_EQ_PASSWORD");
		}
		return board;	
	}

	@Override	// 수정 완료된 글 저장
	public int update(FreeBoard board, List<MultipartFile> files) throws Exception {
		int result = dao.update(board);			// FreeBoard DB Update
		if(result != 1) throw new AnomalyException(1, result); // (기대값, 실제값)
		int seq = board.getSeq();				
		if(files != null) {						// 첨부파일이 있다면
			for(MultipartFile f : files) {		
				if(!f.isEmpty()) {				// file이 있는만큼 for문 돌리기
					Attachment att = new Attachment();	// Attachment DB에 값 넣기
					att.setAttachDocType("free");
					att.setAttachDocSeq(seq);
					att.setFilename(f.getOriginalFilename());
					att.setFileSize(f.getSize());
					String fakeName = UUID.randomUUID().toString();
					att.setFakeName(fakeName);
					aDao.insert(att);
					fileUtil.copyToFolder(f, fakeName);
				}
			}
		}
		return result;	
	}
	
	@Override	// 게시글 정보 가져오기 (읽기)
	public FreeBoard findBySeq(int seq) {	
		return dao.findBySeq(seq);
	}

	@Override	// 첨부파일 삭제
	public int delAttachedFile(int attachSeq) throws Exception {
		Attachment att = aDao.download(attachSeq);	// 첨부파일 정보 가져오기
		int seq = att.getAttachDocSeq();			// 게시글 seq 가져오기
		FreeBoard board = dao.findBySeq(seq);		// seq로 해당 게시글 정보 가져오기
		aDao.delete(attachSeq);						// 첨부파일 정보 지우기
		List<Attachment> remain = aDao.getAttachment("free", seq);	// 남은 첨부파일 정보 조회
		if(remain.size() == 0) {			// 남은 첨부파일이 없다면
			board.setHasFile("0");			// hasFile 값을 0으로 변경
			dao.update(board); 				// 변경된 값으로 DB update 
		}
		fileUtil.delete(att);	// 실제 파일 삭제
		return seq;
	}
}
