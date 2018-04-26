<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- tag library 선언 : c tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>회원 정보 페이지</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<link rel="stylesheet" type="text/css"
	href="<c:url value="/resources/css/common.css" />" />
<link href="https://fonts.googleapis.com/css?family=Gamja+Flower"
	rel="stylesheet"></link>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script type="text/javascript">
	function init() {
		var msg = '${msg}';
		if (msg != '') {
			alert(msg);
		}
	}
	function doQuitService() {
		var password = document.getElementById("password").value;
		if (password == undefined || password == '') {
			alert("비밀번호를 입력하세요");
			$("#password").focus();
			return;
		}
		if (confirm("탈퇴하시겠습니까?")) {
			var frm = document.readForm;
			frm.action = "/new_web/user/delete.do";
			frm.method = "post";
			frm.submit();
		}
	}
	function goEditUser() {
		var password = document.getElementById("password").value;
		if (password == undefined || password == '') {
			alert("비밀번호를 입력하세요");
			$("#password").focus();
			return;
		}
		var frm = document.readForm;
		frm.action = "/new_web/user/goEdit.do";
		frm.method = "post";
		frm.submit();
	}
</script>
</head>
<body onload="init()">
	<!-- wrap -->
	<div id="wrap">

		<!-- container -->
		<div id="container">

			<!-- content -->
			<div id="content">

				<br /> <br />

				<!-- title board detail -->
				<div class="title_board_detail"></div>
				<!-- //title board detail -->

				<!-- board_area -->
				<div class="board_area">
					<form name="readForm" method="post">
						<fieldset>
							<legend>회원 상세 내용</legend>

							<!-- board detail table -->
							<table summary="회원 정보 입니다." class="board_detail_table">
								<caption>회원 상세 내용</caption>
								<colgroup>
									<col width="%" />
									<col width="%" />
									<col width="%" />
									<col width="%" />
								</colgroup>
								<tbody>
									<tr>
										<th class="tright">아이디</th>
										<td class="tleft" colspan="3"><c:out
												value="${user.userId }" /></td>
									</tr>
									<tr>
										<th class="tright">이름</th>
										<td class="tleft" colspan="3"><c:out
												value="${user.userName }" /></td>
									</tr>
									<tr>
										<th class="tright">별명</th>
										<td class="tleft" colspan="3"><c:out
												value="${user.nickname }" /></td>
									</tr>
									<tr>
										<th class="tright">이메일</th>
										<td class="tleft" colspan="3"><c:out
												value="${user.email }" /></td>
									</tr>
									<tr>
										<th class="tright">회원 등급</th>
										<td class="tleft" colspan="3"><c:choose>
												<c:when test="${user.isAdmin == 1 }">관리자</c:when>
												<c:otherwise>일반 회원</c:otherwise>
											</c:choose></td>
									</tr>
									<tr>
										<th class="tright">비밀번호</th>
										<td colspan="3" class="tleft"><input type="password"
											name="password" id="password" title="비밀번호 입력박스"
											class="input_100" /></td>
									</tr>
								</tbody>
							</table>
							<!-- //board detail table -->

							<!-- bottom button -->
							<div class="btn_bottom">
								<div class="btn_bottom_right">
									<input type="button" onclick="doQuitService()" value="탈퇴하기"
										title="탈퇴하기" />
								</div>
								<div class="btn_bottom_right">
									<input type="button" onclick="goEditUser()" value="수정하기"
										title="수정" />
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

</body>
</html>