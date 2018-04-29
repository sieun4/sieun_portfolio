<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>환영합니다 :D</title>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />

<!--[if lte IE 8]><script src="<c:url value='/resources/assets/js/ie/html5shiv.js'/>"></script><![endif]-->
<link rel="stylesheet"
	href="<c:url value="/resources/assets/css/main.css"/>" />
<!--[if lte IE 8]><link rel="stylesheet" href='<c:url value="/resources/assets/css/ie8.css"/>' /><![endif]-->
<!--[if lte IE 9]><link rel="stylesheet" href='<c:url value="/resources/assets/css/ie9.css"/>' /><![endif]-->
<link href="https://fonts.googleapis.com/css?family=Gamja+Flower"
	rel="stylesheet">
<!-- Scripts -->
<!-- 변경!!!!!!! -->
<script src='<c:url value="/resources/assets/js/jquery.min.js"/>'></script>
<script
	src='<c:url value="/resources/assets/js/jquery.dropotron.min.js"/>'></script>
<script src='<c:url value="/resources/assets/js/skel.min.js"/>'></script>
<script src='<c:url value="/resources/assets/js/util.js"/>'></script>
<!--[if lte IE 8]><script src='<c:url value="assets/js/ie/respond.min.js"/>'></script><![endif]-->
<script src='<c:url value="/resources/assets/js/main.js"/>'></script>

<script type="text/javascript">
var ctx = "<%=request.getContextPath()%>";
	jQuery(document).ready(function() {
		//             $("#accordion").collapse();

		// 초기 페이지 세팅
		$("#demoFrame").attr("src", '<c:url value="/home.do" />');
		//$("span",".gheader").html('Intro Page');

		$(".list-group-item").on("click", function() {
			//$("span",".gheader").html( $(this).text() );
		});
	});

	function resize(obj) { // 글 길게 썼을 때 스크롤 안 생기게 
		obj.style.height = obj.contentWindow.document.body.scrollHeight + 50
				+ 'px';
	}

	function doLogout() {
		// form은 사용자가 입력한 값이 있어서 값을 같이 넘겨줘야 할 때 씀
		// 값이 없으면 form을 쓸 필요 없음. 코드 길어짐.
		// url만 호출
		if (confirm("로그아웃 하시겠습니까?")) {
			window.location.href = '/new_web/logout.do';
		}
	}
</script>
<script src='<c:url value="/resources/assets/js/common.js"/>'></script>
</head>
<body class="homepage">
	<div id="page-wrapper">

		<!-- Header -->
		<div id="header-wrapper">
			<div id="header" class="container">

				<!-- Logo -->
				<h1 id="logo">
					<a href='<c:url value="/index.do"/>'>홈</a>
				</h1>

				<!-- Nav -->
				<nav id="nav">
				<ul>
					<li><a href="#">편지함</a>
						<ul>
							<li><a
								href='<c:url value="/letter/list.do?toId=${sessionScope.userId}"/>'
								target="demoFrame">받은 편지함</a></li>
							<li><a
								href='<c:url value="/letter/list.do?fromId=${sessionScope.userId}"/>'
								target="demoFrame">보낸 편지함</a></li>
							<li><a href='<c:url value="/letter/goWrite.do"/>'
								target="demoFrame">편지 쓰기</a></li>
						</ul></li>
					<li><a href='<c:url value="/free/list.do"/>'
						target="demoFrame">자유 게시판</a></li>
					<li class="break"><a href="#">마이 페이지</a>
						<ul>
							<li><a href='<c:url value="/user/getInfo.do"/>'
								target="demoFrame">개인 정보 관리</a></li>
							<li><a href='<c:url value="/friend/list.do"/>'
								target="demoFrame">주소록 관리</a></li>
							<c:if test="${sessionScope.isAdmin == 1 }">
								<li><a href='<c:url value="/user/list.do"/>'
									target="demoFrame">회원 관리</a></li>
							</c:if>
						</ul></li>

					<c:choose>
						<c:when test="${sessionScope.userId != null}">
							<li><a href="" onclick="doLogout()">로그 아웃</a></li>
						</c:when>
						<c:otherwise>
							<li><a href='<c:url value="/goLogin.do"/>'>로그인/회원가입</a></li>
						</c:otherwise>
					</c:choose>
				</ul>
				</nav>
			</div>

			<!-- Hero -->
			<section id="hero" class="container"> <header>
			<h2>
				<c:choose>
					<c:when test="${sessionScope.userId == null }">로그인 후 다양한 기능들을 이용해보세요! :D</c:when>
					<c:otherwise>
						<c:out value="${sessionScope.nickname }" />(<c:out
							value="${sessionScope.userId }" />)님 반갑습니다! :D
					</c:otherwise>
				</c:choose>
			</h2>
			</header> </section>
		</div>

		<div align="center">
			<br />
			<iframe id="demoFrame" name="demoFrame" frameborder="0"
				marginheight="0" marginwidth="0" style="width: 70%; height: 100%;"
				onload="resize(this)"></iframe>
			<br />
		</div>

		<!-- Footer -->
		<div id="footer-wrapper">
			<div id="footer" class="container">
				<header class="major">
				<h2>관리자에게 :)</h2>
				<p>
					오류를 발견하셨다면 제보해 주세요!<br /> ps. 디자인(폰트, 컬러 등)에 대한 지적은 잠시 넣어두어요....
				</p>
				</header>
				<div class="row">
					<section class="6u 12u(narrower)">
					<form action="/new_web/letter/toDeveloper.do" method="post">
						<div class="row 50%">
							<div class="12u">
								<input name="title" placeholder="Title" type="text" />
							</div>
						</div>
						<div class="row 50%">
							<div class="12u">
								<textarea name="text" placeholder="Message"></textarea>
							</div>
						</div>
						<div class="row 50%">
							<div class="12u">
								<ul class="actions">
									<li><input type="submit" value="Send Message" /></li>
									<li><input type="reset" value="Clear form" /></li>
								</ul>
							</div>
						</div>
					</form>
					</section>

					<section class="6u 12u(narrower)">
					<div class="row 50%">
						<div align="center" class="12u">
							이 페이지는 아래 항목을 이용하여 구현하였습니다.<br /> Spring Framework
							4.3.14.RELEASE<br /> myBatis 3.4.1<br /> jUnit 4.12<br /> <br />
							last update 2018. 04. 27 <br /> <br />
							<section id="hero" class="6u 12u(narrower)"> <a
								class="button">SIEUN</a>
						</div>
					</section>
					</section>
				</div>
			</div>
		</div>
		<div id="copyright" class="container">
			<ul class="menu">
				<li>&copy; Untitled. All rights reserved.</li>
				<li>Design: <a href="http://html5up.net">HTML5 UP</a></li>
			</ul>
		</div>
	</div>

	</div>
</body>
</html>