<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${!empty cartList}">
	<form name="cartListForm" method="post">
		<table class="cartListTable">
			<thead>
				<tr>
					<th>
						<input type="checkbox" id="chkAll" />
					</th>
					<th>번호</th>
					<th colspan="2">상품 정보</th>
					<th>판매가</th>
					<th>수량</th>
					<th>합계</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="dto" items="${cartList}" varStatus="status">
				<tr>
					<td><input type="checkbox" name="check" value="${dto.num}" class="check" id="chkNum${dto.num}" /></td>
					<td>${dto.num}<input type="hidden" name="num" class="num" value="${dto.num}"/></td>
					<td colspan="2">
						<div class="gInfo">
							<p class="image"><img src="/resources/images/items/${dto.gImage}.gif" /></p>
							<div class="detail">
								<ul>
									<li class="name">${dto.gName}</li>
									<li class="option">[옵션 : 사이즈(${dto.gSize}), 색상(${dto.gColor})]</li>
								</ul>
							</div>
							<input type="hidden" value="${dto.gCode }" />
						</div>
					</td>
					<td><p class="price">${dto.gPrice}</p></td>
					<td>
						<input type="number" class="gAmount" value="${dto.gAmount}" />
						<a href="javascript:" class="updateBtn">수정</a>
					</td>
					<td><p class="priceSum">${dto.gPrice * dto.gAmount}</p></td> 
					<td>
						<%-- <a href="javascript:order(cartListForm, ${dto.num})">주문</a> --%>
						<a href="javascript:order(cartListForm, ${dto.num})">주문</a> <!-- 선택상품 주문과 동일한 메소드로 처리. -->
						<a href="javascript:cartDelete(cartListForm, ${dto.num})" class="deleteBtn" onclick="">삭제</a>
					</td>
				</tr>
			</c:forEach>
				<tr>
					<td colspan="8" style="text-align:right; border-top:1px solid #888">
					상품 합계 : <b class="gFinalPrice"></b>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
	<div class="btns">
		<a href="javascript:order(cartListForm)">선택 상품 주문하기</a>
		<a href="javascript:cartDeleteChk(cartListForm)" class="delAllBtn">선택 삭제하기</a>
		<a href="/">계속 쇼핑하기</a>
	</div>
</c:if>
<c:if test="${empty cartList}">
	<p>장바구니에 담긴 상품이 없습니다.</p>
</c:if>

<script>
	$(function(){
		//수량 수정
		//넘버, 수량, 판매가, 개별합계
		$(".updateBtn").on("click", function(){
			var num = $(this).closest("tr").find("input[name=num]").val();
			var gAmount = $(this).closest("tr").find(".gAmount").val();
			var gPrice = $(this).closest("tr").find(".price").text();
			var priceSum = $(this).closest("tr").find(".priceSum");
			
			$.ajax({
				url:"/cartUpdate",
				type:"post",
				dataType:"text",
				data:{
					num:num,
					gAmount:gAmount
				},
				success:function(data){
					if(data == "ok"){
						alert("수량이 변경되었습니다.");
						priceSum.text(gAmount * gPrice);
						finalPrice();
					}
				},
				error:function(xhr, status, e){
					console.log("e : "+e)
				}
			});
		});
	});
	
	//개별삭제
	function cartDelete(cartListForm, num){
		$("#chkNum"+num).prop("checked", true);
		cartListForm.action="/cartDelete";
		cartListForm.submit();
	}
	//선택 삭제
	function cartDeleteChk(cartListForm){
		cartListForm.action="/cartDeleteChk";
		cartListForm.submit();
	}
	//개별 주문(선택주문과 동일하게 처리.)
	/* function orderSingle(cartListForm, num){
		$("#chkNum"+num).prop("checked", true);
		cartListForm.action="/order";
		cartListForm.submit();
	} */
	//선택 주문
	function order(cartListForm, num){
		$("#chkNum"+num).prop("checked", true);
		if($(".check:checked").length == 0){
			alert("선택된 상품이 없습니다.");
		}else{
			cartListForm.action="/order";
			cartListForm.submit();
		}
		
	}
</script>
