<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- tag library 선언 : c tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- tag library 선언 : fmt tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>게시물 목록페이지</title>
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

	// 답장
	function goReply() {
		var frm = document.readForm;
		frm.action = "/new_web/letter/goWrite.do?toId=${letter.fromId }";
		frm.method = "POST";
		frm.submit();
	}

	$(document).ready(function() {
		//Tab
		$("#tabs").tabs();
	});
</script>
</head>
<body>
	<div id="tabs" align="center">
		<br />편지함
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
								<input type="hidden" name="seq" value="${letter.seq }" /> <input
									type="hidden" name="currentPageNo" value="${currentPageNo }" />
								<fieldset>
									<legend>편지 읽기</legend>

									<!-- board detail table -->
									<table summary="표 내용은 Ses & Food 게시물의 상세 내용입니다."
										class="board_detail_table">
										<caption>편지 읽기</caption>
										<colgroup>
											<col width="20%" />
											<col width="80%" />
										</colgroup>
										<tbody>
											<tr>
												<th class="tleft">제목</th>
												<td class="tleft"><c:out value="${letter.title }" /></td>
											</tr>
											<tr>
												<th class="tleft">받는 사람</th>
												<td class="tleft"><c:out value="${letter.toId }" /></td>
											</tr>
											<tr>
												<th class="tleft">보낸 사람</th>
												<td class="tleft"><a
													href="/new_web/letter/goWrite.do?toId=${letter.fromId }"><c:out
															value="${letter.fromNickname }" />(<c:out
															value="${letter.fromId }" />)</a></td>
											</tr>
											<tr>
												<td colspan="2" class="tleft">${letter.text }
													<div class="body"></div>
												</td>
											</tr>
											<tr>
												<td colspan="2" class="tright"><c:out
														value="${letter.date }" /></td>
											</tr>
										</tbody>
									</table>
									<br />
									<c:if test="${msg != null }">
										${msg }
									</c:if>
									<br /> <br />

									<!-- bottom button -->
									<div class="btn_bottom">
										<div class="btn_bottom_left">
											<input type="button" onclick="window.history.back()"
												value="돌아가기" title="돌아가기" />
										</div>
										<div class="btn_bottom_right">
											<input type="button" onclick="goReply()" value="답장"
												title="답장" />
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
		</div>
	</div>

</body>
</html>