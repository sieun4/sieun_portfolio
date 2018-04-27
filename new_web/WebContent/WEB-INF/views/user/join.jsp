<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- tag library 선언 : c tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html lang="kr">
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link rel="stylesheet" type="text/css"
	href="<c:url value="/resources/css/login.css" />" />
<link href="https://fonts.googleapis.com/css?family=Gamja+Flower"
	rel="stylesheet">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script type="text/javascript">
	$(document).ready(
			function() {
				$('.form-panel.two').not('.form-panel.two.active').on('click',
						function(e) {
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

	function doJoin() {
		var userId = document.getElementById("j_userId").value; // <input id="j_userId"/>
		var password = document.getElementById("j_userPw").value;
		// 		var password = $('#j_userPw').val(); // #을 쓰면 id로 인식 
		var cPassword = document.getElementById("j_cUserPw").value;
		var userName = document.getElementById("j_userName").value;
		var nickname = document.getElementById("j_nickname").value;

		// 		유효성 검사는 하나의 항목마다 전부 if로 씀 (if-else if 안 씀)
		if (userId == undefined || userId == '') { // userId == undefined : userId가 정의되지 않은 경우
			alert("ID를 입력하세요.");
			document.getElementById("j_userId").focus(); // focus() 함수 실행하면 그 곳으로 가서 커서가 깜빡임
			// 			= $("#j_userId").focus();
			return;
		}
		if (password == undefined || password == '') {
			alert("PASSWORD를 입력하세요");
			$("#j_userPw").focus();
			return;
		}
		if (cPassword == undefined || cPassword == '') {
			alert("CONFIRM PASSWORD를 입력하세요");
			$("#j_cUserPw").focus();
			return;
		}
		if (userName == undefined || userName == '') {
			alert("USER NAME을 입력하세요");
			$("#j_userName").focus();
			return;
		}
		if (nickname == undefined || nickname == '') {
			alert("NICKNAME을 입력하세요");
			$("#j_nickname").focus();
			return;
		}

		// 비밀번호와 비밀번호확인 값이 같은지 확인
		if (password != cPassword) {
			alert("비밀번호가 일치하지 않습니다.");
			$("#j_cUserPw").focus(); // 커서를 비밀번호 입력하는 곳으로 이동
			return;
		}
		// ajax 이용하여 ID중복 확인 후 중복 아닐 때 폼 전송
		$.ajax({ // ajax라는 함수 호출. {}안은 전부 매개변수
			url : '/new_web/chkId.do', // 호출할 URL
			type : "post", // GET / POST 방식
			data : {
				'userId' : userId
			}, // 파라미터 {'이름', 변수(var)}
			// 바로 값을 넣을 땐 {'이름', '값'}
			success : function(result, textStatus, jqXHR) { // 콜백 함수
				// result가 0이 아니면 중복이라는 뜻
				if (result == 0) { // 중복 아님
					var frm = document.joinForm;
					frm.action = '/new_web/doJoin.do';
					frm.method = 'post';
					frm.submit(); // doJoin.do controller로
				} else if (result == 2) {
					alert("아이디에 대문자는 사용할 수 없습니다.");
					$("#j_userId").focus(); // 커서를 ID 입력하는 곳으로 이동
				} else { // 중복 또는 문제가 있음
					alert("아이디가 중복됩니다."); // ID가 중복됩니다. 라는 경고창
					$("#j_userId").focus(); // 커서를 ID 입력하는 곳으로 이동
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
		<h1>회원 가입</h1>
		<form name="joinForm">
			<div class="form-item">
				<label for="userId"></label> <input type="text" name="userId"
					id="j_userId" required="required"
					placeholder="아이디  (필수 / 영문 대문자 사용불가)" />
			</div>
			<div class="form-item">
				<label for="username"></label> <input type="text"
					placeholder="이름  (필수)" name="userName" id="j_userName"
					required="required" />
			</div>
			<div class="form-item">
				<label for="email"></label> <input type="text" name="nickname"
					id="j_nickname" required="required" placeholder="별명  (필수)" />
			</div>
			<div class="form-item">
				<label for="password"></label> <input type="password" id="j_userPw"
					name="userPw" required="required" placeholder="비밀번호  (필수)"></input>
			</div>
			<div class="form-item">
				<label for="cpassword"></label> <input placeholder="비밀번호 재확인  (필수)"
					id="j_cUserPw" type="password" name="cPassword" id="j_cUserPw"
					required="required" />
			</div>
			<div class="form-item">
				<label for="email"></label> <input type="email" name="email"
					required="required" placeholder="이메일 (선택)"></input>
			</div>
			<div class="button-panel">
				<input class="button" onclick="doJoin()" title="Sign In"
					value="가입하기"></input>
			</div>
		</form>
		<div class="form-footer">
			<p>
				<a href='<c:url value="/goLogin.do"/>'>로그인</a>
			</p>
			<p>
				<a href='<c:url value="/index.do"/>'>홈 화면</a>
			</p>
		</div>
	</div>
</body>
</html>
