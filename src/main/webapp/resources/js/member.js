$(function(){
	//console.log(123);
	//다시작성 버튼 클릭 시 input필드 리셋
	$("#resetBtn").on("click", function(){
		$("#joinForm table input").val("");
		$("#userid").next(".noti").text("");
		$("#userid").attr("data-vali", "");
		$("#userid").next(".noti").removeClass("blu");
		$("#passwdcfm").next(".noti").text("");
		$("#passwdcfm").next(".noti").removeClass("blu");
	});

	//이메일 selectbox로 선택 시.
	$("#email2Val").on("change", function(){
		// select box ID로 접근하여 선택된 값 읽기
		//$("#셀렉트박스ID option:selected").val();
		// select box Name로 접근하여 선택된 값 읽기
		//$("select[name=셀렉트박스name]").val();
		var email2Val = $("#email2Val option:selected").val();
		$("#email2").val(email2Val);
	});
});


