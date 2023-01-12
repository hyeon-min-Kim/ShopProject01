<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- 일반 jsp태그 사용
<% 
String mesg = (String)request.getAttribute("join"); 
System.out.print(mesg);
if(mesg != null){%>
	<script type="text/javascript">
		alert("<%=mesg%>");
	</script>
<% }%>
 --%>
 
 <c:if test="${!empty mesg }">
	<script>alert("${mesg}")</script>
</c:if>
<!DOCTYPE html>
<html>
<head>
	<jsp:include page="/WEB-INF/views/common/head.jsp"></jsp:include>
	<script type="text/javascript" src="/resources/js/member.js"></script>
</head>
<body>
	<%-- ${nextPage} 
	loginChkInterceptor에서 ModelAndView로 넘긴 uri. 
	이거 대신 MemberController의 login매소드에서 request.getHeader("Referer")를 이용하여 이전페이지 찾음.
	--%>
	<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
	<div class="content">
		<jsp:include page="/WEB-INF/views/member/loginForm.jsp"></jsp:include>
	</div>
</body>
</html>