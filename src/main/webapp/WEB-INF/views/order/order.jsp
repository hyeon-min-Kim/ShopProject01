<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- ${sessionScope.login}<br>
${cartList} --%>

<p><b>주문 상품</b></p>
<form name="orderConfirmForm" id="orderConfirmForm" action="/loginChk/orderComplete" method="post">
<table class="cartListTable">
	<thead>
		<tr>
			<th>번호</th>
			<th colspan="2">상품 정보</th>
			<th>판매가</th>
			<th>수량</th>
			<th>합계</th>
		</tr>
	</thead>
	<tbody>
	<!-- [num=0, userid=eee, gCode=null, gName=null, gPrice=0, gSize=null, gColor=null, gAmount=0, gImage=null, -->
		<c:forEach var="goods" items="${cartList}" varStatus="status">
		<tr>
			<td>
				${goods.num }
				<input type="hidden" name="num" class="num" value="${goods.num }"/>
				<input type="hidden" name="gCode" value="${goods.gCode }"/>
			</td>
			<td colspan="2">
				<div class="gInfo">
					<p class="image">
						<img src="/resources/images/items/${goods.gImage }.gif" />
						<input type="hidden" name="gImage" value="${goods.gImage }"/>
					</p>
					<div class="detail">
						<ul>
							<li class="name">
								${goods.gName }
								<input type="hidden" name="gName" value="${goods.gName }"/>
							</li>
							<li class="option">
								[옵션 : 사이즈(${goods.gSize }), 색상(${goods.gColor })]
								<input type="hidden" name="gSize" value="${goods.gSize }"/>
								<input type="hidden" name="gColor" value="${goods.gColor }"/>
							</li>
						</ul>
					</div>
					
				</div>
			</td>
			<td>
				<p class="price">
					${goods.gPrice }
					<input type="hidden" name="gPrice" value="${goods.gPrice }"/>
				</p>
			</td>
			<td>
				<p class="amount">
					${goods.gAmount }
					<input type="hidden" name="gAmount" value="${goods.gAmount }"/>
				</p>
			</td>
			<td><p class="priceSum">${goods.gPrice * goods.gAmount }</p></td>
		</tr>
		</c:forEach>
		<tr>
			<td colspan="6" style="text-align:right; border-top:1px solid #888">
			상품 합계 : <b class="gFinalPrice"></b>
			</td>
		</tr>
	</tbody>
</table>
<p><b>고객 정보</b></p>
<table>
	<tbody>
		<tr>
			<th>이름</th>
			<td>
				<input type="text" id="username" value="${sessionScope.login.username}" readonly/>
				<input type="hidden" name="userid" value="${sessionScope.login.userid}" />
			</td>
		</tr>
		<tr>
			<th>주소</th>
			<td>
				<input type="text" id="post" value="${sessionScope.login.post}" readonly/>
				<input type="text" id="addr1" value="${sessionScope.login.addr1}" readonly/>
				<input type="text" id="addr2" value="${sessionScope.login.addr2}" readonly/>
			</td>
		</tr>
		<tr>
			<th>휴대전화</th>
			<td>
				<input type="text" id="phone" value="${sessionScope.login.phone1}${sessionScope.login.phone2}${sessionScope.login.phone3}" readonly/>
			</td>
		</tr>
		<tr><td height="30"></td></tr>
	</tbody>
</table>

<p>
	<b style="display:inline-block; margin-right:20px;">배송지 정보</b>
	<input type="checkbox" id="copyInfo" /><label for="copyInfo"> * 고객 정보와 동일 할 경우 선택하세요</label>
</p>
<table class="valiChk">
	<tbody>
		<tr>
			<th>이름</th>
			<td><input type="text" name="orderName" value="" /></td>
		</tr>
		<tr>
			<th>주소</th>
			<td>
				<!-- 다음에서 제공하는 api -->
				<input type="text" name="post" id="sample4_postcode" placeholder="우편번호" /><a href="javascript:" onclick="sample4_execDaumPostcode()">우편번호 찾기</a><br>
				<input type="text" name="addr1" id="sample4_roadAddress" placeholder="도로명주소"/>
				<input type="text" name="addr2" id="sample4_jibunAddress" placeholder="지번주소" />
				<span id="guide" style="color:#999"></span>
				<!-- //다음에서 제공하는 api -->
			</td>
		</tr>
		<tr>
			<th>휴대전화</th>
			<td><input type="text" name="phone" value="" /></td>
		</tr>
		<tr><td height="30"></td></tr>
	</tbody>
</table>

<p><b>결제 수단</b></p>
<table>
	<tbody>
		<tr>
			<td>
				<input type="radio" id="credit" name="payMethod" value="credit" checked />
				<label for="credit">신용카드</label>
				
				<input type="radio" id="account" name="payMethod" value="bankTransfer" />
				<label for="account">계좌이체</label>
				
				<input type="radio" id="deposit" name="payMethod" value="deposit" />
				<label for="deposit">무통장 입금</label>
			</td>
		</tr>
	</tbody>
</table>
</form>
<div class="btns" style="text-align:center; margin-top:40px">
	<a href="javascript:" class="orderConfirm">결제하기</a>
	<!-- document.querySelector('[name="first_name"]') -->
</div>
<script>
	$(function(){
		//배송지가 동일한 경우
		$("#copyInfo").on("click", function(){
			if($(this).is(":checked")){
				var username = $("#username").val();
				var post = $("#post").val();
				var addr1 = $("#addr1").val();
				var addr2 = $("#addr2").val();
				var phone = $("#phone").val();
				
				$("input[name=orderName]").val(username);
				$("#sample4_postcode").val(post);
				$("#sample4_roadAddress").val(addr1);
				$("#sample4_jibunAddress").val(addr2);
				$("input[name=phone]").val(phone);
			}
		});
		
		//결제전 입력 필드 유효성 체크
		$(".orderConfirm").on("click", function(){
			var count = 0;
			$(".valiChk td input").each(function(){
				if($(this).val() == ""){
					alert("배송지 정보를 정확히 입력 해 주세요");
					return false;
				}else{
					count++;	
				}
			});
			if(count == $(".valiChk td input").length){
				console.log("서브밋");
				$("#orderConfirmForm").submit();
			}
		});
	});
</script>

<!-- ============================================================================================= -->
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script><!-- 다음에서 제공하는 api -->
<!-- 다음에서 제공하는 api -->
<script>
    //본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
    function sample4_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 도로명 조합형 주소 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }
                // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
                if(fullRoadAddr !== ''){
                    fullRoadAddr += extraRoadAddr;
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('sample4_postcode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('sample4_roadAddress').value = fullRoadAddr;
                document.getElementById('sample4_jibunAddress').value = data.jibunAddress;

                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                if(data.autoRoadAddress) {
                    //예상되는 도로명 주소에 조합형 주소를 추가한다.
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';

                } else if(data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';

                } else {
                    document.getElementById('guide').innerHTML = '';
                }
            }
        }).open();
    }
</script>
<!-- //다음에서 제공하는 api -->