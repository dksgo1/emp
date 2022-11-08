<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석(Controller)
	
	
	// 2. 업무처리(Model) -> 모델데이터(단일값 or 자료구조형태(배열, 리스트, ...))
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql = "SELECT dept_no deptNo, dept_name deptName FROM departments ORDER BY dept_no ASC"; // as 사용
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery(); 
	// <- 모델데이터로서 ResultSet은 일반적인 타입이 아니고 독립적인 타입도 아니다
	// ResultSet rs라는 모델자료구조를 좀더 일반적이고 독립적인 자료구조(List) 변경을 하자
	ArrayList<Department> list = new ArrayList<Department>();
	while(rs.next()) { // ResultSet의 API(사용방법)를 모른다면 사용할 수 없는 반복문
		Department d = new Department();
		d.deptNo = rs.getString("deptNo");
		d.deptName = rs.getString("deptName");
		list.add(d);
	}
	
	// 3. 출력(View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트)
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<!-- bootstrap -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		<style>
			table {
				margin-:auto;
			}
		</style>
	</head>
	<body>
		<div class="container">
			<h2>DEPT LIST</h2>
				<a href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp" class="btn btn-primary">부서추가</a>
	
			<table class="table row text-center table-striped">
				<tr class="table-danger">
					<th>부서번호</th>
					<th>부서이름</th>
					<th>수정</th>
					<th>삭제</th>
				</tr>
				<%
					for(Department d : list) { // 자바문법에서 제공하는 foreach문
				%>
						<tr>
							<td><%=d.deptNo%></td>
							<td><%=d.deptName%></td>
							<td>
								<a href="<%=request.getContextPath()%>/dept/updateDeptForm.jsp?dept_no=<%=d.deptNo%>">수정</a>
							</td>
							<td>
								<a href="<%=request.getContextPath()%>/dept/deleteDept.jsp?dept_no=<%=d.deptNo%>">삭제</a>
							</td>
						</tr>
				<%	
					}
				%>
			</table>
		</div>
	</body>
</html>