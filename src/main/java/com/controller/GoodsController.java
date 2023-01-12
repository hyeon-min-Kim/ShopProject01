package com.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.dto.GoodsDTO;
import com.service.GoodsService;

@Controller
public class GoodsController {
	@Autowired
	GoodsService service;
	
	//카테고리별 상품 노출
	@RequestMapping(value="/categories/{category}")
	public String menu(@PathVariable("category") String cate, Model m) {
		List<GoodsDTO> list = service.getGoodsList(cate);
		m.addAttribute("goodsList", list);
		return "main";
	}
	
	//상품 상세보기
	@RequestMapping(value="/details/{gCode}")
	public String details(@PathVariable("gCode") String gCode, Model m) {
		GoodsDTO dto  = service.getGoodsDetail(gCode);
		//System.out.println(dto);
		m.addAttribute("goodsDetail", dto);
		return "viewer/goodsDetailView";
	}
}
