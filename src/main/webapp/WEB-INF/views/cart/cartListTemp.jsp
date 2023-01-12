<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${!empty sessionScope.tempCartList}">
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
			<c:forEach var="dto" items="${sessionScope.tempCartList }" varStatus="status">
				<tr>
					<td><input type="checkbox" name="check" value="${status.index}" class="check" id="chkNum${status.index}" /></td>
					<td>${status.index }<input type="hidden" name="num" class="num" value="${status.index}"/></td>
					<td colspan="2">
						<div class="gInfo">
							<p class="image">
								<img src="/resources/images/items/${dto.gImage}.gif" />
								<input type="hidden" name="gImage" value="${dto.gImage}" />
							</p>
							<div class="detail">
								<ul>
									<li class="name">${dto.gName}<input type="hidden" name="gName" value="${dto.gName}" /></li>
									<li class="option">
										[옵션 : 사이즈(${dto.gSize}), 색상(${dto.gColor})]
										<input type="hidden" name="gSize" value="${dto.gSize}" />
										<input type="hidden" name="gColor" value="${dto.gColor}" />
									</li>
								</ul>
							</div>
							<input type="hidden" value="${dto.gCode }" />
						</div>
					</td>
					<td><p class="price">${dto.gPrice}</p><input type="hidden" name="gPrice" value="${dto.gPrice}" /></td>
					<td>
						<input type="number" class="gAmount" name="gAmount" value="${dto.gAmount}" />
						<a href="javascript:" class="updateBtn">수정</a>
					</td>
					<td><p class="priceSum">${dto.gPrice * dto.gAmount}</p></td> 
					<td>
						<a href="javascript:preOrder(cartListForm)">주문</a>
						<a href="javascript:cartDeleteTemp(cartListForm, ${status.index })">삭제</a>
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
		<a href="javascript:javascript:preOrder(cartListForm)">선택 상품 주문하기</a>
		<a href="javascript:cartDeleteChkTemp(cartListForm)" class="delAllBtn">선택 삭제하기</a>
		<a href="/">계속 쇼핑하기</a>
	</div>
</c:if>
<c:if test="${empty sessionScope.tempCartList}">
	<p>장바구니에 담긴 상품이 없습니다.</p>
</c:if>

<script type="text/javascript">
	$(function(){
		//수량 수정
		$(".updateBtn").on("click", function(){
			var num = $(this).closest("tr").find("input[name=num]").val();
			var gAmount = $(this).closest("tr").find(".gAmount").val();
			var gPrice = $(this).closest("tr").find(".price").text();
			var priceSum = $(this).closest("tr").find(".priceSum");
			//console.log(num+","+gAmount+","+gPrice);
			$.ajax({
				url:"/cartUpdateTemp",
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
					console.log("e : "+e);
				}
			});
		});
	});
	
	//개별 삭제
	function cartDeleteTemp(cartListForm, num){
		//console.log(num);
		$("#chkNum"+num).prop("checked", true);
		cartListForm.action="/cartDeleteTemp";
		cartListForm.submit();
	}
	//선택 삭제
	function cartDeleteChkTemp(cartListForm){
		cartListForm.action="/cartDeleteChkTemp";
		cartListForm.submit();
	}
	//개별 주문 및 선택 주문 (비회원상태에서 주문 진행시 '로그인 -> 세션 장바구니에 담긴 모든 상품을 DB장바구니에 담기 -> 로그인 상태에서 다시 주문 진행'과정으로 처리.)
	function preOrder(cartListForm){
		cartListForm.action="/loginChk/preOrder";
		cartListForm.submit();
	}
</script>
