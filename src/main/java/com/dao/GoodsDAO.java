package com.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dto.GoodsDTO;

@Repository
public class GoodsDAO {
	@Autowired
	SqlSessionTemplate session;

	public List<GoodsDTO> getGoodsList(String cate) {
		return session.selectList("GoodsMapper.getGoodsList", cate);
	}

	public GoodsDTO getGoodsDetail(String gCode) {
		return session.selectOne("GoodsMapper.getGoodsDetail", gCode);
	}
}
