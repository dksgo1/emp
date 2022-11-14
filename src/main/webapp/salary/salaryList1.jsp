<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2
	
	final int ROW_PER_PAGE = 10; // 상수, 대문자로 쓰기
	int beginRow = (currentPage-1) * ROW_PER_PAGE; // ... Limit beginRow, ROW_PER_PAGE
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	/*
	   SELECT s.emp_no empNo
	      , s.salary salary
	      , s.from_date fromDate
	      , s.to_date toDate
	      , e.first_name firstName 
	      , e.last_name lastName
	   from salaries s INNER JOIN employees e ON s.emp_no = e.emp_no LIMIT ?, ?
	   */
	String sql = " SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no LIMIT ?, ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, ROW_PER_PAGE);
	ResultSet rs = stmt.executeQuery();
	ArrayList<Salary> salaryList = new ArrayList<>();
	while(rs.next()) {
		Salary s = new Salary();
		s.emp = new Employee(); // 
		s.emp.empNo = rs.getInt("empNo");
		s.salary = rs.getInt("salary");
		s.fromDate = rs.getString("fromDate");
		s.toDate = rs.getString("toDate");
		s.emp.firstName = rs.getString("firstName");
		s.emp.lastName = rs.getString("lastName");
		salaryList.add(s);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<table class="table">
		<%
			for(Salary s : salaryList) {
		%>
				<tr>
					<td><%=s.emp.empNo%></td>
					<td><%=s.salary%></td>
					<td><%=s.fromDate%></td>
					<td><%=s.toDate%></td>
					<td><%=s.emp.firstName%></td>
					<td><%=s.emp.lastName%></td>
				</tr>	
		<%
			}		
		%>
	</table>
</body>
</html>