<%@page import="java.util.ArrayList"%>
<%@page import="com.dto.OrderDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- ${orderList } --%>
<div class="orderComplete">
	<p class="taC mt60"><b>주문 완료</b></p>
	<p class="taC mt30">주문 해 주셔서 감사합니다. <br><b>${sessionScope.login.username }</b>님의 주문이 안전하게 처리되었습니다.<p>
	<p class="mt50"><b>배송지 정보</b></p>
	<table class="type01 bor mt20">
		<tbody>
			<tr>
				<th class="fir">받으시는 분</th>
				<td class="fir">${orderList[0].orderName }</td>
			</tr>
			<tr>
				<th>주소</th>
				<td>${orderList[0].addr1 }</td>
			</tr>
			<tr>
				<th>휴대전화</th>
				<td>${orderList[0].phone }</td>
			</tr>
		</tbody>
	</table>
	<p class="mt40"><b>상품 정보</b></p>
	<table class="cartListTable mt20 taC">
		<thead>
			<tr>
				<th>상품명</th>
				<th>판매가</th>
				<th>수량</th>
				<th>합계</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="goods" items="${orderList }" varStatus="status">
			<tr>
				<td class="taL">${goods.gName}</td>
				<td>${goods.gPrice}</td>
				<td>${goods.gAmount}</td>
				<td><p class="pSum">${goods.gPrice * goods.gAmount}</p></td>
			</tr>	
			</c:forEach>
		</tbody>
	</table>
	<p class="mt40"><b>결제 정보</b></p>
	<table class="type01 bor mt20">
		<tbody>
			<tr>
				<th class="fir">총 결제 금액</th>
				<td class="fir"><p class="pFinal"></p></td>
			</tr>
			<tr>
				<th>결제 수단</th>
				<td>
					<c:if test="${orderList[0].payMethod == 'credit'}">신용카드</c:if>
					<c:if test="${orderList[0].payMethod == 'bankTransfer'}">계좌이체</c:if>
					<c:if test="${orderList[0].payMethod == 'deposit'}">무통장입금</c:if>
				</td>
			</tr>
		</tbody>
	</table>
	
	<div class="btns taC" style="margin-top:30px">
		<a href="/loginChk/orderInquire">주문내역 조회하기</a>
		<a href="/">계속 쇼핑하기</a>
	</div>
</div>
<script>
	$(function(){
		var pFinal = 0;
		$(".pSum").each(function(){
			var sum = parseInt($(this).text());
			pFinal += sum;
		});
		$(".pFinal").text(pFinal);
		
		
	});
</script>