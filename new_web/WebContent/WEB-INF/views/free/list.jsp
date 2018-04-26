<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- tag library 선언 : c tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
			frm.action = "${pageContext.request.contextPath}/free/list.do";
			frm.submit();
		});
	});
</script>
</head>
<body>
	<div id="tabs">
		<ul>
			<li><a href="#tabs-1">자유게시판</a></li>
		</ul>
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
									<c:if test="${searchType == 'userId' }"> selected</c:if>>작성자
									ID</option>
								<option value="nickname"
									<c:if test="${searchType == 'nickname' }"> selected</c:if>>작성자
									닉네임</option>
								<option value="title"
									<c:if test="${searchType == 'title' }"> selected</c:if>>제목</option>
								<option value="contents"
									<c:if test="${searchType == 'contents' }"> selected</c:if>>내용</option>
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
								<legend>게시물 목록</legend>
								<!-- board list table -->
								<table summary="표 내용은 Ses & Food 게시물의 목록입니다."
									class="board_list_table">
									<caption>게시물 목록</caption>
									<colgroup>
										<col width="10%" />
										<!-- 글번호 -->
										<col width="40%" />
										<!-- 제목 -->
										<col width="20%" />
										<!-- 작성자 -->
										<col width="20%" />
										<!-- 작성일 -->
										<col width="10%" />
										<!-- 조회수 -->
									</colgroup>
									<thead>
										<tr>
											<th scope="col">글번호</th>
											<th scope="col">제목</th>
											<th scope="col">작성자</th>
											<th scope="col">작성일</th>
											<th scope="col">조회수</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${result }" var="f">
											<tr>
												<td><c:out value="${f.seq}" /></td>
												<td class="tleft"><span class="bold"> <a
														href="/new_web/free/read.do?currentPageNo=${currentPageNo}&seq=${f.seq }">
															<c:out value="${f.title}" /> <c:if
																test="${f.has_comment > 0 }">(<c:out
																	value="${f.has_comment }" />)</c:if>
													</a>
												</span></td>
												<td><c:out value="${f.nickname}" />(<c:out
														value="${f.user_id }" />)</td>
												<td><c:out value="${f.write_date}" /></td>
												<td><c:out value="${f.hits}" /></td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
								<!-- //board list table -->
								<c:if test="${result.size() != 0 }">

									<!--paginate start -->
									<div class="paginate">

										<c:if test="${currentPageNo != 1}">
											<a href="/new_web/free/list.do?currentPageNo=1">처음으로</a>
										</c:if>

										<c:if test="${pageBlockStart != 1}">
											<a
												href="/new_web/free/list.do?currentPageNo=${pageBlockStart -1 }">이전페이지</a>
										</c:if>

										<c:forEach var="i" begin="${pageBlockStart}"
											end="${pageBlockEnd}" step="1">
											<a
												href="/new_web/free/list.do?currentPageNo=<c:out value='${i}'/>&searchType=<c:out value='${searchType}'/>&searchText=<c:out value='${searchText}'/>">
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
												href="/new_web/free/list.do?currentPageNo=${pageBlockEnd + 1 }">다음페이지</a>
										</c:if>

										<c:if test="${currentPageNo != totalPage}">
											<a href="/new_web/free/list.do?currentPageNo=${totalPage }">끝으로</a>
										</c:if>

									</div>
									<!--//paginate end -->
								</c:if>

								<!-- bottom button -->
								<div class="btn_bottom">
									<div class="btn_bottom_right">
										<%-- 									<c:if test='${sessionScope.userId != null}'> --%>
										<a
											href="/new_web/free/goWrite.do?currentPageNo=${currentPageNo }">
											<input type="button" value="글쓰기" title="글쓰기" />
										</a>
										<%-- 									</c:if> --%>
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