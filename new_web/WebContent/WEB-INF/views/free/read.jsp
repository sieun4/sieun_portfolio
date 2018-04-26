<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- tag library 선언 : c tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- tag library 선언 : fmt tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>게시물 목록페이지</title>
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
// 자바 스크립트 영역
// 댓글 삭제하기
function delComment(commentSeq){
// 	if(confirm("댓글을 삭제하시겠습니까?")){
// 		// 데이터 타입 없이 변수 선언할 때는 무조건 var
// 		// document : body부분의 문서 / readForm : name 속성 값(form)
// 		var frm = document.readForm;
// 		frm.action = "/web_portfolio/delComment.do";
// 		frm.method = "POST";
// 		frm.submit();
// 	}
	if(confirm("댓글을 삭제하시겠습니까?")){
   		window.location.href='/new_web/free/delComment.do?commentSeq=' + commentSeq + '&seq=${board.seq}' + '&currentPageNo=${currentPageNo}';
   	}
}
// 댓글달기
function writeComment(){
	var comment = document.getElementById("comment").value;
	if(comment == undefined || comment == ''){
		alert("댓글 내용을 입력하세요.");
		$("#comment").focus();
		return;
	}
	var frm = document.readForm;
	frm.action = "/new_web/free/writeComment.do";
	frm.method = 'POST';					// ""와 ''는 같음 (String 입력할 때)
	frm.submit();
}
// 수정
function goUpdate(){
	var password = document.getElementById("password").value;

//		유효성 검사는 하나의 항목마다 전부 if로 씀 (if-else if 안 씀)
	if(password == undefined || password ==''){ 				// title == undefined : title가 정의되지 않은 경우
		alert("비밀번호를 입력하세요.");
		$("#password").focus();
// 		= document.getElementById("password").focus(); 	// focus() 함수 실행하면 그 곳으로 가서 커서가 깜빡임
		return;
	}
	var frm = document.readForm;
	frm.action = "/new_web/free/goUpdate.do";
	frm.method = 'POST';					// ""와 ''는 같음 (String 입력할 때)
	frm.submit();
}

// 삭제
function doDelete(){
	var password = document.getElementById("password").value;

		//	유효성 검사는 하나의 항목마다 전부 if로 씀 (if-else if 안 씀)
		if (password == undefined || password == '') { // title == undefined : title가 정의되지 않은 경우
			alert("비밀번호를 입력하세요.");
			$("#password").focus();
			//		= document.getElementById("password").focus(); 	// focus() 함수 실행하면 그 곳으로 가서 커서가 깜빡임
			return;
		}
		if(confirm("게시글을 삭제하시겠습니까?")){
		// 데이터 타입 없이 변수 선언할 때는 무조건 var
		// document : body부분의 문서 / readForm : name 속성 값(form)
		var frm = document.readForm;
		frm.action = "/new_web/free/delete.do";
		frm.method = "POST";
		frm.submit();
		}
}
	$(document).ready(function() {
		//Tab
		$("#tabs").tabs();
	});
</script>
</head>
<body>
	<div id="tabs">
		<ul>
			<li><a href="#tabs-1">자유게시판</a></li>
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
							<form name="readForm">
								<input type="hidden" name="seq" value="${board.seq }" /> <input
									type="hidden" name="currentPageNo" value="${currentPageNo }" />
								<fieldset>
									<legend>자유게시판 글 읽기</legend>

									<!-- board detail table -->
									<table summary="표 내용은 Ses & Food 게시물의 상세 내용입니다."
										class="board_detail_table">
										<caption>자유게시판 글 읽기</caption>
										<colgroup>
											<col width="20%" />
											<col width="40%" />
											<col width="20%" />
											<col width="20%" />
										</colgroup>
										<tbody>
											<tr>
												<th class="tright">제목</th>
												<td colspan="5" class="tleft"><c:out
														value="${board.title }" /></td>
											</tr>
											<tr>
												<th class="tright">작성자</th>
												<td colspan="5" class="tleft"><c:out
														value="${board.nickname }" />(<c:out
														value="${board.userId }" />)</td>
											</tr>
											<tr>
												<th class="tright">작성일</th>
												<td><c:out value="${board.writeDate }" /></td>
												<th class="tright">조회수</th>
												<td class="tright"><c:out value="${board.hits }" /></td>
											</tr>
											<tr>
												<td colspan="6" class="tleft">${board.contents }
													<div class="body"></div>
												</td>
											</tr>
											<tr>
												<th class="tright">첨부파일</th>
												<td colspan="5" class="tleft"><c:forEach
														items="${att }" var="att">
														<a
															href="<c:url value='/free/fileDownload.do?attachSeq=${att.attachSeq }'/>">
															${att.filename } (<fmt:formatNumber pattern="#,##0"
																value="${att.fileSize }" /> KB)
														</a>
														<br />
													</c:forEach></td>
											</tr>
											<c:if test="${sessionScope.userId == board.userId }">
												<!-- 본인이 쓴 글 볼 때 -->
												<tr>
													<th class="tright">비밀번호</th>
													<td colspan="5" class="tleft"><input type="password"
														name="password" id="password" title="비밀번호 입력박스"
														class="input_100" /> <c:if test="${msg != null }">
														${msg }
														</c:if></td>
												</tr>
											</c:if>
										</tbody>
									</table>
									<br />

									<div class="btn_bottom">
										<!-- 									<div class="btn_bottom_left"> -->
										<!-- 										<input type="button" value="추천하기" title="추천하기" /> -->
										<!-- 									</div> -->
										<div class="btn_bottom_right">
											<c:if test="${sessionScope.userId == board.userId }">
												<!-- 본인이 쓴 글 볼 때 -->
												<input type="button" onclick="goUpdate()" value="수정"
													title="수정" />
												<input type="button" onclick="doDelete()" value="삭제"
													title="삭제" />
											</c:if>
											<a
												href="/new_web/free/list.do?currentPageNo=${currentPageNo }">
												<input type="button" value="목록" title="목록" />
											</a>
										</div>
									</div>
									<br />
									<br />
									<br />

									<table>
										<!-- 댓글 -->
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="70%" />
										</colgroup>
										<tbody>
											<tr>
												<th colspan="3" class="tleft">댓글(<c:out
														value="${board.hasComment}" />)
												</th>
											</tr>
											<c:forEach items="${c }" var="c">
												<tr>
													<td><c:out value="${c.writeDate}" /></td>
													<td><c:out value="${c.nickname}" />(<c:out
															value="${c.userId }" />)</td>
													<td class="tleft"><c:out value="${c.comment}" /> <c:if
															test="${sessionScope.userId == c.userId }">
															<div class="btn_bottom_right">
																<input type="button"
																	onclick="delComment(${c.commentSeq})" value="삭제"
																	title="댓글삭제" />
															</div>
														</c:if></td>
												</tr>
											</c:forEach>
											<c:if test="${sessionScope.userId != null }">
												<tr>
													<th colspan="2"><c:out
															value="${sessionScope.nickname}" />(<c:out
															value="${sessionScope.userId }" />)</th>
													<td class="tleft"><input type="text" name="comment"
														id="comment" title="댓글 입력박스" class="input_400" />
														<div class="btn_bottom_right">
															<input type="button" onclick="writeComment()" value="등록"
																title="댓글달기" />
														</div></td>
												</tr>
											</c:if>
											<c:if test="${sessionScope.userId == null }">
												<tr>
													<th colspan="3" class="tcenter">로그인하시면 댓글을 작성할 수 있습니다.</th>
												</tr>
											</c:if>
										</tbody>
									</table>

									<!-- //board detail table -->

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