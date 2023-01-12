package com.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dao.CartDAO;
import com.dto.CartDTO;
import com.dto.MemberDTO;
import com.service.CartService;

@Controller
public class CartController {
	
	@Autowired
	CartService service;
	
	
	//장바구니 담기(하나씩) 
	@ResponseBody //.jsp말고 객체 반환(문자열)
	@RequestMapping(value="/addCart/{gCode}", method = RequestMethod.POST) //ajax로 처리. 로그인체크 안함.
	public String addCart(@PathVariable("gCode") String gCode, @RequestBody CartDTO cart, HttpSession session) {
		MemberDTO member = (MemberDTO)session.getAttribute("login");
		//System.out.println("member == "+member);
		if(member != null) {
			cart.setUserid(member.getUserid());
			//System.out.println("cart == "+cart);
			
			//cart테이블에 insert하기 전에, 동일한 옵션의 상품이 DB에 있나 확인후, 없으면 insert, 있으면 갯수만 늘리기.
			//상품의 num값, gAmount값 리턴받기.
			CartDTO c = service.sameChk(cart);
			//System.out.println("장바구니에 추가한 상품과 동일한 상품 == "+c);
			if(c == null) { //동일한 옵션의 상품 없음.
				service.addCart(cart);
			}else { //동일한 옵션의 상품 있음. 갯수만 변경.
				Map<String, Integer> map = new HashMap<>();
				map.put("num", c.getNum());
				map.put("gAmount", cart.getgAmount()+c.getgAmount());
				//System.out.println("mapmap"+map);
				service.cartUpdate(map);
			}
		}else {
			cart.setUserid("tempID");
			//System.out.println("cart == "+cart);
			//세션ArrayList<CartDTO>에 추가. [참고]https://coding-factory.tistory.com/14
			ArrayList<CartDTO> list = (ArrayList<CartDTO>)session.getAttribute("tempCartList");
			System.out.println("-----cart-----");
			if(list == null) {
				System.out.println("tempCartList 비어있음.");
				list = new ArrayList<CartDTO>();
				session.setAttribute("tempCartList", list);
			}
			if(list.size() == 0) {
				list.add(cart);
			}else {
				//tempCartList에 add하기 전에, 동일한 옵션의 상품이 있나 확인후, 없으면 insert, 있으면 갯수만 늘리기.
				//list의 CartDTO객체의 gCode, gSize, gColor비교후 같은지 다른지 리턴.
				boolean isSame = false;
				int count = 0;
				for (CartDTO sessionCart : list) {
					String code = sessionCart.getgCode();
					String size = sessionCart.getgSize();
					String color = sessionCart.getgColor();
					int amount = sessionCart.getgAmount();
					if(cart.getgCode().equals(code) && cart.getgSize().equals(size) && cart.getgColor().equals(color)) {
						System.out.println("동일상품 있음.----"+count+"번째 index,"+code+","+size+","+color);
						isSame = true;
						list.get(count).setgAmount(amount+cart.getgAmount());
						break;
					}else {
						System.out.println("동일상품 없음.");
					}
					count++;
				}
				if(isSame == false) {
					System.out.println("새 상품 장바구니 추가.");
					list.add(cart);
				}
			}
			//확인
			for (CartDTO cartDTO : list) {
				System.out.println("tempCartList :"+ cartDTO);
			}
			System.out.println("-----끝-----");
		}
		
		return "ok"; 
			
	}
	
	//세션 상품 장바구니 담기(여러개씩. 비회원이 장바구니에 상품 담은 후 주문시, 세션 장바구니에 있던 상품들을 DB에 담기)
	//로그인체크 후 /addCarts로 들어오면, 세션장바구니 상품들을 DB장바구니로 넣고 장바구니페이지 이동.
	@RequestMapping(value="/addCarts", method = RequestMethod.GET)
	public String preOrder(HttpSession session) {
		MemberDTO member = (MemberDTO) session.getAttribute("login");
		ArrayList<CartDTO> list = (ArrayList<CartDTO>)session.getAttribute("tempCartList");
		//System.out.println("로그인 후 DB장바구니에 넣을 상품."+list);
		//service.addCarts(list); //한꺼번에 넣으면. 시퀀스인 num값이 동일한 값으로 들어가서 primary key값이 겹쳐짐. cartDTO객체 하나씩 DB에 접근하여 cart테이블에 insert.
		
		//똑같은 옵션의 상품이 이미 장바구니에 있을 시 갯수만 변경.
		for (CartDTO cartDTO : list) {
			cartDTO.setUserid(member.getUserid());
			CartDTO c = service.sameChk(cartDTO);
			//System.out.println("장바구니에 추가한 상품과 동일한 상품 == "+c);
			if(c == null) { //동일한 옵션의 상품 없음.
				service.addCart(cartDTO);
			}else { //동일한 옵션의 상품 있음. 갯수만 변경.
				Map<String, Integer> map = new HashMap<>();
				map.put("num", c.getNum());
				map.put("gAmount", cartDTO.getgAmount()+c.getgAmount());
				//System.out.println("mapmap"+map);
				service.cartUpdate(map);
			}
		}
		System.out.println("세션장바구니를 DB에 담기 성공.");
		return "redirect:/cartList";
	}
	
