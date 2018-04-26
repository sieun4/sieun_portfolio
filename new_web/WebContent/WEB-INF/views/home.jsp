<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- tag library 선언 : c tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>HOME</title>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />

<!--[if lte IE 8]><script src="<c:url value='/resources/assets/js/ie/html5shiv.js'/>"></script><![endif]-->
<link rel="stylesheet"
	href="<c:url value="/resources/assets/css/main.css"/>" />
<!--[if lte IE 8]><link rel="stylesheet" href='<c:url value="/resources/assets/css/ie8.css"/>' /><![endif]-->
<!--[if lte IE 9]><link rel="stylesheet" href='<c:url value="/resources/assets/css/ie9.css"/>' /><![endif]-->
<link href="https://fonts.googleapis.com/css?family=Gamja+Flower"
	rel="stylesheet">

</head>
<body class="homepage">
	<div id="page-wrapper">
		<header class="major">
		<p>☆업데이트 예정☆ 편지함: 주소록, 답장, 삭제 / 자유게시판: 태그</p>
		<c:if test="${count != 0}">
			<h2>
				<font color="violet">${sessionScope.nickname }(${sessionScope.userId })</font>님에게
				<font color="red">${count }</font>건의 새편지가 도착했어요!
			</h2>
			<!-- 				<a class="button" -->
			<%-- 					href='<c:url value="/letter/list.do?toId=${sessionScope.userId}"/>'>편지 --%>
			<!-- 					확인하러 가기</a> -->
		</c:if> </header>

		<!-- Features 1 -->
		<div class="wrapper">
			<div class="container">
				<div class="row">
					<section class="6u 12u(narrower) feature">
					<div class="image-wrapper first">
						<a class="image featured first"><img
							src='<c:url value="/resources/images/photo_15.JPG"/>' alt="" /></a>
					</div>
					<header>
					<h2>받은 편지함</h2>
					</header>
					<p>이곳엔 가장 최근에 받은 편지 5개가 보여질 예정이에요.</p>
					<ul class="actions">
						<li><a
							href='<c:url value="/letter/list.do?toId=${sessionScope.userId}"/>'
							class="button" target="demoFrame">받은 편지함 바로가기</a></li>
					</ul>
					</section>
					<section class="6u 12u(narrower) feature">
					<div class="image-wrapper">
						<a class="image featured"><img
							src='<c:url value="/resources/images/photo_6.JPG"/>' alt="" /></a>
					</div>
					<header>
					<h2>자유게시판</h2>
					</header>
					<p>이곳엔 가장 최근에 올라온 게시글 5개가 보여질 예정이에요.</p>
					<ul class="actions">
						<li><a href='<c:url value="/free/list.do"/>' class="button"
							target="demoFrame">자유게시판 바로가기</a></li>
					</ul>
					</section>

				</div>
			</div>
		</div>

		<div>
			<!-- q = 원하는 주소 구글맵에서 찾아서 주소명넣으면 됨 -->
			<iframe
				src="https://www.google.com/maps/embed/v1/place?q=강남역&amp;key=AIzaSyBSFRN6WWGYwmFi498qXXsD2UwkbmD74v4"
				frameborder="0" scrolling="no" marginheight="0" marginwidth="0"
				style="width: 100%; height: 200px;"></iframe>
		</div>


	</div>
	<!-- Scripts -->

	<script src='<c:url value="/resources/assets/js/jquery.min.js"/>'></script>
	<script
		src='<c:url value="/resources/assets/js/jquery.dropotron.min.js"/>'></script>
	<script src='<c:url value="/resources/assets/js/skel.min.js"/>'></script>
	<script src='<c:url value="/resources/assets/js/util.js"/>'></script>
	<!--[if lte IE 8]><script src='<c:url value="/resources/assets/js/ie/respond.min.js"/>'></script><![endif]-->
	<script src='<c:url value="/resources/assets/js/main.js"/>'></script>
</body>
</html>