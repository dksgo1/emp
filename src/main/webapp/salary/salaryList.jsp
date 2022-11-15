<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*"%> 
<%
	// 1) 요청분석
	//currentPage
	
	// 2) 요청처리
	// 페이징 rowPerPage
	int rowPerPage = 10;
	int beginRow = 0;
	// db연결 -> 모델생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	//Connection conn = DriverManager.getConnection("jdbc:mariadb://:localhost:3306","",""); //("프로토콜://주소:포트번호", "", "") 
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	String sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, CONCAT(e.first_name, e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?,?"; // ORDER BY ~~ join과는 관련없는 옵션
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, rowPerPage);	
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empNo", rs.getInt("empNo"));
		m.put("salary", rs.getInt("salary"));
		m.put("fromDate", rs.getString("fromDate"));
		m.put("name", rs.getString("name"));
		list.add(m);
	}
	rs.close();
	stmt.close();
	conn.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>salaryMapList</title>
<!-- 부트스트랩 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h1>연봉 목록</h1>
	<table class="table">
		<tr>
			<th>사원번호</th>
			<th>연봉</th>
			<th>입사일</th>
			<th>이름</th>
		</tr>
		<%
			for(HashMap<String, Object> m : list) {
		%>	
				<tr>
					<td><%=m.get("empNo")%></td>
					<td><%=m.get("salary")%></td>
					<td><%=m.get("fromDate")%></td>
					<td><%=m.get("name")%></td>
				</tr>	
		<%
			}
		%>
	</table>
</body>
</html>