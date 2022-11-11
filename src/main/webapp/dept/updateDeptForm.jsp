<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청 분석
	String deptNo = request.getParameter("dept_no");
	if(deptNo == null) { // updateDeptForm.jsp를 주소창에 직접 호출하면 deptNo는 null 값이된다.
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
		return;
	}

	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	String sql = "SELECT dept_name deptName FROM departments WHERE dept_no = ?"; // as 사용
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	ResultSet rs = stmt.executeQuery(); // 0행 or 1행
	Department dept = null;
	if(rs.next()) {
		dept = new Department();
	    dept.deptNo = deptNo;
		dept.deptName = rs.getString("deptName");
	}
	
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>updateDeptForm</title>
		<!-- bootstrap -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>	
	</head>
	<body class="bg-secondary p-3 bg-opacity-25">
		<!-- 메뉴 partial jsp 구성 -->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<div class="container pt-5 text-center">
			<h2>정보수정</h2>
			<form action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp" method = "post">
				<table class="table table-striped">
					<tr>
						<td>부서번호</td>
						<td><input type="text" name="deptNo" value="<%=dept.deptNo%>" readonly="readonly"></td>
					</tr>
					<tr>
						<td>부서이름</td>
						<td><input type="text" name="deptName" value="<%=dept.deptName%>"></td>
					</tr>
				</table>
				<button type="submit">수정</button>
			</form>
		</div>
	</body>
</html>