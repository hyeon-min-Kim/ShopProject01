package com.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dao.CartDAO;
import com.dto.CartDTO;

@Service
public class CartService {
	@Autowired
	CartDAO dao;

	public void addCart(CartDTO cart) {
		dao.addCart(cart);
	}

	public List<CartDAO> cartList(String userid) {
		return dao.cartList(userid);
	}

	public void cartUpdate(Map<String, Integer> map) {
		dao.cartUpdate(map);
		
	}

	public void cartDelete(int num) {
		dao.cartDelete(num);
	}

	public void cartDeleteChk(ArrayList<Integer> nums) {
		dao.cartDeleteChk(nums);
	}

	public CartDTO sameChk(CartDTO cart) {
		return dao.sameChk(cart);
	}


	

//	public void addCarts(ArrayList<CartDTO> list) {
//		dao.addCarts(list);
//	}

}
