<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- tag library 선언 : c tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>편지 주소록</title>
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
</style>
<script type="text/javascript"
	src="<c:url value="/resources/jquery/js/jquery-3.2.1.js" />"></script>
<script type="text/javascript"
	src="<c:url value="/resources/jquery-ui/js/jquery-ui.js" />"></script>
<script type="text/javascript"
	src="<c:url value="/resources/jquery/js/jquery-migrate-1.4.1.js" />"></script>

<script type="text/javascript">
	$(document).ready(function() {
		//Tab
		$("#tabs").tabs();

		$('#btnSearch').click(function() { // $()'#id option:selected') / val() : 값을 가져옴
			var type = $('#searchType option:selected').val();
			var text = $('#searchText').val();
			var frm = $('#searchForm')[0]; // [0]없이 실행하면 배열
			frm.method = 'POST';
			frm.action = "${pageContext.request.contextPath}/friend/list.do?letter=letter";
			frm.submit();
		});
	});
	
	// 편지쓰기
	function goWrite(toId) {
		window.opener.location.href = "/new_web/letter/goWrite.do?toId=" + toId;
		self.close();
	}
</script>
</head>
<body>
	<div id="tabs" align="center">
		<br />친구 목록
		<!-- wrap -->
		<div id="wrap">

			<!-- container -->
			<div id="container">

				<!-- content -->
				<div id="content">

					<!-- board_search -->
					<div class="board_search">
						<form id="searchForm">
							<select id="searchType" name="searchType" title="선택메뉴">
								<option value="all"
									<c:if test="${searchType == 'all' }"> selected</c:if>>전체</option>
								<option value="userId"
									<c:if test="${searchType == 'friendId' }"> selected</c:if>>친구
									아이디</option>
								<option value="userId"
									<c:if test="${searchType == 'friendName' }"> selected</c:if>>친구
									이름</option>
								<option value="userId"
									<c:if test="${searchType == 'memo' }"> selected</c:if>>메모</option>
							</select> <input type="text" id="searchText" name="searchText"
								value="${searchText }" title="검색어 입력박스" class="input_100" /> <input
								type="button" id="btnSearch" value="검색" title="검색버튼"
								class="btn_search" />
						</form>
					</div>
					<!-- //board_search -->

					<!-- board_area -->
					<div class="board_area">
						<form method="get">
							<fieldset>
								<legend>친구 목록</legend>
								<!-- board list table -->
								<table summary="표 내용은 Ses & Food 게시물의 목록입니다."
									class="board_list_table">
									<caption>친구 목록</caption>
									<tbody>
										<c:forEach items="${result }" var="f">
											<tr>
												<td><a href="#" onclick="goWrite('${f.friend_id}')">
														<c:out value="${f.friend_name}" />(<c:out value="${f.friend_id}" />)  
												</a></td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
								<!-- //board list table -->

								<!--paginate start -->
								<c:if test="${result.size() != 0 }">
									<div class="paginate">

										<c:if test="${currentPageNo != 1}">
											<a href="/new_web/friend/list.do?letter=letter&currentPageNo=1">처음으로</a>
										</c:if>
										<c:if test="${pageBlockStart != 1}">
											<a
												href="/new_web/friend/list.do?letter=letter&currentPageNo=${pageBlockStart -1 }">이전페이지</a>
										</c:if>
										<c:forEach var="i" begin="${pageBlockStart}"
											end="${pageBlockEnd}" step="1">
											<a
												href="/new_web/friend/list.do?letter=letter&currentPageNo=<c:out value='${i}'/>&searchType=<c:out value='${searchType}'/>&searchText=<c:out value='${searchText}'/>">
												<c:choose>
													<c:when test="${i == currentPageNo }">
														<strong>${i }</strong>
													</c:when>
													<c:otherwise>${i }</c:otherwise>
												</c:choose>
											</a>
										</c:forEach>

										<c:if test="${pageBlockStart + pageBlockSize <= totalPage }">
											<a
												href="/new_web/friend/list.do?letter=letter&currentPageNo=${pageBlockEnd + 1 }">다음페이지</a>
										</c:if>
										<c:if test="${currentPageNo != totalPage}">
											<a href="/new_web/friend/list.do?letter=letter&currentPageNo=${totalPage }">끝으로</a>
										</c:if>
										
									</div>
								</c:if>
								<!--//paginate end -->

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
</body>
</html>