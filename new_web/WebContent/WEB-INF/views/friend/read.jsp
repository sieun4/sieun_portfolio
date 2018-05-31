<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- tag library 선언 : c tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- tag library 선언 : fmt tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>친구 정보</title>
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
	// 수정
	function goUpdate() {
		var frm = document.readForm;
		frm.action = "/new_web/friend/goUpdate.do";
		frm.method = 'POST';
		frm.submit();
	}

	// 삭제
	function doDelete(seq) {
		if (confirm("해당 친구를 주소록에서 삭제하시겠습니까?")) {
			$.ajax({ // ajax라는 함수 호출. {}안은 전부 매개변수
				url : '/new_web/friend/delete.do', // 호출할 URL
				type : "post", // GET / POST 방식
				data : {
					'seq' : seq
				}, // 파라미터 {'이름', 변수(var)}
				// 바로 값을 넣을 땐 {'이름', '값'}
				success : function(result, textStatus, jqXHR) { // 콜백 함수
					if (result == 1) { // 정상적으로 삭제되었을 경우
						window.opener.location.href = "/new_web/friend/list.do";
						self.close();
					} else { // 삭제하던 중 오류가 발생한 경우
						alert("오류가 발생했습니다. 관리자에게 문의해 주세요."); // 알림창
					}
				},
				error : function(jqXHR, textStatus, errorThrown) {
					console.log(jqXHR);
					console.log(textStatus);
					console.log(errorThrown);
				}
			});
		}
	}

	$(document).ready(function() {
		//Tab
		$("#tabs").tabs();
	});
	
	// 편지쓰기
	function goWrite() {
		window.opener.location.href = "/new_web/letter/goWrite.do?toId=${friend.friendId}";
		self.close();
	}
</script>
</head>
<body>
	<div id="tabs" align="center">
		<br />친구 정보
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
								<input type="hidden" name="seq" value="${friend.seq }" />
								<fieldset>
									<legend>친구 정보</legend>

									<!-- board detail table -->
									<table class="board_detail_table">
										<caption>친구 정보</caption>
										<colgroup>
											<col width="30%" />
											<col width="70%" />
										</colgroup>
										<tbody>
											<tr>
												<th>친구 아이디</th>
												<td colspan="5"><c:out value="${friend.friendId }" /></td>
											</tr>
											<tr>
												<th>친구 이름</th>
												<td colspan="5"><c:out value="${friend.friendName }" /></td>
											</tr>
											<tr>
												<th>메모</th>
												<td><c:out value="${friend.memo }" /></td>
											</tr>
										</tbody>
									</table>
									<br />

									<div class="btn_bottom">
										<div class="btn_bottom_left">
											<input type="button" onclick="goWrite()" value="편지쓰기"
												title="편지쓰기" />
										</div>
										<div class="btn_bottom_right">
											<input type="button" onclick="goUpdate()" value="수정"
												title="수정" /> <input type="button"
												onclick="doDelete(${friend.seq})" value="삭제" title="삭제" />
										</div>
									</div>
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