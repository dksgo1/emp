<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	request.setCharacterEncoding("utf-8"); // 인코딩
	String word = request.getParameter("word"); 
	// 1 
	// 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2
	
	final int ROW_PER_PAGE = 10; // 상수, 대문자로 쓰기
	int beginRow = (currentPage-1) * ROW_PER_PAGE; 
	
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
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(word == null) {
		cntSql = "SELECT COUNT(*) cnt FROM salaries";
		cntStmt = conn.prepareStatement(cntSql);
	} else {
		cntSql= "SELECT COUNT(*) cnt FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
		cntStmt.setString(2, "%"+word+"%");
	}
	
	ResultSet countRs = cntStmt.executeQuery();
	int count = 0;
	if(countRs.next()) {
		count = countRs.getInt("cnt");
	}
	
	int lastPage = count / ROW_PER_PAGE;
	if(count % ROW_PER_PAGE != 0) {
		lastPage = lastPage +1; // lastPage++, lastPage+=1 다같은 표현
	}
	
	String salarySql = null;
	PreparedStatement salaryStmt = null;
	if(word == null) {
		salarySql = "SELECT s.emp_no empNo, s.salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?";
		salaryStmt = conn.prepareStatement(salarySql);
		salaryStmt.setInt(1, beginRow);
		salaryStmt.setInt(2, ROW_PER_PAGE);
	} else {
		salarySql = "SELECT s.emp_no empNo, s.salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? ORDER BY s.emp_no ASC LIMIT ?, ?";
		salaryStmt = conn.prepareStatement(salarySql);
		salaryStmt.setString(1, "%"+word+"%");
		salaryStmt.setString(2, "%"+word+"%");
		salaryStmt.setInt(3, beginRow);
		salaryStmt.setInt(4, ROW_PER_PAGE);
	}
	
	ResultSet salaryRs = salaryStmt.executeQuery();
	ArrayList<Salary> salaryList = new ArrayList<Salary>();
	while(salaryRs.next()) {
		Salary s = new Salary();
		s.emp = new Employee();
		s.emp.empNo = salaryRs.getInt("empNo");
		s.salary = salaryRs.getInt("salary");
		s.fromDate = salaryRs.getString("fromDate");
		s.toDate = salaryRs.getString("toDate");
		s.emp.firstName = salaryRs.getString("firstName");
		s.emp.lastName = salaryRs.getString("lastName");
		salaryList.add(s);
	}
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
	<h1 class=text-center>연봉관리</h1>
	<div class="container w-50 h-50">
		<table class="table">
			<tr class="table-dark">
				<th>사원번호</th>
				<th>퍼스트네임</th>
				<th>라스트네임</th>
				<th>연봉</th>
				<th>FROM DATE</th>
				<th>TO DATE</th>
			</tr>
			<%
				for(Salary s : salaryList) {
			%>
					<tr>
						<td><%=s.emp.empNo%></td>
						<td><%=s.emp.firstName%></td>
						<td><%=s.emp.lastName%></td>
						<td><%=s.salary%></td>
						<td><%=s.fromDate%></td>
						<td><%=s.toDate%></td>
						
					</tr>	
			<%
				}		
			%>
		</table>
		<!-- 검색창 -->
		<form action="<%=request.getContextPath()%>/salary/salaryList1.jsp" method="post">  
			<label for="word">이름 검색 :</label>
			<input type="text" name="word" id="word">
			<button type="submit">검색</button>
		</form>	 
		<!-- 페이징 --> 
		<div>
			<%
				if(word == null) { // 검색 안했을때
			%>	
					<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=1 "class="text-dark">처음</a>
					<%
						if(currentPage > 1) {
					%>	
							<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage -1%>" class="text-dark">이전</a>
					<%
						}
					%>
					
					<span><%=currentPage%></span>
					<%
						if(currentPage < lastPage) {
					%>
							<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage +1%>" class="text-dark">다음</a>
					<%
						}
					%>
			
					<a href="<%=request.getContextPath()%>/d/salary/salaryList1.jsp?currentPage=<%=lastPage%>" class="text-dark">마지막</a>
			<%
				} else { // 검색했을떄
			%>		
					<a href="<%=request.getContextPath()%>//salary/salaryList1.jsp?currentPagee=1&word=<%=word%>" class="text-dark">처음</a>
					<%
						if(currentPage > 1) {
					%>
							<a href="<%=request.getContextPath()%>//salary/salaryList1.jsp?currentPage=<%=currentPage -1%>&word=<%=word%>" class="text-dark">이전</a>
					<%
						}
					%>
					
					<span><%=currentPage %></span>
					<%
						if(currentPage < lastPage) {
					%>		
							<a href="<%=request.getContextPath()%>//salary/salaryList1.jsp?currentPage=<%=currentPage +1%>&word=<%=word%>" class="text-dark">다음</a>	
					<%
						}
					%>
					
					<a href="<%=request.getContextPath()%>//salary/salaryList1.jsp?currentPage=<%=lastPage%>&word=<%=word%>" class="text-dark">마지막</a>			
			<%
				}
			%>
		</div> 
	</div>	
</body>
</html>