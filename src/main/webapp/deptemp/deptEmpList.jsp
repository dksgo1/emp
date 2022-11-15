<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8"); // 인코딩
	String word = request.getParameter("word"); 
	// 1) 요청분석
	// 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 2) 요청처리
	// 페이징 rowPerPage
	int rowPerPage = 10;
	int beginRow = (currentPage-1) * rowPerPage;
	// db연결 -> 모델생성
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(word == null) { //전체
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no";
		cntStmt = conn.prepareStatement(cntSql);
	} else { //검색
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name like ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
	}
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	String sql = null;
	PreparedStatement stmt = null;
	if(word == null) {
		sql = "SELECT de.emp_no empNo, e.first_name firstName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no ORDER BY de.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
	} else {
		sql = "SELECT de.emp_no empNo, e.first_name firstName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name LIKE ? ORDER BY de.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+word+"%");
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);		
	}
	ResultSet rs = stmt.executeQuery();
	ArrayList<DeptEmp> list = new ArrayList<DeptEmp>();
	while(rs.next()) {
		DeptEmp de = new DeptEmp();
		de.emp = new Employee();
		de.emp.empNo = rs.getInt("empNo");
		de.emp.firstName = rs.getString("firstName");
		de.dept = new Department();
		de.dept.deptName = rs.getString("deptName");
		de.fromDate = rs.getString("fromDate");
		de.toDate =  rs.getString("toDate");
		list.add(de);

	}
	// lastPage
	int lastPage = (int)(Math.ceil((double)cnt / (double)rowPerPage));
	
	rs.close();
	stmt.close();
	conn.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- 부트스트랩 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container w-50 h-50">
		<h1>DEPT EMP LIST</h1>
		<table class="table table-striped">
			<tr>
				<th>사원번호</th>
				<th>이름</th>
				<th>부서이름</th>
				<th>입사일</th>
				<th>퇴사일</th>
			</tr>
			<%
				for(DeptEmp de : list) {
			%>
					<tr>
						<td><%=de.emp.empNo%></td>
						<td><%=de.emp.firstName%></td>
						<td><%=de.dept.deptName%></td>
						<td><%=de.fromDate%></td>
						<td><%=de.toDate%></td>
					</tr>
			<%
				}
			%>		
		</table>
		<form action="<%=request.getContextPath()%>/deptemp/deptEmpList.jsp" method="post">  
			<label for="word">이름 검색 :</label>
			<input type="text" name="word" id="word">
			<button type="submit">검색</button>
		</form>	   
		<!-- 페이징 -->
		<div>
			<%
				if(word == null) { // 검색 안했을때
			%>	
					<a href="<%=request.getContextPath()%>/deptemp/deptEmpList.jsp?currentPage=1 "class="text-dark">처음</a>
					<%
						if(currentPage > 1) {
					%>	
							<a href="<%=request.getContextPath()%>/deptemp/deptEmpList.jsp?currentPage=<%=currentPage -1%>" class="text-dark">이전</a>
					<%
						}
					%>
					
					<span><%=currentPage%></span>
					<%
						if(currentPage < lastPage) {
					%>
							<a href="<%=request.getContextPath()%>/deptemp/deptEmpList.jsp?currentPage=<%=currentPage +1%>" class="text-dark">다음</a>
					<%
						}
					%>
			
					<a href="<%=request.getContextPath()%>/deptemp/deptEmpList.jsp?currentPage=<%=lastPage%>" class="text-dark">마지막</a>
			<%
				} else { // 검색했을떄
			%>		
					<a href="<%=request.getContextPath()%>/deptemp/deptEmpList.jsp?currentPagee=1&word=<%=word%>" class="text-dark">처음</a>
					<%
						if(currentPage > 1) {
					%>
							<a href="<%=request.getContextPath()%>/deptemp/deptEmpList.jsp?currentPage=<%=currentPage -1%>&word=<%=word%>" class="text-dark">이전</a>
					<%
						}
					%>
					
					<span><%=currentPage %></span>
					<%
						if(currentPage < lastPage) {
					%>		
							<a href="<%=request.getContextPath()%>/deptemp/deptEmpList.jsp?currentPage=<%=currentPage +1%>&word=<%=word%>" class="text-dark">다음</a>	
					<%
						}
					%>
					
					<a href="<%=request.getContextPath()%>/deptemp/deptEmpList.jsp?currentPage=<%=lastPage%>&word=<%=word%>" class="text-dark">마지막</a>			
			<%
				}
			%>
		</div>
	</div>	
</body>
</html>