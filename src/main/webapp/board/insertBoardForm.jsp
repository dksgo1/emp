<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<!-- 메뉴 partial jsp 구성 -->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<div class="container">
			<h3>게시글 추가</h3>
			<form method="post" action="<%=request.getContextPath()%>/board/insertBoardAction.jsp">
				<table class="table table-striped">
					<tr>
						<td>제목</td>
						<td>
							<input type="text" name="boardTitle" value="">
						</td>
					</tr>
					<tr>
						<td>내용</td>
						<td>
							<textarea rows="5" cols="100" name="boardContent"> </textarea>
						</td>
					</tr>
					<tr>
						<td>글쓴이</td>
						<td>
							<input type="text" name="boardWriter" value="">
						</td>
					</tr>
					<tr>
						<td>비밀번호</td>
						<td>
							<input type="password" name="boardPw">
						</td>
					</tr>
					<tr class="text-center">
						<td colspan="2">
							<button type="submit" class="bg-secondary p-3">추가</button>
						</td>
					</tr>	
				</table>	
			</form>
		</div>	
	</body>
</html>