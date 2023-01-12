package com.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dao.GoodsDAO;
import com.dto.GoodsDTO;

@Service
public class GoodsService {
	@Autowired
	GoodsDAO dao;

	public List<GoodsDTO> getGoodsList(String cate) {
		return dao.getGoodsList(cate);
	}

	public GoodsDTO getGoodsDetail(String gCode) {
		return dao.getGoodsDetail(gCode);
	}
}
