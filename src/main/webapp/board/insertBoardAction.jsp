<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	request.setCharacterEncoding("utf-8"); // 인코딩
	
	// 1. 요청 분석
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	String boardPw = request.getParameter("boardPw");
	
	// 디버깅
	System.out.println("boardTitle: " + boardTitle + " boardContent: " + boardContent +" boardWriter: " + boardWriter);
	
	
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	
	String sql = "insert into board(board_title, board_content, board_writer, board_pw, createdate) values(?, ?, ?, ?, CURDATE())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, boardTitle);
	stmt.setString(2, boardContent);
	stmt.setString(3, boardWriter);
	stmt.setString(4, boardPw);

	
	
	// 디버깅
	int row = stmt.executeUpdate();
	   if(row == 1) {
	      System.out.println("입력성공");
	   } else {
	      System.out.println("입력실패");
	   }
   response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
%>