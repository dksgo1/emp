<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	//1. 요청 분석
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentPw = request.getParameter("commentPw");
	// 2. 요청 처리	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	String sql = "DELETE FROM comment WHERE comment_no = ? AND comment_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, commentNo);
	stmt.setString(2, commentPw);
	// 쿼리 실행
	int row = stmt.executeUpdate();
	if(row == 1) {
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	} else {
		String msg = URLEncoder.encode("비밀번호를 확인하세요", "utf-8"); // 비밀번호 틀릴경우
		response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?boardNo="+boardNo+"&commentNo="+commentNo+"&msg="+msg);
	}
%>




<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>