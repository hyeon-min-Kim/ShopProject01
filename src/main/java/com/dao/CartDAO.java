package com.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dto.CartDTO;

@Repository
public class CartDAO {
	@Autowired
	SqlSessionTemplate session;

	public void addCart(CartDTO cart) {
		session.insert("CartMapper.addCart", cart);
	}

	public List<CartDAO> cartList(String userid) {
		return session.selectList("CartMapper.cartList", userid);
	}

	public void cartUpdate(Map<String, Integer> map) {
		session.update("CartMapper.cartUpdate", map);
	}

	public void cartDelete(int num) {
		session.delete("CartMapper.cartDelete", num);
	}

	public void cartDeleteChk(ArrayList<Integer> nums) {
		session.delete("CartMapper.cartDeleteChk", nums);
	}

	public CartDTO sameChk(CartDTO cart) {
		CartDTO c = null;
		try {
			c = session.selectOne("CartMapper.sameChk", cart);
		} catch (Exception e) {
			System.out.println("일치하는 상품 없음.");
			c = null;
		}
		return c;
	}


	

//	public void addCarts(ArrayList<CartDTO> list) {
//		session.insert("CartMapper.addCarts", list);
//	}
}
