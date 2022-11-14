<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	// 1
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));	
	// 댓글 페이징에 사용할 현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 2
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	String sql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	Board board = null;
	if(rs.next()) {
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
		board.createdate = rs.getString("createdate");
	}
	
	// 2-2 댓글 목록
	final int ROW_PER_PAGE = 5;
	int beginRow = (currentPage-1) * ROW_PER_PAGE;
	String cntSql = "SELECT COUNT(*) cnt FROM comment WHERE board_no = ?";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	cntStmt.setInt(1, boardNo);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	// 디버깅
	System.out.println(cnt);
	// lastpage
	int lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE));
	
	String commentSql = "SELECT comment_no commentNo, comment_content commentContent FROM comment WHERE board_no = ? ORDER BY comment_no DESC LIMIT ?,?";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, beginRow);
	commentStmt.setInt(3, ROW_PER_PAGE);
	ResultSet commentRs = commentStmt.executeQuery();
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()) {
		Comment c = new Comment();
		c.commentNo = commentRs.getInt("commentNo");
		c.commentContent = commentRs.getString("commentContent");
		commentList.add(c);
	}
	
	// 2-3 댓글 전체행의 수 -> lastpage
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<style>
	a:link {
        text-decoration: none;
        
    }
</style>
</head>
<body class="bg-warning p-3 bg-opacity-10">
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<h3 class=text-center>게시글 상세보기</h3>
	<table class="table table-bordered container w-50 h-50">
			<tr>
				<td>번호</td>
				<td><%=board.boardNo%></td>
			</tr>
			<tr>
				<td>제목</td>
				<td><%=board.boardTitle%></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><%=board.boardContent%></td>
			</tr>
			<tr>
				<td>글쓴이</td>
				<td><%=board.boardWriter%></td>
			</tr>
			<tr>
				<td>생성날짜</td>
				<td><%=board.createdate%></td>
			</tr>
	</table>
	<div class="container btn float-right">
		<a href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=boardNo%>" class="btn btn-dark">수정</a>	
		<a href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=boardNo%>" class="btn btn-dark">삭제</a>
	</div>
	<p>
	</p>	
	<div class="container w-50 h-50">
		<!-- 댓글입력 폼 -->
		<h4>댓글입력</h4>
		<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp" method="post">
			<input type="hidden" name="boardNo" value="<%=board.boardNo%>">
			<table class="table">
				<tr>
					<td>내용</td>
					<td><textarea rows="3" cols="80" name="commentContent"></textarea></td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td><input type="password" name="commentPw"></td>
				</tr>
			</table>
			<button type="submit">댓글입력</button>
		</form>
	</div>
	<p>
	</p>
	 <div class="container w-50 h-50">
    	<!-- 댓글 목록 -->
     	 <h4>댓글목록</h4>
      	<%
			for(Comment c : commentList) {
      	%>
				<div>
					<div>
						<%=c.commentNo%>
						<a href="<%=request.getContextPath()%>/board/deleteCommentForm.jsp?boardNo=<%=boardNo%>&commentNo=<%=c.commentNo%>" class="btn btn-danger btn-sm">
						   삭제
						</a>
	               </div>
	               <div><%=c.commentContent%></div>
	            </div>
	      <%      
	         }
	      %>
	      <!-- 댓글 페이징 -->
		<div>
			<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=1">처음</a>			   
	      	<%
				if(currentPage > 1) {
	      	%>
					<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>">
            			이전
       				</a>
	      	<%      
	       	  	} else if(currentPage == lastPage)
	      	%>   
	      	
 			<% 	// 다음 <-- 마지막페이지 <-- 전체행의 수 
				if(currentPage < lastPage) {
			%>
	            	<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>">
	             	  다음
	            	</a>
			<%   
				}	
			%>
			<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=lastPage%>">마지막</a>
		</div>	      
	</div>

</body>
</html>