	//카트 리스트 보기.
	@RequestMapping(value="/cartList", method = RequestMethod.GET)
	public String cartList(HttpSession session, Model m) {
		MemberDTO member = (MemberDTO)session.getAttribute("login");
		if(member != null) {
			String userid = member.getUserid();
			List<CartDAO> list = service.cartList(userid);
			//System.out.println(list);
			m.addAttribute("cartList", list);
		}
		return "viewer/cartListView";
	}
	
	//상품 수량 변경(회원)
	@ResponseBody
	@RequestMapping(value="/cartUpdate", method=RequestMethod.POST)
	public String cartUpdate(@RequestParam Map<String, Integer> map) {
		//System.out.println("map == "+map);
		service.cartUpdate(map);
		return "ok";
	}
	
	//상품 수량 변경(비회원)
	@ResponseBody
	@RequestMapping(value="/cartUpdateTemp", method=RequestMethod.POST)
	public String cartUpdateTemp(@RequestParam("num") int num, @RequestParam("gAmount") int gAmount, HttpSession session) {
		ArrayList<CartDTO> list = (ArrayList<CartDTO>)session.getAttribute("tempCartList");
		//System.out.println(num+", "+gAmount);
		list.get(num).setgAmount(gAmount);
		//System.out.println(list.get(num));
		CartDTO dto = list.get(num);
		list.set(num, dto);
		return "ok";
	}
	
	//개별 상품 삭제(회원)
	@RequestMapping(value="/cartDelete")
	public String cartDelete(@RequestParam("check") int num, RedirectAttributes rttr) {
		System.out.println("삭제할 넘버:"+num);
		service.cartDelete(num);
		rttr.addFlashAttribute("mesg", "삭제가 완료되었습니다.");
		return "redirect:/cartList";
	}
	
	//선택 상품 삭제(회원)
	@RequestMapping(value="/cartDeleteChk")
	public String cartDeleteChk(@RequestParam("check") ArrayList<Integer> nums, RedirectAttributes rttr) {
		//System.out.println("삭제할 넘버:"+nums);
		service.cartDeleteChk(nums);
		rttr.addFlashAttribute("mesg", "삭제가 완료되었습니다.");
		return "redirect:/cartList";
	}
		
	//개별 상품 삭제(비회원)
	@RequestMapping(value="cartDeleteTemp")
	public String cartDeleteTemp(@RequestParam("check") int index, HttpSession session, RedirectAttributes rttr) {
		System.out.println("삭제할 넘버"+index);
		ArrayList<CartDTO> list = (ArrayList<CartDTO>)session.getAttribute("tempCartList");
		if(list != null) {
			list.remove(index);
			rttr.addFlashAttribute("mesg", "삭제가 완료되었습니다.");
		}else {
			rttr.addFlashAttribute("mesg", "장바구니에 담긴 상품이 없습니다.");
		}
		
		return "redirect:/cartList";
	}
	
	//선택 상품 삭제(비회원)
	@RequestMapping(value="/cartDeleteChkTemp")
	public String cartDeleteChkTemp(@RequestParam("check") ArrayList<Integer> index, HttpSession session, RedirectAttributes rttr) {
		ArrayList<CartDTO> list = (ArrayList<CartDTO>)session.getAttribute("tempCartList");
		if(list != null) {
			System.out.println("삭제할 상품 갯수 : "+index.size());
			for (int i = index.size()-1; i >= 0; i--) {//삭제할 상품 갯수만큼 for문 실행. IndexOutOfBoundsException대응 위해 높은 인덱스부터 삭제.
				System.out.println("삭제할 num : "+index.get(i)); //index배열의 맨 뒷방에 있는 값부터 삭제진행.
				int delNum = index.get(i); //삭제할 인덱스를 Integer -> int로 바꿔준 후 .remove()해줘야한다.
				list.remove(delNum);
			}
			rttr.addFlashAttribute("mesg", "삭제가 완료되었습니다.");
		}else {
			rttr.addFlashAttribute("mesg", "장바구니에 담긴 상품이 없습니다.");
		}
		
		return "redirect:/cartList";
	}
}
