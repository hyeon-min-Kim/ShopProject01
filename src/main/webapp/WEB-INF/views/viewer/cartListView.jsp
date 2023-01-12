<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 <c:if test="${!empty mesg }">
	<script>alert("${mesg}")</script>
</c:if>
<!DOCTYPE html>
<html>
<head>
	<jsp:include page="/WEB-INF/views/common/head.jsp"></jsp:include>
	<script type="text/javascript" src="/resources/js/cart.js"></script>
	<script type="text/javascript">
		window.onpageshow = function(event) { //뒤로가기 이벤트 감지.
			if ( event.persisted || (window.performance && window.performance.navigation.type == 2)) { 
				$("input:checkbox").prop("checked",false); //체크된 체크박스 모두 체크 해제
			} 
		}

	</script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
	<div class="content">
		<c:if test="${!empty login }"> <!-- 로그인 상태의 장바구니 -->
			<jsp:include page="/WEB-INF/views/cart/cartList.jsp"></jsp:include>
		</c:if>
		<c:if test="${empty login }"> <!-- 미 로그인 상태의 장바구니 -->
			<jsp:include page="/WEB-INF/views/cart/cartListTemp.jsp"></jsp:include>
		</c:if>
	</div>
</body>
</html>