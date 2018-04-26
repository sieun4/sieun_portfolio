<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- tag library 선언 : c tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>게시글 수정 페이지</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<link rel="stylesheet" type="text/css"
	href="<c:url value="/resources/css/common.css" />" />
<link rel="stylesheet" type="text/css"
	href="<c:url value="/resources/jquery-ui/css/jquery-ui.css" />" />
<link href="https://fonts.googleapis.com/css?family=Gamja+Flower"
	rel="stylesheet"></link>
<style type="text/css">
body {
	margin-right: 0px;
}

.ui-tabs .ui-tabs-panel {
	padding: 0px;
	!
	important;
}
</style>
<script type="text/javascript"
	src="<c:url value="/resources/jquery/js/jquery-3.2.1.js" />"></script>
<script type="text/javascript"
	src="<c:url value="/resources/jquery-ui/js/jquery-ui.js" />"></script>
<script type="text/javascript"
	src="<c:url value="/resources/jquery/js/jquery-migrate-1.4.1.js" />"></script>

<script type="text/javascript">

$(document).ready(function(){
	//Tab
	$( "#tabs" ).tabs();
});

function doUpdate() {
	var title = document.getElementById("board_write_title").value;
// 	var contents = document.getElementById("contents").value;
	var contents = CKEDITOR.instances['contents'].getData();

//		유효성 검사는 하나의 항목마다 전부 if로 씀 (if-else if 안 씀)
	if(title == undefined || title ==''){ 				// title == undefined : title가 정의되지 않은 경우
		alert("제목을 입력하세요.");
		$("#board_write_title").focus();
// 		= document.getElementById("j_userId").focus(); 	// focus() 함수 실행하면 그 곳으로 가서 커서가 깜빡임
		return;
	}
	if(contents == undefined || contents == ''){
		alert("내용을 입력하세요.");
		$("#contents").focus();
		return;
	}
	
	// 데이터 타입 없이 변수 선언할 때는 무조건 var
	// document : body부분의 문서 / readForm : name 속성 값(form)
	var frm = document.updateForm;
	frm.action = "/new_web/free/doUpdate.do";
	frm.method = "POST";
	frm.submit();
}
//삭제
function doDelete(attachSeq){	// 매개변수 데이터타입 필요 없음 (자바 스크립트에는 타입이 존재하지 않음)
	if(confirm("첨부파일을 삭제하시겠습니까?")){
   		window.location.href='/new_web/free/delAttach.do?attachSeq=' + attachSeq + '&currentPageNo=${currentPageNo}';
   	}
}
</script>
<script src="https://cdn.ckeditor.com/4.9.1/standard/ckeditor.js"></script>
</head>
<body>
	<div id="tabs">
		<ul>
			<li><a href="#tabs-1">자유게시판 게시글 수정</a></li>
		</ul>
		<div id="tabs-1">
			<!-- wrap -->
			<div id="wrap">

				<!-- container -->
				<div id="container">

					<!-- content -->
					<div id="content">

						<!-- board_area -->
						<div class="board_area">
							<form name="updateForm" enctype="multipart/form-data">
								<input type="hidden" name="currentPageNo"
									value="${currentPageNo }" />

								<fieldset>
									<legend>게시글 수정</legend>

									<!-- board write table -->
									<table summary="표 내용은 게시글 수정 박스입니다." class="board_write_table">
										<caption>게시글 수정 박스</caption>
										<colgroup>
											<col width="20%" />
											<col width="80%" />
										</colgroup>
										<tbody>
											<tr>
												<th class="tright"><label for="board_write_name">글번호</label></th>
												<td class="tleft"><input type="text" name="seq"
													id="seq" readonly="readonly" value="${board.seq }"
													title="글번호 입력박스" class="input_100" /></td>
											</tr>
											<tr>
												<th class="tright"><label for="board_write_name">작성자</label></th>
												<td class="tleft"><input type="text" name="name"
													id="name" readonly="readonly"
													value="${board.nickname }(${board.userId })"
													title="작성자 입력박스" class="input_100" /></td>
											</tr>
											<tr>
												<th class="tright"><label for="board_write_title">제목</label></th>
												<td class="tleft"><input type="text" name="title"
													id="board_write_title" value="${board.title }"
													title="제목 입력박스" class="input_380" /></td>
											</tr>
											<tr>
												<th class="tright"><label for="board_write_title">내용</label></th>
												<td class="tleft">
													<div class="editer">
														<p>
															<textarea name="contents" rows="30" cols="100">
															<c:out value="${board.contents }" />
															<%-- textarea 안에는 value="${board.contents }"를 적지 않음 --%>
														</textarea>
															<script>
																CKEDITOR.replace('contents');
														</script>
														</p>
													</div>
												</td>
											</tr>
											<tr>
												<th class="tright"><label for="board_write_file">첨부파일</label></th>
												<td colspan="5" class="tleft"><c:choose>
														<c:when test="${att != null }">
															<c:forEach items="${att }" var="att">
																<a
																	href="<c:url value='/free/fileDownload.do?attachSeq=${att.attachSeq }'/>">
																	${att.filename } (<fmt:formatNumber pattern="#,##0"
																		value="${att.fileSize }" /> KB)
																</a>
																<input type="button"
																	onclick="doDelete(${att.attachSeq})" value="삭제"
																	title="삭제" />
																<br />
															</c:forEach>
														</c:when>
														<c:otherwise>
															<input type="file" name="file" />
															<br />
															<input type="file" name="file" />
														</c:otherwise>
													</c:choose></td>
											</tr>
										</tbody>
									</table>
									<!-- //board write table -->

									<!-- bottom button -->
									<div class="btn_bottom">
										<div class="btn_bottom_right">
											<a
												href="/new_web/free/read.do?currentPageNo=${currentPageNo }&seq=${board.seq}">
												<input type="button" value="취소" title="취소" />
											</a> <input type="button" onclick="doUpdate()" value="완료"
												title="완료" />
										</div>
									</div>
									<!-- //bottom button -->

								</fieldset>
							</form>
						</div>
						<!-- //board_area -->

					</div>
					<!-- //content -->

				</div>
				<!-- //container -->

			</div>
			<!-- //wrap -->
		</div>
	</div>

</body>
</html>