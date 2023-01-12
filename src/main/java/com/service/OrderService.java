package com.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dao.OrderDAO;
import com.dto.CartDTO;
import com.dto.OrderDTO;

@Service
public class OrderService {
	@Autowired
	OrderDAO dao;

	public CartDTO getCart(int num) {
		return dao.getCart(num);
	}

	public List<CartDTO> getCartList(List<Integer> nums) {
		return dao.getCartList(nums);
	}

	public void addOrder(OrderDTO order) {
		dao.addOrder(order);
	}

	public List<OrderDTO> getOrderByUserid(String userid) {
		return dao.getOrderByUserid(userid);
	}

	
}
