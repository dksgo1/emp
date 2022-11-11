<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청 분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	

	// 2. 요청 처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql = "SELECT board_no boardNo, board_pw boardPw, board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ?"; // as 사용
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	
	Board board = null;
	if(rs.next()) {
		board = new Board();
		board.boardNo = boardNo;
		board.boardPw = rs.getString("boardPw");
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
		board.createdate = rs.getString("createdate");
	}
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>	
</head>
<body>
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
		<h2>게시글 수정</h2>
		<form action="<%=request.getContextPath()%>/board/updateBoardAction.jsp" method="post">
			<table class="table">
				<tr>
					<td>게시글 번호</td>
					<td><input type="number" name="boardNo" value="<%=board.boardNo%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td><input type="password" name="boardPw"></td>
				</tr>
				<tr>
					<td>제목</td>
					<td><input type="text" name="boardTitle" value="<%=board.boardTitle%>"></td>
				</tr>
				<tr>
					<td>내용</td>
					<td><textarea rows="5" cols="100" name="boardContent"><%=board.boardContent%></textarea></td>
				</tr>
				<tr>
					<td>글쓴이</td>
					<td><input type="text" name="boardWriter" value="<%=board.boardWriter%>"></td>
				</tr>
				<tr>
					<td>생성날짜</td>
					<td><input type="text" name="createdate" value="<%=board.createdate%>"></td>
				</tr>
			</table>
			<button type="submit">수정</button>
		</form>
</body>
</html>