<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- tag library 선언 : c tag --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>회원 목록</title>
	  
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<style type="text/css">
body { margin-right:0px;}
/* container layout */
#container {
	margin: 0 auto;
	padding: 20px 0;
}
#content {
	display: table-cell;
	width: 750px;
	padding: 0 0 0 0px;
}
/* //container layout */
.search {
	margin-bottom: 5px;
	text-align: right;
}
.search .btn_search {
	height: 20px;
	line-height: 20px;
	padding: 0 10px;
	vertical-align: middle;
	border: 1px solid #e9e9e9;
	background-color: #f7f7f7;
	font-size: 12px;
	text-align: center;
	cursor: pointer;
}
.ui-widget .ui-widget {
	font-size: 0.7em !important;
}
</style>
<script type="text/javascript" src="<c:url value="/resources/jquery/js/jquery-3.2.1.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/jquery-ui/js/jquery-ui.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/jquery/js/jquery-migrate-1.4.1.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/jqgrid/js/i18n/grid.locale-kr.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/jqgrid/js/jquery.jqGrid.min.js"/>"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/jquery-ui/css/jquery-ui.css" />" />
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/jqgrid/css/ui.jqgrid.css'/>"/>
<link href="https://fonts.googleapis.com/css?family=Gamja+Flower"
	rel="stylesheet"></link>
<script type="text/javascript">

