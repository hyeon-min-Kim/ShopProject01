//상품 총 합계
function finalPrice(){
	var cartFinalPrice = 0;
	$(".cartListTable tbody tr").each(function(){
		if($(this).find(".priceSum").length != 0){
			cartFinalPrice += parseInt($(this).find(".priceSum").text()); 
		}
	});
	$(".gFinalPrice").text(cartFinalPrice);
}

$(function(){
	//상품 총 합계
	finalPrice();
	
	//전체선택
	$("#chkAll").on("click", function(){ //
		var result = this.checked;
		$(".cartListTable .check").each(function(){
			this.checked=result;
		});
		
	});
	
	//개별 체크박스 선택
	$(".check").on("click", function(){
		var chkedLength = $(".check:checked").length;
		if($(".cartListTable .check").length == chkedLength){
			$(".cartListTable #chkAll").prop("checked",true);
		}else{
			$(".cartListTable #chkAll").prop("checked",false);
		}
	});
});


