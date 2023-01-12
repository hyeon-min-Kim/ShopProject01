package com.controller;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dto.CartDTO;
import com.dto.MemberDTO;
import com.service.MemberService;

@Controller
public class MemberController {
	@Autowired
	MemberService service;
	
	//로그인Form가기
	@RequestMapping(value="/loginForm", method = RequestMethod.GET)
	public String loginForm() {
		return "viewer/loginFormView";
	}
	
	//회원가입 Form가기
	@RequestMapping(value="/joinForm", method = RequestMethod.GET)
	public String joinForm() {
		return "viewer/joinFormView";
	}
	
	//아이디 중복 체크
	@ResponseBody
	@RequestMapping(value="/IdDupliCheck", method = RequestMethod.GET)
	public String IdDupliCheck(@RequestParam("idValue") String id) {
		int count;
		String yn;
		count = service.idDupliChk(id);
		if(count != 0) {
			yn = "n"; 
		}else {
			yn = "y";
		}
		return yn;
	}
	
	//회원가입 하기.
	@RequestMapping(value="/join", method = RequestMethod.POST)
	public String join(MemberDTO member, RedirectAttributes rttr) {
		System.out.println(member);
		int num = service.memberAdd(member);
		System.out.println("num : "+num);
		if(num != 0) {
			rttr.addFlashAttribute("mesg", "회원가입이 완료되었습니다.");
		}
		return "redirect:/loginForm";
	}
	
	//로그인하기.
	@RequestMapping(value="/login", method = RequestMethod.POST)
	public String login(@RequestParam Map<String, String> map, Model m, HttpSession session, HttpServletRequest request) throws URISyntaxException {
		MemberDTO member = service.login(map);
		String nextPage = "";
		//System.out.println("member : "+member);
		//String referer = request.getHeader("Referer") //http://localhost:8081/loginChk/mypage 
		String refererURI = new URI(request.getHeader("Referer")).getPath();
		System.out.println("login prevPage : "+refererURI);
		
		
		if(member != null) {
			System.out.println("회원정보 있음");
			session.setAttribute("login", member); //이렇게도 작성 가능 -> request.getSession().setAttribute("login", member);
			
			if(refererURI.contains("/loginForm")){//로그인 페이지 사용자가 스스로 들어와서 로그인-> 메인으로 이동.
				nextPage = "redirect:/";
			}else if(refererURI.contains("/loginChk/mypage")){ //이전 페이지인 마이페이지로 이동.
				nextPage = "redirect:/loginChk/mypage"; 
			}else if(refererURI.contains("/cartList")){ //장바구니에서 인터셉터 타고 들어옴. -> 장바구니로 이동
				ArrayList<CartDTO> list =(ArrayList<CartDTO>)session.getAttribute("tempCartList"); 
				nextPage = "redirect:/cartList"; 
			}else if(refererURI.contains("/loginChk/buyNow/")){ //제품 상세 페이지에서 들어옴 -> 제품상세 페이지로 이동.
				String gCode = refererURI.substring(17);
				nextPage = "redirect:/details/"+gCode; 
			}else if(refererURI.contains("/loginChk/preOrder")){ //개별상품 주문에서 들어옴. -> DB장바구니 추가 후 장바구니 페이지 이동.
				System.out.println("로그인시키고, 세션의 장바구니를 DB장바구니로 담으러 이동.");
				nextPage = "redirect:/addCarts"; 
			}else {
				//nextPage = "redirect:"+refererURI;
				nextPage = "redirect:/";
			}
			
			
		}else {
			System.out.println("회원정보 없음");
			m.addAttribute("mesg", "일치하는 회원 정보가 없습니다.");
			nextPage = "viewer/loginFormView";
		}
		return nextPage;
	}
	
	//로그아웃 하기.
	@RequestMapping(value="/loginChk/logout", method = RequestMethod.GET)
	public String logout(HttpSession session) {
		session.invalidate();
		//return "main"; 이렇게 넣으면 http://localhost:8081/company/loginChk/logout이 경로로 감.
		return "redirect:/";
	}
	
	//마이페이지 가기 - get
	@RequestMapping(value="/loginChk/mypage", method = RequestMethod.GET)
	public String mypage(HttpSession session) {
		//세션의 userid를 가져와서 해당 userid와 일치하는 회원정보를 DB에서 다시 조회 후 view페이지 넘김.
		MemberDTO sessionMember = (MemberDTO)session.getAttribute("login");
		MemberDTO member = service.getMember(sessionMember.getUserid());
		session.setAttribute("login", member);
		System.out.println("/loginChk/mypage 마이페이지 불러오기. get");
		return "viewer/mypageView";
	}
	
	//회원정보 수정 전 패스워드 체크
	@ResponseBody
	@RequestMapping(value="/loginChk/passwdChk", method = RequestMethod.POST)
	public String passwdChk(@RequestParam Map<String, String> map) {
		//System.out.println("map : "+map);
		int num = service.passwdChk(map);
		//System.out.println(num);
		if(num != 0) { //아이디, 비밀번호 일치
			return "y";
		}else { //아이디, 비밀번호 불일치
			return "n";
		}
	}
	
	//회원정보 수정
	@RequestMapping(value="/loginChk/memberUpdate", method=RequestMethod.POST)
	public String memberUpdate(MemberDTO member, RedirectAttributes rttr) {
		System.out.println("/loginChk/memberUpdate 회원정보 수정");
		service.memberUpdate(member);
		
		//request.setAttribute("mesg", "수정이 완료되었습니다.");
		//return "forward:/loginChk/mypage"; //HttpServletRequest, forward로 보내면 "/loginChk/memberUpdate" uri가 남아있음.
		
		rttr.addFlashAttribute("mesg", "수정이 완료되었습니다.");
		//ㄴ RedirectAttributes사용 시 session에 일회성으로 저장하기 때문에 redirect시에도 다음 메소드까지 값이 유지되어 view페이지까지 전달된다
		
		return "redirect:/loginChk/mypage"; 
		//ㄴ WARN : org.springframework.web.servlet.PageNotFound - Request method 'GET' not supported
		//ㄴ loginChk/memberUpdate까지 오는게 Post고 /loginChk/mypage로 가는건 데이터 조회기 때문에 Get으로 간다. 
	}
}
