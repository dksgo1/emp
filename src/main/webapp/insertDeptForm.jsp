<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>부서추가</h2>
	<form action="<%=request.getContextPath()%>/insertDeptAction.jsp">
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
			<tr>
				<td colspan="2">
					<button type="submit">추가</button>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>