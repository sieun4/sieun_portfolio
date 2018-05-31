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
	function doUpdate() {
		var seq = $("#seq").val();
		var friendName = $("#friendName").val();
		
		if(friendName == undefined || friendName == ''){
			alert("친구이름을 입력하세요.");
			$("#friendName").focus();
			return;
		}
		
		$.ajax({ // ajax라는 함수 호출. {}안은 전부 매개변수
			url : '/new_web/friend/doUpdate.do', // 호출할 URL
			type : "post", // GET / POST 방식
			data : {
				'seq' : seq,
				'friendName' : friendName,
				'memo' : $("#memo").val()
			}, // 파라미터 {'이름', 변수(var)}
			// 바로 값을 넣을 땐 {'이름', '값'}
			success : function(result, textStatus, jqXHR) { // 콜백 함수
				if (result == 1) { 					// 정상적으로 수정 완료
					window.opener.location.href = "/new_web/friend/list.do";
					self.close();
				} else { 							// 오류가 났을 경우
					alert("오류가 발생했습니다. 관리자에게 문의해 주세요.");
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				console.log(jqXHR);
				console.log(textStatus);
				console.log(errorThrown);
			}
		});
	}

	$(document).ready(function() {
		//Tab
		$("#tabs").tabs();
	});
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
								
								<input type="hidden" id="seq" name="seq" value="${friend.seq }" />
								
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
												<td><input type="text" name="friendId" id="friendId"
													readonly="readonly" value="${friend.friendId }"
													title="친구 아이디 입력박스" class="input_380" /></td>
											</tr>
											<tr>
												<th>친구 이름</th>
												<td><input type="text" name="friendName"
													id="friendName" value="${friend.friendName }"
													title="친구 이름 입력박스" class="input_380" /></td>
											</tr>
											<tr>
												<th>메모</th>
												<td><input type="text" name="memo" id="memo"
													value="${friend.memo }" title="메모 입력박스" class="input_380" /></td>
											</tr>
										</tbody>
									</table>
									<br />

									<div class="btn_bottom">
										<div class="btn_bottom_right">
											<input type="button" onclick="doUpdate()" value="완료"
												title="완료" />
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