<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("utf-8"); // 인코딩
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardPw = request.getParameter("boardPw");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	String createdate = request.getParameter("createdate");
	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	String sql = "UPDATE board SET board_title=?, board_content=?, board_writer=? WHERE board_no=? AND board_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, boardTitle);
	stmt.setString(2, boardContent);
	stmt.setString(3, boardWriter);
	stmt.setInt(4, boardNo);
	stmt.setString(5, boardPw);
	
	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
%>	