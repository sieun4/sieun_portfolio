<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>알림</title>
<script type="text/javascript">
function init(){
	var msg = '${msg}';
	if(msg != ''){
		alert(msg);
	}
	var contextPath = '${pageContext.request.contextPath}';
	var nextLocation = '${nextLocation}';
	console.log('contextPath : ' + contextPath);
	console.log('nextLocation : ' + nextLocation);
	console.log('next URL : ' + (contextPath + nextLocation));
	if(nextLocation != null && nextLocation != ''){
		window.top.location.href = contextPath + nextLocation;
	}
}
</script>
</head>
<body onload="init()">

</body>
</html>