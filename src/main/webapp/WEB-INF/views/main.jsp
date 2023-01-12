<%@page import="com.dto.MemberDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<%-- <%@ include file="common/head.jsp" %> --%>
	<jsp:include page="/WEB-INF/views/common/head.jsp" flush="false"></jsp:include>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" flush="true"></jsp:include>
	<div class="content">
		<jsp:include page="/WEB-INF/views/goods/goodsList.jsp" flush="true"></jsp:include>
	</div>
</body>
</html>