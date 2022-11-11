<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String msg = request.getParameter("msg"); // 삭제실패시 리다이렉트시에는 null값이 아니고 메시지가 있다
%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="bg-primary p-3 bg-opacity-10">
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div style="padding:150px">
		<h3 class=text-center>댓글 삭제</h3>
			
		<%
			if(msg != null) {
		%>
				<div><%=msg%></div>
		<%
			}
		%>
		
		<div class=text-center>
			<form action="<%=request.getContextPath()%>/board/deleteCommentAction.jsp" method="post">
				<input type="hidden" name="boardNo" value="<%=boardNo%>">
				<input type="hidden" name="commentNo" value="<%=commentNo%>">
				비밀번호 :
				<input type="password" name="commentPw">
				<button type="submit">삭제</button>
			</form>
		</div>
	</div>
</body>
</html>