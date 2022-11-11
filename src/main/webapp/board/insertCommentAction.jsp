<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	request.setCharacterEncoding("utf-8"); // 인코딩
	
	// 1. 요청 분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentPw = request.getParameter("commentPw");
	String commentContent = request.getParameter("commentContent");
	
	
	
	// 디버깅
	System.out.println("boardNo : " + boardNo + " commentContent : " + commentContent +" commentPw : " + commentPw);
	
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	
	String sql = "INSERT INTO COMMENT(board_no, comment_pw, comment_content, createdate) VALUES(?, ?, ?, CURDATE())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setString(2, commentPw);
	stmt.setString(3, commentContent);
	
	// 디버깅
	int row = stmt.executeUpdate();
	   if(row == 1) {
	      System.out.println("입력성공");
	   } else {
	      System.out.println("입력실패");
	   }
   response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
%>