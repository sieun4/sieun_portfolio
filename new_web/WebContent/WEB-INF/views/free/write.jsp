<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- tag library 선언 : c tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>게시물 작성하기</title>
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
		$(document).ready(function() {
			//Tab
			$("#tabs").tabs();
		});

		function doWrite() {
			var title = document.getElementById("board_write_title").value;
			// 	var contents = document.getElementById("contents").value;
			var contents = CKEDITOR.instances['contents'].getData();

			//		유효성 검사는 하나의 항목마다 전부 if로 씀 (if-else if 안 씀)
			if (title == undefined || title == '') { // title == undefined : title가 정의되지 않은 경우
				alert("제목을 입력하세요.");
				$("#board_write_title").focus();
				// 		= document.getElementById("j_userId").focus(); 	// focus() 함수 실행하면 그 곳으로 가서 커서가 깜빡임
				return;
			}
			if (contents == undefined || contents == '') {
				alert("내용을 입력하세요.");
				$("#contents").focus();
				return;
			}

			var frm = document.writeForm;
			//		frm = $('form[name=joinForm]')[0]; (위 문장과 같음)
			frm.action = '/new_web/free/doWrite.do';
			// 	frm.action = '<c:url value="/write.do"/>'
			frm.method = 'post';
			frm.submit();
		}
	</script>
<script src="https://cdn.ckeditor.com/4.9.1/standard/ckeditor.js"></script>
</head>
<body>
	<div id="tabs">
		<ul>
			<li><a href="#tabs-1">자유게시판 작성</a></li>
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
							<!-- 첨부파일 보낼 때 필요함 enctype / 이게 없으면 이름만 감 -->
							<form name="writeForm" enctype="multipart/form-data"
								action="/new_web/doWrite.do" method="post">
								<input type="hidden" name="currentPageNo"
									value="${currentPageNo }" />
								<fieldset>
									<legend>글쓰기</legend>

									<c:if test="${msg != null }">
								${msg }
							</c:if>

									<!-- board write table -->
									<table summary="표 내용은 글쓰기 박스입니다." class="board_write_table">
										<caption>자유게시판 글쓰기 박스</caption>
										<colgroup>
											<col width="20%" />
											<col width="80%" />
										</colgroup>
										<tbody>
											<tr>
												<th class="tright"><label for="board_write_name">작성자</label></th>
												<td class="tleft"><input type="text" id="userId"
													title="이름 입력박스" class="input_100" name="userId"
													value="${sessionScope.nickname }(${sessionScope.userId})"
													readonly="readonly" /></td>
											</tr>
											<tr>
												<th class="tright"><label for="board_write_title">제목</label></th>
												<td class="tleft"><input type="text" name="title"
													id="board_write_title" title="제목 입력박스" class="input_380" />
												</td>
											</tr>
											<tr>
												<th class="tright"><label for="board_write_title">내용</label></th>
												<td class="tleft">
													<div class="editer">
														<p>
															<textarea id="contents" name="contents" rows="25"
																cols="100"></textarea>
															<script>
																CKEDITOR
																		.replace('contents');
															</script>
														</p>
													</div>
												</td>
											</tr>
											<tr>
												<th class="tright"><label for="board_write_file">첨부파일</label></th>
												<td class="tleft"><input type="file" name="file" /><br />
													<input type="file" name="file" /></td>
											</tr>
										</tbody>
									</table>
									<!-- //board write table -->

									<!-- bottom button -->
									<div class="btn_bottom">
										<div class="btn_bottom_right">
											<a
												href="/new_web/free/list.do?currentPageNo=${currentPageNo }">
												<input type="button" value="목록으로" title="목록으로" />
											</a> <input type="button" onclick="doWrite()" value="완료"
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