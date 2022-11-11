<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청분석
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 2. 요청처리 후 필요하다면 모델데이터를 생성
	final int ROW_PER_PAGE = 10;
	int beginRow = (currentPage-1) * ROW_PER_PAGE; // ... Limit beginRow, ROW_PER_PAGE
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String cntSql = "SELECT COUNT(*) cnt FROM board;";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	// 올림 5.2 -> 6.0 5.0 -> 5.0
	int lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE));
	
	String listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?,?"; // as 사용
	PreparedStatement listStmt = conn.prepareStatement(listSql);
	listStmt.setInt(1, beginRow);
	listStmt.setInt(2, ROW_PER_PAGE);
	ResultSet listRs = listStmt.executeQuery();
	ArrayList<Board> boardList = new ArrayList<Board>();
	while(listRs.next()) {
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
		boardList.add(b);
	}
	
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
		<div>	
		<a href="<%=request.getContextPath()%>/board/insertBoardForm.jsp" class="btn btn-warning btn-sm">글쓰기</a>
		</div>
		<!-- 3. 모델데이터(ArrayList<Board> 출력 -->
		<table class="table table-hover">
			<thead>
				<tr>
					<th>제목</th>
					<th>내용</th>
				</tr>
			</thead>
			<tbody>
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
			</tbody>	
		</table>
		<!-- 3-2. 페이징 -->
		<div>
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
				if(currentPage <lastPage) {
			%>
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage +1%>" class="text-dark">다음</a>
			<%
				}
			%>
	
			<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>" class="text-dark">마지막</a>
		</div>
	</div>
</body>
</html>
