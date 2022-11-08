<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청 분석
	String deptNo = request.getParameter("dept_no");

	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	String sq1 = "select dept_name deptName from departments where dept_no = ?"; // as 사용
	PreparedStatement stmt = conn.prepareStatement(sq1);
	stmt.setString(1, deptNo);
	ResultSet rs = stmt.executeQuery(); // 0행 or 1행
	String deptName = null;
	
	if(rs.next()) {
		deptName = rs.getString("deptName");
	}
	
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<!-- bootstrap -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>	
	</head>
	<body>
		<div class="container pt-5 text-center">
			<h2>정보수정</h2>
			<form action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp" method = "post">
			<table class="table table-striped">
				<tr>
					<td>부서번호</td>
					<td><input type="text" name="deptNo" value="<%=deptNo%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td>부서이름</td>
					<td><input type="text" name="deptName" value="<%=deptName%>"></td>
				</tr>
			</table>
			<button type="submit">수정</button>
			</form>
		</div>
	</body>
</html>