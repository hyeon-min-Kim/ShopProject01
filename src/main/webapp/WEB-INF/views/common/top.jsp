<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- top부분
로그인 시 - ***님 반갑습니다, 로그아웃, 장바구니, mypage
로그아웃 시 - 로그인, 회원가입, 장바구니, mypage
 -->
<c:if test="${!empty login }">
	<span>${sessionScope.login.username } 님  반갑습니다!</span>
	<a href="<%=request.getContextPath() %>/loginChk/logout">로그아웃</a>
	<a href="<%=request.getContextPath() %>/cartList">장바구니</a>
	<a href="<%=request.getContextPath() %>/loginChk/mypage">mypage</a>
</c:if>
<c:if test="${empty login }">
	<a href="<%=request.getContextPath() %>/loginForm">로그인</a>
	<a href="<%=request.getContextPath() %>/joinForm">회원가입</a>
	<a href="<%=request.getContextPath() %>/cartList">장바구니</a>
	<a href="<%=request.getContextPath() %>/loginChk/mypage">mypage</a>
</c:if>
