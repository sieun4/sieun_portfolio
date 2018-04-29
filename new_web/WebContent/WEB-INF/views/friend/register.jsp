<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- tag library 선언 : c tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html lang="kr">
<head>
<meta charset="UTF-8">
<title>새친구 추가</title>
<link rel="stylesheet" type="text/css"
	href="<c:url value="/resources/css/login.css" />" />
<link href="https://fonts.googleapis.com/css?family=Gamja+Flower"
	rel="stylesheet">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script type="text/javascript">
	function doRegister() {

		var friendId = document.getElementById("friendId").value; // <input id="j_userId"/>
		var friendName = document.getElementById("friendName").value; // <input id="j_userId"/>

		// 		유효성 검사는 하나의 항목마다 전부 if로 씀 (if-else if 안 씀)
		if (friendId == undefined || friendId == '') { // userId == undefined : userId가 정의되지 않은 경우
			alert("친구의 아이디를 입력하세요.");
			$("#friendId").focus();
			return;
		}
		if (friendName == undefined || friendName == '') {
			alert("친구의 이름을 입력하세요");
			$("#friendName").focus();
			return;
		}

		// ajax 이용하여 ID 확인 후 존재하는 ID일 때 폼 전송
		$.ajax({ // ajax라는 함수 호출. {}안은 전부 매개변수
			url : '/new_web/friend/doRegister.do', // 호출할 URL
			type : "post", // GET / POST 방식
			data : {
				'friendId' : friendId,
				'friendName' : friendName,
				'memo' : $("#memo").val()
			}, // 파라미터 {'이름', 변수(var)}
			// 바로 값을 넣을 땐 {'이름', '값'}
			success : function(result, textStatus, jqXHR) { // 콜백 함수
				if (result == 0) { // 해당되는 ID가 없음
					alert("존재하지 않는 회원 아이디입니다."); // 경고창
					$("#friendId").focus(); // 커서를 ID 입력하는 곳으로 이동
				} else if (result == 1) {
					alert("이미 등록된 친구 아이디입니다.");
					$("#friendId").focus(); // 커서를 ID 입력하는 곳으로 이동
				} else if (result == 2) {
					alert("아이디에 영문 대문자는 사용할 수 없습니다."); // 경고창
					$("#friendId").focus(); // 커서를 ID 입력하는 곳으로 이동
				} else if (result == 3) {
					alert("새친구 추가 중 오류가 발생했습니다. 관리자에게 문의해 주세요.");
				} else { // 새친구 등록이 정상적으로 완료되었을 경우
					window.opener.location.href = "/new_web/friend/list.do";
					self.close();
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				console.log(jqXHR);
				console.log(textStatus);
				console.log(errorThrown);
			}
		});
	}

	function redirectToFB() {
		window.opener.location.href = "/new_web/friend/list.do";
		self.close();
	}
</script>
</head>
<body>
	<div class="form-wrapper">
		<h1>새친구 추가</h1>
		<form name="registerForm">
			<div class="form-item">
				<label for="friendId"></label> <input type="text" name="friendId"
					id="friendId" required="required" placeholder="친구 아이디(필수)" />
			</div>
			<div class="form-item">
				<label for="friendName"></label> <input type="text" id="friendName"
					name="friendName" required="required" placeholder="친구 이름(필수)"></input>
			</div>
			<div class="form-item">
				<label for="memo"></label> <input type="text" id="memo" name="memo"
					required="required" placeholder="메모(선택)"></input>
			</div>
			<div class="button-panel">
				<input onclick="doRegister()" class="button" title="Register"
					value="추가" />
			</div>
		</form>

		<div class="form-footer"></div>
	</div>
	<br />
</body>
</html>