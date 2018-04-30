<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- tag library 선언 : c tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>편지 작성하기</title>
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
		var toId = document.getElementById("board_write_toId").value;
		var title = document.getElementById("board_write_title").value;
		// 	var contents = document.getElementById("contents").value;
		var text = CKEDITOR.instances['text'].getData();

		//		유효성 검사는 하나의 항목마다 전부 if로 씀 (if-else if 안 씀)
		if (toId == undefined || toId == '') {
			alert("받는분의 ID를 입력하세요.");
			$("#board_write_toId").focus();
			return;
		}
		if (title == undefined || title == '') { // title == undefined : title가 정의되지 않은 경우
			alert("제목을 입력하세요.");
			$("#board_write_title").focus();
			// 		= document.getElementById("j_userId").focus(); 	// focus() 함수 실행하면 그 곳으로 가서 커서가 깜빡임
			return;
		}
		if (text == undefined || text == '') {
			alert("내용을 입력하세요.");
			$("#text").focus();
			return;
		}

		// ajax 이용하여 ID 확인 후 존재하는 ID일 때 폼 전송
		$.ajax({ // ajax라는 함수 호출. {}안은 전부 매개변수
			url : '/new_web/chkId.do', // 호출할 URL
			type : "post", // GET / POST 방식
			data : {
				'userId' : toId
			}, // 파라미터 {'이름', 변수(var)}
			// 바로 값을 넣을 땐 {'이름', '값'}
			success : function(result, textStatus, jqXHR) { // 콜백 함수
				if (result == 0) { // 해당되는 ID가 없음
					alert("존재하지 않는 회원ID입니다."); // 경고창
					$("#board_write_toId").focus(); // 커서를 ID 입력하는 곳으로 이동
				} else if (result == 2) {
					alert("받는 사람 ID에 대문자는 사용할 수 없습니다.");
					$("#board_write_toId").focus(); // 커서를 ID 입력하는 곳으로 이동
				} else { // 중복 또는 문제가 있음
					var frm = document.writeForm;
					frm.action = '/new_web/letter/doWrite.do';
					frm.method = 'post';
					frm.submit();
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				console.log(jqXHR);
				console.log(textStatus);
				console.log(errorThrown);
			}
		});
	}

	function popupOpen() {
		var popUrl = "<c:url value="/friend/list.do?letter="/>" + "letter"; //팝업창에 출력될 페이지 URL
		var popOption = "width=400, height=400, resizable=no, scrollbars=no, status=no;"; //팝업창 옵션(optoin)
		window.open(popUrl, "", popOption);
	}
</script>
<script src="https://cdn.ckeditor.com/4.9.1/standard/ckeditor.js"></script>
</head>
<body>
	<div id="tabs" align="center">
		<br />편지 쓰기
		<div id="tabs-1">
			<!-- wrap -->
			<div id="wrap">

				<!-- container -->
				<div id="container">

					<!-- content -->
					<div id="content">

						<!-- board_area -->
						<div class="board_area">
							<form name="writeForm">
								<input type="hidden" name="currentPageNo"
									value="${currentPageNo }" />
								<fieldset>
									<legend>편지쓰기</legend>

									<c:if test="${msg != null }">
										${msg }
									</c:if>

									<!-- board write table -->
									<table summary="표 내용은 편지쓰기 박스입니다." class="board_write_table">
										<caption>편지쓰기 박스</caption>
										<colgroup>
											<col width="20%" />
											<col width="80%" />
										</colgroup>
										<tbody>
											<tr>
												<th class="tright"><label for="board_write_toId">받는
														사람 ID</label></th>
												<td class="tleft">
												<c:choose>
													<c:when test="${toId != null}">
														<input type="text" name="toId" id="board_write_toId" 
															value="${toId }" title="받는 사람 ID 입력박스" class="input_100" />
													</c:when>
													<c:otherwise>
														<input type="text" name="toId"
														id="board_write_toId" title="받는 사람 ID 입력박스"
														class="input_100" /> 
													</c:otherwise>
												</c:choose>
												<input type="button"
													onclick="popupOpen()" value="주소록" title="주소록" /></td>
											</tr>
											<tr>
												<th class="tright"><label for="board_write_title">제목</label></th>
												<td class="tleft"><input type="text" name="title"
													id="board_write_title" title="제목 입력박스" class="input_550" />
												</td>
											</tr>
											<tr>
												<th class="tright"><label for="board_write_text">내용</label></th>
												<td class="tleft">
													<div class="editer">
														<p>
															<textarea id="text" name="text" rows="25" cols="100"></textarea>
															<script>
																CKEDITOR
																		.replace('text');
															</script>
														</p>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
									<!-- //board write table -->

									<!-- bottom button -->
									<div class="btn_bottom">
										<div class="btn_bottom_right">
											<input type="button" onclick="window.history.back()"
												value="취소" title="취소" /> <input type="button"
												onclick="doWrite()" value="완료" title="완료" />
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