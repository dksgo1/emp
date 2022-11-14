<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8"); // 인코딩
	String word = request.getParameter("word"); 
	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 2. 요청처리 후 필요하다면 모델데이터를 생성
	final int ROW_PER_PAGE = 10; // 상수, 대문자로 쓰기
	int beginRow = (currentPage-1) * ROW_PER_PAGE; // ... Limit beginRow, ROW_PER_PAGE
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(word == null) { // 전체 
		cntSql = "SELECT COUNT(*) cnt FROM board";
		cntStmt = conn.prepareStatement(cntSql);
	} else { // 검색
		cntSql = "SELECT COUNT(*) cnt FROM board WHERE board_content LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
	}
	
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
		
	String listSql = null;
	PreparedStatement listStmt = null;
	if(word == null) { // 전체
		listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?,?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setInt(1, beginRow);
		listStmt.setInt(2, ROW_PER_PAGE);
	} else { // 검색
		listSql = "SELECT board_no boardNo, board_title boardTitle FROM board WHERE board_content LIKE ? ORDER BY board_no ASC LIMIT ?,?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, "%"+word+"%");
		listStmt.setInt(2, beginRow);
		listStmt.setInt(3, ROW_PER_PAGE);
	}
	
	ResultSet listRs = listStmt.executeQuery();
	ArrayList<Board> boardList = new ArrayList<Board>();
	while(listRs.next()) {
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
		boardList.add(b);
	}
	// 올림 5.2 -> 6.0 5.0 -> 5.0 마지막페이지
	int lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE));
%>	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="bg-dark p-3 bg-opacity-10">
	<div class="container w-50 h-50">
		<!-- 메뉴 partial jsp 구성 -->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<div class="text-center">
			<h1>자유 게시판</h1>
		</div>	
		<!-- 내용 검색창 -->
		<form action="<%=request.getContextPath()%>/board/boardList.jsp" method="post">  
			<label for="word">내용 검색 :</label>
			<input type="text" name="word" id="word">
			<button type="submit">검색</button>   
  	 </form>
		<!-- 3. 모델데이터(ArrayList<Board> 출력 -->
		<table class="table table-hover">
			<tr>
				<th>제목</th>
				<th>내용</th>
			</tr>
			
			<%
				for(Board b : boardList) {
			%>
					<tr>
						<td><%=b.boardNo %></td>
						<!-- 제목 클릭시 상세보기 이동 -->
						<td>
							<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>">
								<%=b.boardTitle%>
							</a>
						</td>
					</tr>
			<%
				}
			%>
		</table>
		<a class="btn btn-warning border border-primary" href="<%=request.getContextPath()%>/board/insertBoardForm.jsp">글쓰기</a>
		<!-- 3-2. 페이징 -->
		<div>
			<%
				if(word == null) { // 검색 안했을때
			%>	
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1 "class="text-dark">처음</a>
					<%
						if(currentPage > 1) {
					%>	
							<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage -1%>" class="text-dark">이전</a>
					<%
						}
					%>
					
					<span><%=currentPage%></span>
					<%
						if(currentPage < lastPage) {
					%>
							<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage +1%>" class="text-dark">다음</a>
					<%
						}
					%>
			
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>" class="text-dark">마지막</a>
			<%
				} else { // 검색했을떄
			%>		
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1&word=<%=word%>" class="text-dark">처음</a>
					<%
						if(currentPage > 1) {
					%>
							<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage -1%>&word=<%=word%>" class="text-dark">이전</a>
					<%
						}
					%>
					
					<span><%=currentPage %></span>
					<%
						if(currentPage < lastPage) {
					%>		
							<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage +1%>&word=<%=word%>" class="text-dark">다음</a>	
					<%
						}
					%>
					
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>&word=<%=word%>" class="text-dark">마지막</a>			
			<%
				}
			%>
		</div>
	</div>
</body>
</html>
