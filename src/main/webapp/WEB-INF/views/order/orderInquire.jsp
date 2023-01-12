<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<p><b>주문 조회</b></p>
<!-- 이거를.. 지금 상품 하나하나 다 별개의 주문으로 들어갔는데
결제건 단위로 주문한 상품들을 묶어야할 것 같다. 할인이나 뭐 그런거 들어가려면. 다음프로젝트부터.<br><br> -->


<div class="orderedList">
<c:if test="${!empty orderList}">
	<c:forEach var="order" items="${orderList }" varStatus="status">
	<div class="inquireDiv">
		<p class="orderday">[${order.orderday }]</p>
		<ul class="orderInfo">
			<li class="info">
				<p class="name">${order.gName }</p>
				<p>[사이즈] ${order.gSize }</p>
				<p>[컬러] ${order.gColor }</p>
				<p>${order.gPrice }원 / 수량 ${order.gAmount }개</p>
				<p></p>
			</li>
			<li class="image"><img src="/resources/images/items/${order.gImage }.gif" /></li>
		</ul>
		<p class="title">결제정보</p>
		<div class="payInfo">
			<c:if test="${order.payMethod  == 'credit'}">신용카드</c:if>
			<c:if test="${order.payMethod  == 'bankTransfer'}">계좌이체</c:if>
			<c:if test="${order.payMethod  == 'deposit'}">무통장입금</c:if>
		</div>
		<p class="title">배송지정보</p>
		<div class="addrInfo">
			<dl>
				<dt>주문자명</dt>
				<dd>${order.orderName }</dd>
			</dl>
			<dl>
				<dt>우편번호</dt>
				<dd>${order.post }</dd>
			</dl>
			<dl>
				<dt>도로명주소</dt>
				<dd>${order.addr1 }</dd>
			</dl>
			<dl>
				<dt>지번주소</dt>
				<dd>${order.addr2 }</dd>
			</dl>
			<dl>
				<dt>연락처</dt>
				<dd>${order.phone }</dd>
			</dl>
		</div>
	</div>
	</c:forEach>
</c:if>
<c:if test="${empty orderList}">
	<p>주문 내역이 없습니다.</p>
</c:if>
</div>