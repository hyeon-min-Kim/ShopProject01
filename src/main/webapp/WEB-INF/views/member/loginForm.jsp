<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<form action="/login" method="post" name="loginForm" id="loginForm">
	<!-- <input type="hidden" name="prevPage" value="" /> -->
	<div class="loginDiv">
		<dl>
			<dt>아이디</dt>
			<dd><input type="text" name="userid" id="userid" /></dd>
			<dt>패스워드</dt>
			<dd><input type="text" name="passwd" id="passwd" /></dd>
		</dl>
		<a href="javascript:" id="loginBtn" class="btn">로그인</a>
	</div>
	
</form>
<script>
	$(function(){
		//로그인 유효성 체크
		$("#loginBtn").on("click", loginValidate);
		function loginValidate(){
			console.log("loginBtn 클릭");
			if($("input[name=userid]").val() == "" || $("input[name=passwd]").val() == ""){
				alert("아이디, 패스워드를 모두 입력 해 주세요");
				return false;
			}
			console.log("로그인폼 서브밋");
			$("#loginForm").submit();
		}
	});
</script>


<!-- 아이디 찾기 관련. 
1. loginForm.jsp에 아이디 찾기 버튼 추가. servlet을 통해 아이디 찾기 페이지로 이동.
2. idSearch.jsp에서 이름, 휴대폰, 이메일 정보 받음. 메일 보내기 버튼 추가.
3. 해당 정보와 일치하는 userid받아옴.
4-1. 일치하는 userid없을 경우, 다시 메일찾기 페이지 이동. 등록된 회원정보가 없습니다 얼럿.
4-2. 일치하는 userid있을 경우, userid,  메일주소 가지고 SendMailServlet이동.(userid를 메일로 보내기) -->
