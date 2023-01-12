package com.dao;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dto.CartDTO;
import com.dto.OrderDTO;

@Repository
public class OrderDAO {
	@Autowired
	SqlSessionTemplate session;

	public CartDTO getCart(int num) {
		return session.selectOne("CartMapper.cartByNum", num);
	}

	public List<CartDTO> getCartList(List<Integer> nums) {
		return session.selectList("CartMapper.cartListByNum", nums);
	}

	public void addOrder(OrderDTO order) {
		session.insert("OrderMapper.addOrder", order);
	}

	public List<OrderDTO> getOrderByUserid(String userid) {
		return session.selectList("OrderMapper.getOrderByUserid", userid);
	}

}