$(document).ready(function(){
	// Tab
	$("#tabs").tabs();
	
	var tabHeight = $('#tabs').height();
	var initGridWidth = 0;	// 최초 가로 길이
	var initGridHeight = 0;	// 최초 세로 길이
	
	var userGrid = jQuery("#userGrid").jqGrid({	// # table태그의 ID / jqGrid(매개변수)
		url : '<c:url value="/user/getUserData.do"/>',	// 데이터를 가져오기 위한 URL
		mtype: "POST",
	    data : { },		// 파라미터 {key:value} / { }는 Object 표시
	    datatype: "json",
	    page : $('#currentPageNo').val(),	// 보여줄 페이지 번호
	    jsonReader : {	// resultMap.put으로 보내준 값
          	root: "rows",		// 실제 데이터 	15건
          	page: "page",		// 현재 페이지
          	total: "total",		// 총 페이지 수 
          	records: "records",	// 총 데이터 건수
          	repeatitems: false,
          	cell: "cell",
          	id: "seq"			// pk 컬럼 / 변수 
      	},
    	// 화면에 보이는 칸의 이름
	    colNames: ["seq", "userId", "userName", "nickname", "isAdmin", "email", "createDate"],	
	    colModel: [	// name: "변수명" (값가져오기), index: 'DB컬럼명' (정렬)
	    			// editable : grid에서는 보이지만 수정 화면에서는 안 보임 / hidden : 둘 다 안 보임
	    			// edittype : input type
	    			// editable:true, editoptions:{readonly:true} : 수정화면에 나타나지만 수정은 할 수 없음 
	    			// editrules:{required:true} : 필수항목
	               { name: "seq", index:'seq', width: 30, align:'center', editable:true, hidden:false, editoptions:{readonly:true}},
	               { name: "userId", index:'user_id', width: 100, align:'center', editable:true, editoptions:{readonly:true}},
	               { name: "userName", index:'user_name', width: 150, align:'center', editable:true, editoptions:{readonly:true}},
	               { name: "nickname", index:'nickname', width: 80, align:'center', editable:true, editoptions:{readonly:true}, hidden:false},
	               { name: "isAdmin", index:'is_admin', width: 70, align:'center', editable:true, edittype : 'select', editoptions:{value:'-:선택;1:예;0:아니오'}},
	               { name: "email", index:'email', width: 70, align:'center', editrules:{required:true}, editable:true, editoptions:{size:"20", maxlength:"50"}, editoptions:{readonly:false}},
	               { name: "createDate", index:'create_date', width: 70, align:'center', editable:true, editoptions:{readonly:true}}
		],
	    autowidth: true,
	    width:1000,
	    height: 390,
	    rowNum: 15,
	    rownumbers: false,
	    sortname: "seq",	// 최초 정렬 "컬럼명"
	    sortorder: "desc",	// 최초 정렬 "내림차순/오름차순"
	    scrollrows : true,
	    viewrecords: true,
	    gridview: true,
	    autoencode: true,
	    altRows: true,
	    pager: '#userGrid-pager',	// paging 하는 영역 '#div의 id'
        caption: "회원 목록", // set caption to any string you wish and it will appear on top of the grid
		loadComplete: function(){
			if(initGridWidth == 0) initGridWidth = $('#gbox_userGrid').parent().width();
			// 그리드 가로 길이 맞춤
			$('#gbox_userGrid').jqGrid('setGridWidth', initGridWidth);
			
			var t = $('#demoframe', window.parent.document);
		},
        onCellSelect: function (rowId, cellIdx, value, event){
			console.log(rowId);		// seq
			console.log(cellIdx);	// 선택한 cell의 index (왼쪽에서부터 0)
			console.log(value);		// 선택한 cell의 값
			console.log(event);
		},
		onSelectRow: function (rowId, tf, event){
			$.ajax({
				url: '/web_portfolio/user/checkPk.do',
				type: 'post',
				data: {'seq' : rowId},
	
				success: function(result, textStatus, jqXHR){		// 통신 성공
					// result는 controller에서 보내주는 값
// 					alert(result);
				},
				error: function(jqXHR, textStatus, errorThrown){	// 통신 실패
					console.log(jqXHR);
					console.log(textStatus);
					console.log(errorThrown);
				}
			})	
		}
	});
	
	//navButtons
	jQuery(userGrid).jqGrid('navGrid', "#userGrid-pager",
		{ 	//navbar options
			edit: true,
			add: false,
			del: true,
			search: false,
			refresh: false,
			view: true
		},	// 하나의 Object
		{
			width:'auto',
			editCaption:'회원 정보 수정',
			url : '<c:url value="/user/editUser.do"/>',
			closeOnEscape: true,
			closeAfterEdit: true,
			reloadAfterSubmit: true,
			recreateForm: true,
			viewPagerButtons: false,
			beforeShowForm: function(form){ 
				var rowId = $("#userGrid").jqGrid('getGridParam', 'selrow');
				// rowId로 row 값 가져오기 : return type = Object
				var rowData = $("#userGrid").jqGrid('getRowData', rowId);
				
				console.log(rowData);
				
// 				console.log( $(form[0] ).html() );
				$('tr#tr_nickname', form[0]).show();	// 'hidden한 데이터' 찾아서.보여주기
				
				$('select#isAdmin option[value='+rowData.isAdmin+']', form[0]).attr({'selected':true});
			},
			beforeSubmit: function(post, formId){
				console.log('beforeSubmit : ' + post);
				if(post.userName == '')
					return [false, "사용자명을 입력하세요."];
				if(post.isAdmin == '')
					return [false, "운영자 여부를 선택하세요."];
				if(post.email == '')
					return [false, "이메일을 입력하세요."];
				if(post.email.length < 8)
					return [false, "이메일은 8자 이상입니다."];
				var regExp = /^[0-9a-zA-z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{3,4}$/i;
				if(post.email.match(regExp) == null)
					return [false, "이메일 형식이 올바르지 않습니다."];
				return [true, "", ""];
			},
			afterComplete: function(response, postdata){
				console.log('editOption - afterComplete');
				console.log(response);
				// 기본형 받을 때 (Strisng, int 등)
				var data = response.responseText;
				// return 1 : data = 1;
				// return "ERROR" : data = "ERROR";
				
				// 객체 받을 때 (map, arrayList 등)
				var dat = response.responseJSON;
				// return Map : data = {key:value} -> data.key;
				
				switch(data){
				case "success": alert("수정되었습니다."); break;
				case "anomaly": alert("수정 중 오류(삭제이상)가 발생했습니다."); break;
				case "exception": alert("수정 중 오류(예외)가 발생했습니다."); break;
				}
				console.log('------------------------------');
			},
			afterSubmit: function(response, postdata){
				return [true, '', ''];
			}
		},	// edit
		{},	// add
		{	// del
			caption: '회원정보 삭제',				// title
			msg: "선택한 회원을 삭제 하시겠습니까?",	
			recreateForm: true,
			url: '<c:url value="/user/delUser.do"/>',
			beforeShowForm : function(e){
				var form = $(e[0]);
				return;
			},
		
			afterComplete : function(response, postdata){	// response : result와 같음
				console.log('delOption - afterComplete');
				console.log(response.responseText);
				
				// 기본형 받을 때 (Strisng, int 등)
				var data = response.responseText;
				// return 1 : data = 1;
				// return "ERROR" : data = "ERROR";
				
				// 객체 받을 때 (map, arrayList 등)
				var dat = response.responseJSON;
				// return Map : data = {key:value} -> data.key;
				
				switch(data){
				case "success": alert("삭제되었습니다."); break;
				case "anomaly": alert("삭제 중 오류(삭제이상)가 발생했습니다."); break;
				case "exception": alert("삭제 중 오류(예외)가 발생했습니다."); break;
				}
				console.log('------------------------------');			
			},
			onClick : function(e){
			}
		}
	);
// 	$('#btnSearch').click(function(){매개변수}); 기본구조
	$('#btnSearch').click(function(){	// $()'#id option:selected') / val() : 값을 가져옴
		var searchType = $('#searchType option:selected').val();			
		var searchText = $('#searchText').val();
		
		$("#userGrid").jqGrid('setGridParam', {
			postData: {
				'searchType' : searchType,	// :을 기준으로 왼쪽이 text(문자열)
				'searchText' : searchText
			},	// Object
			page : 1 }	// 두번째 매개변수 / 이건 안 적어도 상관 없음
		).trigger("reloadGrid");	// trigger : event(reloadGrid)를 발생시키는 function
	});
});
</script>
</head>
<body>
<div id="tabs" align="center">
	<br/> 회원 목록
	<div id="tabs-1">
		<!-- wrap -->
	<div id="wrap">

		<!-- container -->
		<div id="container">

			<!-- content -->
			<div id="content">

				<!-- board_area -->
				<div class="board_area">
					
					<!-- board_search -->
					<div class="search">
						<select id="searchType" name="searchType" title="선택메뉴">
							<option value="all" <c:if test="${searchType == 'all' }"> selected</c:if>>전체</option>
							<option value="userId" <c:if test="${searchType == 'userId' }"> selected</c:if>>userId</option>
							<option value="userName" <c:if test="${searchType == 'userName' }"> selected</c:if>>userName</option>
							<option value="nickname" <c:if test="${searchType == 'nickname' }"> selected</c:if>>nickname</option>							
						</select> 
						<input type="text" id="searchText" title="검색어 입력박스" class="input_100" /> 
						<input type="button" id="btnSearch" value="검색" title="검색버튼" class="btn_search" />
					</div>
					<!-- //board_search -->
	
					<table id="userGrid"></table>		<!-- tr / td -->
					<div id="userGrid-pager"></div>		<!-- paging -->
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