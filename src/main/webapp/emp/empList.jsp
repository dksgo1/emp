<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	request.setCharacterEncoding("utf-8"); // 인코딩
	String word = request.getParameter("word"); 
	
	// 페이지 알고리즘
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}

	// 2
	final int ROW_PER_PAGE = 10; // 상수, 대문자로 쓰기
	int beginRow = (currentPage-1) * ROW_PER_PAGE;
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(word == null) {
		cntSql = "SELECT COUNT(*) cnt FROM employees";
		cntStmt = conn.prepareStatement(cntSql);
	} else {
		cntSql = "SELECT COUNT(*) cnt FROM employees WHERE first_name LIKE ? OR last_name LIKE ?";
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
	
	// 한페이지당 출력할 emp목록
	String empSql = null;
	PreparedStatement empStmt = null;
	if(word == null) {
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setInt(1, beginRow);
		empStmt.setInt(2, ROW_PER_PAGE);
	} else {
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees WHERE first_name LIKE ? OR last_name LIKE ? ORDER BY emp_no ASC LIMIT ?,?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setString(1, "%"+word+"%");
		empStmt.setString(2, "%"+word+"%");
		empStmt.setInt(3, beginRow);
		empStmt.setInt(4, ROW_PER_PAGE);
	}
	
	ResultSet empRs = empStmt.executeQuery();
	ArrayList<Employee> empList = new ArrayList<Employee>();
	while(empRs.next()) {
		Employee e = new Employee();
		e.empNo = empRs.getInt("empNo");
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		empList.add(e);
	}
%>	
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>empList</title>
		<!-- bootstrap -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>	
	</head>
	<body class="bg-warning p-3 bg-opacity-10">
		<!-- 메뉴 partial jsp 구성 -->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<div class="container pt-2 w-25 h-25">
			<div>
				<h1>사원목록</h1>
				<div>현재 페이지 : <%=currentPage%></div>
				<table class="table table-bordered table-sm">
					<tr>
						<th>사원번호</th>
						<th>퍼스트네임</th>
						<th>라스트네임</th>
					</tr>
					<%
						for(Employee e : empList) {
					%>
							<tr>
								<td><%=e.empNo%></td>
								<td><a href=""><%=e.firstName%></a></td>
								<td><%=e.lastName%></td>
							</tr>
					<%
						}
					%>
				</table>
				
				<!-- 페이징 코드 -->
				<div>
					<%
						if(word == null) { // 검색 안했을 경우
					%>
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">처음</a>
							<%
								if(currentPage > 1) {
							%>
									<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전</a>
							<%
								}
							%>	
							<span><%=currentPage%></span>	
							<% 
								if(currentPage < lastPage) {
							%>
									<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a>
							<%
								}
							%>
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막</a>
					<%
						} else { // 검색했을 경우
					%>		
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1&word=<%=word%>">처음</a>
							<%
								if(currentPage > 1) {
							%>
									<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage -1%>&word=<%=word%>">이전</a>	
							<%
								}
							%>		
							<span><%=currentPage%></span>
							<%
								if(currentPage < lastPage) {
							%>
									<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage +1%>&word=<%=word%>">다음</a>
							<%
								}
							%>
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
					<%
						}
					%>
						</div>
				<form action="<%=request.getContextPath()%>/emp/empList.jsp" method="post">  
					<label for="word">내용 검색 :</label>
					<input type="text" name="word" id="word">
					<button type="submit">검색</button>
				</form>	   
			</div>
		</div>
	</body>
</html>