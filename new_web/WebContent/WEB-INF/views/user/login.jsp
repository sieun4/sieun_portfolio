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
<link href="https://fonts.googleapis.com/css?family=Gamja+Flower" rel="stylesheet">
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
</script>
</head>
<body>
	<div class="form-wrapper">
		<h1>로그인</h1>
		<form action="/new_web/doLogin.do" method="post">
			<div class="form-item">
				<label for="userId"></label> <input type="text" name="userId"
					id="j_userId" required="required" placeholder="아이디" />
			</div>
			<div class="form-item">
				<label for="password"></label> <input type="password"
					id="j_userPw" name="password" required="required" placeholder="비밀번호"></input>
			</div>
			<div class="button-panel">
				<input type="submit" class="button" title="Sign In" value="로그인"></input>
			</div>
		</form>
		<div class="form-footer">
			<p>
				<a href='<c:url value="/goJoin.do"/>' >회원 가입</a>
			</p>
			<p>
				<a href='<c:url value="/index.do"/>' >홈 화면</a>
			</p>
			<!--     <p><a href="#">Forgot password?</a></p> -->
		</div>
	</div>
	<br />
</body>
</html>
