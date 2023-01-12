package com.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.dto.GoodsDTO;
import com.service.GoodsService;

@Controller
public class MainController {
	@Autowired
	GoodsService service;
	
	@RequestMapping(value="/", method = RequestMethod.GET)
	public String main(Model m) {
		//System.out.println("메인 진입");
		List<GoodsDTO> list = service.getGoodsList("top");//최초 top카테고리 리스트 가져옴.
		m.addAttribute("goodsList", list);
		return "main"; /* src > main > webapp > WEB-INF > views > main.jsp 뷰페이지로 이동. */
	}
}
