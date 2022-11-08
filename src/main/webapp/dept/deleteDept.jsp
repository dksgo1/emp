<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("utf-8"); // 인코딩
	String deptNo = request.getParameter("dept_no");
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	String sq1 = "delete from departments where dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sq1);
	stmt.setString(1, deptNo);
	
	// 디버깅
	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("삭제성공");
	} else {
		System.out.println("삭제실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>	