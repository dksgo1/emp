<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index</title>
<!-- bootstrap -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>	
</head>
<body>
	<h1>INDEX</h1>
	<ol>
		<li><a href="<%=request.getContextPath()%>/dept/deptList.jsp" class="btn btn-warning">부서관리</a></li>
	</ol>
</body>
</html>