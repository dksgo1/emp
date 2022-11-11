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
<body class= "bg-success p-2 bg-opacity-10">
	<div class="container pt-5 w-25 h-25">
		<h1 class="text-info">INDEX</h1>
		<ol>
			<li><a href="<%=request.getContextPath()%>/dept/deptList.jsp" class="btn btn-warning border border-primary">부서관리</a></li>
			<li><a href="<%=request.getContextPath()%>/emp/empList.jsp" class="btn btn-warning border border-primary">사원관리</a></li>
			<li><a href="<%=request.getContextPath()%>/board/boardList.jsp" class="btn btn-warning border border-primary">게시판 관리</a></li>
		</ol>
	</div>	
</body>
</html>