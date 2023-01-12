package com.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dto.CartDTO;
import com.dto.MemberDTO;
import com.dto.OrderDTO;
import com.service.CartService;
import com.service.OrderService;

@Controller
public class OrderController {
	@Autowired
	OrderService service; 
	
	@Autowired
	CartService cartService; //주문과 장바구니 컨트롤러를 따로 분리했지만, 장바구니관련 기능이 많이 겹쳐 CartService도 주입받음..
	
	//바로구매
	@RequestMapping(value="/loginChk/buyNow/{gCode}")
	public String buyNow(CartDTO cart, HttpSession session, Model m) {
		MemberDTO member = (MemberDTO)session.getAttribute("login");
		cart.setUserid(member.getUserid());
		System.out.println("cart : "+cart);
		//장바구니에 담지 않고 주문으로 바로넘어감.
		ArrayList<CartDTO> list = new ArrayList<CartDTO>(); 
		list.add(cart);
		m.addAttribute("cartList", list);
		return "viewer/orderView";
	}
	
	//장바구니 선택 상품 주문(회원)
	@RequestMapping(value="/order", method=RequestMethod.POST)
	public String orderChk(@RequestParam("check") List<Integer> nums, Model m) {
		System.out.println(nums);
		List<CartDTO> list = service.getCartList(nums); 
		//ㄴ ArrayList<CartDTO> list = (ArrayList<CartDTO>)service.getCartList(nums); 
		m.addAttribute("cartList", list);
		return "viewer/orderView";
	}
	
	//주문완료(결제하기)
	@RequestMapping(value="/loginChk/orderComplete", method=RequestMethod.POST)
	public String ordercomplete(OrderDTO order, @RequestParam("num") List<Integer> nums, HttpSession session, Model m) {
		System.out.println("nums == "+nums);
		System.out.println("order info == "+order);
		ArrayList<OrderDTO> oList = new ArrayList<>();
		for (Integer integer : nums) {
			int num = integer;
			OrderDTO orderGoods = new OrderDTO();
			CartDTO cartGoods = service.getCart(num); //카트에서 주문한 상품 정보
			
			if(cartGoods == null) { //바로구매로, 장바구니 담지않고 바로 주문결제하는 경우
				orderGoods = order;
				//System.out.println("바로구매할 상품 정보 : "+orderGoods);
			}else { //장바구니에 담긴 상품 주문결제 하는 경우
				orderGoods.setNum(cartGoods.getNum());
				orderGoods.setUserid(order.getUserid());
				orderGoods.setgCode(cartGoods.getgCode());
				orderGoods.setgName(cartGoods.getgName());
				orderGoods.setgPrice(cartGoods.getgPrice());
				orderGoods.setgSize(cartGoods.getgSize());
				orderGoods.setgColor(cartGoods.getgColor());
				orderGoods.setgAmount(cartGoods.getgAmount());
				orderGoods.setgImage(cartGoods.getgImage());
				orderGoods.setOrderName(order.getOrderName());
				orderGoods.setPost(order.getPost());
				orderGoods.setAddr1(order.getAddr1());
				orderGoods.setAddr2(order.getAddr2());
				orderGoods.setPhone(order.getPhone());
				orderGoods.setPayMethod(order.getPayMethod());
				
				//주문한 상품을 cart테이블에서 delete.
				cartService.cartDelete(num);
			}
			
			//주문한 상품정보(OrderDTO order)를 orderInfo테이블에 insert.
			service.addOrder(orderGoods);
			//ArrayList에 add(주문완료 화면에 전달하기 위해)
			oList.add(orderGoods);
		}
		for (OrderDTO o : oList) {
			System.out.println("주문상품 보기 : "+o);
			//oList가 모두 맨 마지막에 add된 상품으로 덮어씌워져있음.
			//=>[참고] https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=kuma119&logNo=20134894394
		}
		//주문한 상품을  view페이지에 전달.
		m.addAttribute("orderList", oList);
		return "viewer/orderCompleteView";
	}
	
	//주문 조회
	@RequestMapping(value="/loginChk/orderInquire", method = RequestMethod.GET)
	public String orderInquire(HttpSession session, Model m) {
		MemberDTO member  = (MemberDTO)session.getAttribute("login");
		//해당 userid를 가지고있는 레코드를 불러와서 list에 담은 뒤, 뷰페이지에 전달.
		List<OrderDTO> oList = service.getOrderByUserid(member.getUserid());
		for (OrderDTO orderDTO : oList) {
			System.out.println(orderDTO);
		}
		m.addAttribute("orderList", oList);
		return "viewer/orderInquireView";
	}
}
