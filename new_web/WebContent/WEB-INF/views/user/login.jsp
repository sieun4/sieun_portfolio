<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- tag library 선언 : c tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html lang="kr">
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="stylesheet" type="text/css"
	href="<c:url value="/resources/css/login.css" />" />
<link href="https://fonts.googleapis.com/css?family=Gamja+Flower"
	rel="stylesheet">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script type="text/javascript">
	$(document)
			.ready(
					function() {
						var panelOne = $('.form-panel.two').height(), panelTwo = $('.form-panel.two')[0].scrollHeight;

						$('.form-panel.two').not('.form-panel.two.active').on(
								'click', function(e) {
									e.preventDefault();

									$('.form-toggle').addClass('visible');
									$('.form-panel.one').addClass('hidden');
									$('.form-panel.two').addClass('active');
									$('.form').animate({
										'height' : panelTwo
									}, 200);
								});

						$('.form-toggle').on('click', function(e) {
							e.preventDefault();
							$(this).removeClass('visible');
							$('.form-panel.one').removeClass('hidden');
							$('.form-panel.two').removeClass('active');
							$('.form').animate({
								'height' : panelOne
							}, 200);
						});
					});

	function doLogin() {

		var userId = document.getElementById("j_userId").value; // <input id="j_userId"/>
		var password = document.getElementById("j_userPw").value;

		// 		유효성 검사는 하나의 항목마다 전부 if로 씀 (if-else if 안 씀)
		if (userId == undefined || userId == '') { // userId == undefined : userId가 정의되지 않은 경우
			alert("아이디를 입력하세요.");
			document.getElementById("j_userId").focus(); // focus() 함수 실행하면 그 곳으로 가서 커서가 깜빡임
			// 			= $("#j_userId").focus();
			return;
		}
		if (password == undefined || password == '') {
			alert("비밀번호를 입력하세요");
			$("#j_userPw").focus();
			return;
		}

		// ajax 이용하여 ID 확인 후 존재하는 ID일 때 폼 전송
		$.ajax({ // ajax라는 함수 호출. {}안은 전부 매개변수
			url : '/new_web/chkId.do', // 호출할 URL
			type : "post", // GET / POST 방식
			data : {
				'userId' : userId
			}, // 파라미터 {'이름', 변수(var)}
			// 바로 값을 넣을 땐 {'이름', '값'}
			success : function(result, textStatus, jqXHR) { // 콜백 함수
				if (result == 0) { // 해당되는 ID가 없음
					alert("존재하지 않는 회원ID입니다."); // 경고창
					$("#j_userId").focus(); // 커서를 ID 입력하는 곳으로 이동
				} else if (result == 2) {
					alert("ID에 영문 대문자는 사용할 수 없습니다.");
					$("#j_userId").focus(); // 커서를 ID 입력하는 곳으로 이동
				} else { // 중복 또는 문제가 있음
					var frm = document.loginForm;
					frm.action = '/new_web/doLogin.do';
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
</script>
</head>
<body>
	<div class="form-wrapper">
		<h1>로그인</h1>
		<form name="loginForm">
			<div class="form-item">
				<label for="userId"></label> <input type="text" name="userId"
					id="j_userId" required="required" placeholder="아이디" />
			</div>
			<div class="form-item">
				<label for="password"></label> <input type="password" id="j_userPw"
					name="password" required="required" placeholder="비밀번호"></input>
			</div>
			<div class="button-panel">
				<input onclick="doLogin()" class="button" title="Sign In"
					value="로그인"></input>
			</div>
		</form>
		<div class="form-footer">
			<p>
				<a href='<c:url value="/goJoin.do"/>'>회원 가입</a>
			</p>
			<p>
				<a href='<c:url value="/index.do"/>'>홈 화면</a>
			</p>
		</div>
	</div>
	<br />
</body>
</html>
