<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<form method="post" id="joinForm">
<table class="type01">
	<tbody>
		<tr>
			<th>아이디</th>
			<td>
				<input type="text" name="userid" id="userid" data-vali="" />
				<span class="noti red"></span>
			</td>
		</tr>
		<tr>
			<th>비밀번호</th>
			<td><input type="password" name="passwd" id="passwd" /><i class="fas fa-eye" style="display:inline-block;"></i></td>
		</tr>
		<tr>
			<th>비밀번호 확인</th>
			<td><input type="password" name="passwdcfm" id="passwdcfm" data-vali="" /><span class="noti red"><span></td>
		</tr>
		<tr>
			<th>이름</th>
			<td><input type="text" name="username" /></td>
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
			<th>전화번호</th>
			<td>
				<select name="phone1">
					<option value="010" selected>010</option>
					<option value="011">011</option>
					<option value="019">019</option>
				</select>-
				<input type="text" name="phone2" />-
				<input type="text" name="phone3" /></td>
		</tr>
		<tr>
			<th>이메일</th>
			<td>
				<input type="text" name="email1" id="email1" />@
				<input type="text" name="email2" id="email2" />
				<select name="email2Val" id="email2Val">
					<option value="">직접 입력</option>
					<option value="naver.com">naver.com</option>
					<option value="hanmail.net">hanmail.net</option>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="2" style="text-align:center">
				<a href="javascript:" id="joinBtn">회원가입</a>
				<a href="javascript:" id="resetBtn">다시작성</a>
			</td>
		</tr>
	</tbody>
</table>
</form>
<script>
	$(function(){
		//아이디 중복체크
		$("#userid").on("keyup", useridDupli);
		function useridDupli(){
			var idValue = $("#userid").val();
			if(idValue.length > 0){
				$.ajax({
					url:"<%=request.getContextPath()%>/IdDupliCheck",
					type:"get",
					dataType:"text",
					data:{
						idValue:idValue
					},
					success : function(data){
						if(data == "y"){ //사용가능
							$("#userid").next(".noti").addClass("blu");
							$("#userid").attr("data-vali", "ok");
							$("#userid").next(".noti").text("사용 가능한 아이디입니다.");
						}else{ //사용 불가능
							$("#userid").next(".noti").removeClass("blu");
							$("#userid").attr("data-vali", "");
							$("#userid").next(".noti").text("이미 사용중인 아이디입니다.");
						}
					},
					error : function(status, xhr, e){
						console.log("e : "+e);
					}
				});	
			}else{
				$("#userid").next(".noti").removeClass("blu");
				$("#userid").attr("data-vali", "");
				$("#userid").next(".noti").text("");
			}
			
		}
		
		//회원가입 유효성체크
		$("#joinBtn").on("click", joinValidate);
		function joinValidate(){
			var count = 0;
			$("tbody input").each(function(index){
				//console.log($(this).val());
				if($(this).val() == ""){
					console.log("빈칸");
					alert($(this).parents("tr").find("th").text()+"을(를) 확인 해 주세요");
					return false;
				}else if($(this).is("[data-vali]")){
					console.log("빈칸아님, 유효성 필요");
					if($(this).data("vali") != "ok"){
						console.log("data : "+$(this).data("vali"));
						alert($(this).parents("tr").find("th").text()+"을(를) 확인 해 주세요");
						return false;
					}
				}
				count++;
			});
			if(count == $("tbody input").length){
				$("#joinForm").attr("action","join").submit();
				//document.querySelector("#joinForm").action="join";
				//document.querySelector("#joinForm").submit();
			}
		}
		
		//비밀번호 확인. 키 이벤트 발생시 패스워드 일치여부 검사
		$("#passwdcfm").on("keyup", passwdCfm);
		function passwdCfm(){
			console.log(121);
			var pswd = $("#passwd").val();
			var pswdcfm = $("#passwdcfm").val();
			if(pswdcfm.length > 0){
				if(pswdcfm == pswd){
					$("#passwdcfm").next(".noti").text("비밀번호가 일치합니다.");
					$("#passwdcfm").next(".noti").addClass("blu");
					$("#passwdcfm").attr("data-vali", "ok");
				}else{
					$("#passwdcfm").next(".noti").text("비밀번호가 일치하지 않습니다.");
					$("#passwdcfm").next(".noti").removeClass("blu");
					$("#passwdcfm").attr("data-vali", "");
				}	
			}else{
				$("#passwdcfm").next(".noti").text("");
				$("#passwdcfm").next(".noti").removeClass("blu");
				$("#passwdcfm").attr("data-vali", "");
			}
		}
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