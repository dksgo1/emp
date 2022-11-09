<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("utf-8"); // 인코딩
	String deptName = request.getParameter("deptName");
	String deptNo = request.getParameter("deptNo");
	if(request.getParameter("deptNo") == null || 
		request.getParameter("deptName") == null) {
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
		return;
	}
	
	Department dept = new Department();
	dept.deptNo = deptNo;
	dept.deptName = deptName;
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	
	// 2-1 dept_name 중복검사
	String sql1 = "SELECT dept_name FROM departments WHERE dept_name = ?";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, deptName);
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()) { // 같은 dept_name가 이미 존재한다.
		String msg = URLEncoder.encode(deptName+"로 수정할 수 없습니다.(이미 있는 이름)","utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp?msg="+msg);
		return;
	}

	String sq2 = "update departments set dept_name=? where dept_no=?";
	PreparedStatement stmt = conn.prepareStatement(sq2);
	stmt.setString(1, deptName);
	stmt.setString(2, deptNo);
	
	// 디버깅
	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>
