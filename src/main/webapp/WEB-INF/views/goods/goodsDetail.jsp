<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- ${goodsDetail} --%>
<form name="goodsRetriveForm" id="goodsRetriveForm" method=post>
	<div class="goodRetrive">
		<div class="imageDiv">
			<img src="/resources/images/items/${goodsDetail.gImage}.gif" />
			<input type="hidden" name="gImage" value="${goodsDetail.gImage}" />
		</div>
		<div class="infoDiv">
			<table align="center" cellspacing="0" cellpadding="0" border="0" style='margin-left: 30px'>
				<tbody>
					<tr>
						<th>상품명</th>
						<td>
							${goodsDetail.gName}
							<input type="hidden" name="gName" value="${goodsDetail.gName}" />
							<input type="hidden" name="gCode" value="${goodsDetail.gCode}" />
						</td>
					</tr>
					<tr>
						<th>가격</th>
						<td>${goodsDetail.gPrice}<input type="hidden" name="gPrice" value="${goodsDetail.gPrice}" /></td>
					</tr>
					<tr>
						<th>상품 옵션</th>
						<td>
							<select name="gSize">
								<option value="s" selected>S</option>
								<option value="m">M</option>
								<option value="l">L</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>색상</th>
						<td>
							<select name="gColor">
								<option value="white" selected>white</option>
								<option value="black">black</option>
								<option value="beige">beige</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>주문 수량</th>
						<td>
							<p class="amountCtrl">
								<a href="javascript:" class="down">-</a>
								<input type="number" value="1" name="gAmount" readonly/>
								<a href="javascript:" class="up">+</a>
							</p>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<div class="btns" style="padding-top:20px;">
								<a href="javascript:buyNow(goodsRetriveForm, '${goodsDetail.gCode}')" id="buynow">바로 구매</a>
								<a href="javascript:" id="addCart">장바구니 담기</a>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<div class="contentBox">
								<p>PRODUCT INFO</p>
								<div>${goodsDetail.gContent}</div>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</form>
<script>
	//바로구매
	function buyNow(goodsRetriveForm, code){ 
		console.log(code)
		goodsRetriveForm.action="/loginChk/buyNow/"+code;
		goodsRetriveForm.submit();
	}

	$(function(){
		//장바구니 추가
		$("#addCart").on("click", addCart);
		function addCart(){
			//$("#goodsRetriveForm").attr("action", "/loginChk/addCart/${goodsDetail.gCode}").submit();
			//장바구니 담기 완료 후 return "forward:/details/"+gCode;로 보내면 uri가 /loginChk/addCart/T3상태인 채로 제품상세 페이지가 노출됨. 
			//뒤로가기 하면 같은페이지로 uri만 /details/T3로 바뀜.
			//return "redirect:/details/"+gCode;로 보내면 request.setAttribute("mesg", "장바구니에 상품을 담았습니다."); 메세지가 다음 메소드로 안넘어감.
			//=>그러면 ajax로 처리 후 "장바구니에 상품을 담았습니다." 얼럿노출로 바꿈. 로그인체크도 주문단계에서 확인.
			var gCode = $("input[name=gCode]").val();
			var gName = $("input[name=gName]").val();
			var gPrice = $("input[name=gPrice]").val();
			var gSize = $("select[name=gSize]").val();
			var gColor = $("select[name=gColor]").val();
			var gAmount = $("input[name=gAmount]").val();
			var gImage = $("input[name=gImage]").val();
			var url = "/addCart/"+gCode 
			//console.log("<"+gCode+" "+gName+" "+gPrice+" "+gSize+" "+gColor+" "+gAmount+" "+gImage+">, url:"+url);
			$.ajax({
				url:url,
				type:"post", //get방식으로 주고받으면 400에러. 애초에 url에 파라미터를 붙여서 요청하지 않기 때문.
				dataType:"text",
				headers: { 
					"Content-Type":"application/json"
				},
				data:JSON.stringify(
					{
						gCode:gCode,
						gName:gName,
						gPrice:gPrice,
						gSize:gSize,
						gColor:gColor,
						gAmount:gAmount,
						gImage:gImage
					}
				),
				success : function(data){
					if(data == "ok"){
						alert("장바구니에 상품을 담았습니다.");
					}
				},
				error : function(status, xhr, e){
					console.log("e : "+e);
				}
			});
		}
		
		//주문수량 변경
		$(".amountCtrl .up").on("click", function(){
			var amount = $("input[name=gAmount]").val();
			if(amount >= 10){
				alert("수량은 최대 10개까지 구매 가능합니다.");
			}else{
				amount++;
			}
			$("input[name=gAmount]").val(amount);
		});
		$(".amountCtrl .down").on("click", function(){
			var amount = $("input[name=gAmount]").val();
			if(amount > 1){
				amount--;
			}
			$("input[name=gAmount]").val(amount);
		});
	});
</script>