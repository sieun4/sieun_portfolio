<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- tag library 선언 : c tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>회원 정보 수정 페이지</title>
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
	function doUpdate() { // 유효성 검사

		var userPw = document.getElementById("userPw").value;
		if (userPw == undefined || userPw == '') {
			alert("비밀번호를 입력하세요");
			$("#userPw").focus();
			return;
		}
		var nickname = document.getElementById("nickname").value;
		if (nickname == undefined || nickname == '') {
			alert("별명을 입력하세요");
			$("#nickname").focus();
			return;
		}
		var frm = document.readForm;
		frm.action = "/new_web/user/doEdit.do";
		frm.method = "post";
		frm.submit();
	}
	
	function init() {
		var msg = '${msg}';
		if (msg != '') {
			alert(msg);
		}
	}
</script>
</head>
<body onload="init()">

	<!-- wrap -->
	<div id="wrap" align="center">

		<!-- container -->
		<div id="container">

			<!-- content -->
			<div id="content">

				<!-- title board detail -->
				<div class="title_board_detail">회원 정보 수정</div>
				<!-- //title board detail -->

				<!-- board_area -->
				<div class="board_area">
					<form name="readForm" method="post">
						<fieldset>
							<legend>회원 정보 수정</legend>

							<!-- board detail table -->
							<table summary="회원 정보 수정" class="board_detail_table">
								<caption>회원 정보 수정</caption>
								<colgroup>
									<col width="35%" />
									<col width="%" />
									<col width="%" />
									<col width="%" />
								</colgroup>
								<tbody>
									<tr>
										<th class="tright">ID</th>
										<td class="tleft" colspan="3"><input type="text"
											readonly="readonly" name="userId" value="${user.userId }"
											class="input_200" value="" /></td>
									</tr>
									<tr>
										<th class="tright">비밀번호</th>
										<td colspan="3" class="tleft"><input type="password"
											id="userPw" name="userPw" title="비밀번호 입력박스" class="input_200" />
										</td>
									</tr>
									<tr>
										<th class="tright">이름</th>
										<td class="tleft" colspan="3"><input type="text"
											readonly="readonly" value="${user.userName }"
											class="input_200" value="" /></td>
									</tr>
									<tr>
										<th class="tright">별명</th>
										<td class="tleft" colspan="3"><input type="text"
											id="nickname" name="nickname" value="${user.nickname }"
											class="input_200" value="" /></td>
									</tr>
									<tr>
										<th class="tright">이메일</th>
										<td class="tleft" colspan="3"><input type="text"
											name="email" class="input_200" value="" /></td>
									</tr>
								</tbody>
							</table>
							<!-- //board detail table -->

							<!-- bottom button -->
							<div class="btn_bottom">
								<div class="btn_bottom_left">
									<input type="button" value="취소" onclick="window.history.back()"
										title="취소" />
								</div>
								<div class="btn_bottom_right">
									<input type="button" value="수정완료" onclick="doUpdate()"
										title="수정완료" />
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