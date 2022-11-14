<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>	

<!-- partial jsp 페이지 사용할 코드 -->
<div class="btn-group">
<a href="<%=request.getContextPath()%>/dept/index.jsp" class="btn btn-primary btn-sm">[홈으로]</a>
<a href="<%=request.getContextPath()%>/dept/deptList.jsp" class="btn btn-primary btn-sm">[부서관리]</a>
<a href="<%=request.getContextPath()%>/emp/empList.jsp" class="btn btn-primary btn-sm">[사원관리]</a>
<a href="<%=request.getContextPath()%>/"class="btn btn-primary btn-sm">[연봉관리]</a>
<a href="<%=request.getContextPath()%>/board/boardList.jsp" class="btn btn-primary btn-sm">[게시판관리]</a>
</div>