<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>insertDeptForm</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
	<!-- 메뉴 partial jsp 구성 -->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<div class="container pt-5 w-25 h-25">
			<h2 class="text-center">부서추가</h2>
			<%
				if(request.getParameter("msg") != null) {
			%>
					<div><%=request.getParameter("msg") %></div>
			<%
				}
			%>
			<form method="post" action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp">
				<table>
					<tr>
						<td>부서번호</td>
						<td>
							<input type="text" name="deptNo">
						</td>
					</tr>
					<tr>
						<td>부서이름</td>
						<td>
							<input type="text" name="deptName">
						</td>
					</tr>
					<tr class="text-center">
						<td colspan="2">
							<button type="submit" class="bg-secondary p-3">추가</button>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</body>
</html>