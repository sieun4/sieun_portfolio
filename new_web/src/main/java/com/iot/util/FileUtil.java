package com.iot.util;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import com.iot.dto.Attachment;

@Component
public class FileUtil {
	
	@Value("${file.upload.directory}")
	private String fileUploadDirectory;		// 파일 주소

	// 내 컴퓨터에서만 접속할 때
//	private String fileUploadDirectory = "c:/tmp/upload";
	// 주소 배포할 때
//	private String fileUploadDirectory = "/home/ubuntu/app/upload/pf";
	
	private static Logger logger = Logger.getLogger(FileUtil.class);

	/**
	 * 첨부파일을 서버 물리 저장소에 복사
	 * @param files
	 */
	public void copyToFolder(MultipartFile files, String fakeName) {
		File target = new File(fileUploadDirectory);
		if(!target.exists())	// 저장소가 존재하지 않는다면
			target.mkdirs();	// 지정한 주소에 맞춰 폴더 생성
		target = new File(target, fakeName);

		// 물리저장소에 파일 쓰기
		try {	
			// 파일 복사하기 FileCopyUtils.copy(파일변수명.getBytes(), 지정한 위치에 지정한 이름으로);
			FileCopyUtils.copy(files.getBytes(), target);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 게시글을 읽을 때 첨부파일 다운로드 받기
	 * @param att
	 * @param rep
	 * @return 
	 */
	public byte[] download(Attachment att, HttpServletResponse rep) {
		// response에 정보 입력
		String uploadDir = fileUploadDirectory;
		File file = new File(uploadDir + "/" + att.getFakeName());
		rep.setContentType(att.getContentType());
		// 한글 파일명 인코딩
		String encodingName;
		byte[] b = null;
		try {
			encodingName = java.net.URLEncoder.encode(att.getFilename(), "UTF-8");
			rep.setContentType(att.getContentType());
			rep.setHeader("Content-Disposition", "attachment; filename=\"" + encodingName + "\"");
			rep.setHeader("paragma", "no-cache");
			rep.setHeader("Cache-Control", "no-cache");
			rep.setContentLength((int) att.getFileSize());
			b = FileUtils.readFileToByteArray(file);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return b;
	}
	
	/**
	 * 게시글 수정할 때 파일만 삭제 / 게시글 삭제할 때 파일도 삭제
	 * @param a
	 */
	public void delete(Attachment a) {
		File f = new File(fileUploadDirectory, a.getFakeName());
		f.delete();	// 파일 삭제
	}
}