package com.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dao.MemberDAO;
import com.dto.MemberDTO;

@Service
public class MemberService {
	@Autowired
	MemberDAO dao;
	
	public List<MemberDTO> memberList() {
		return dao.memberList();
	}

	public int idDupliChk(String id) {
		return dao.idDupliChk(id);
	}

	public int memberAdd(MemberDTO member) {
		return dao.memberAdd(member);
	}

	public MemberDTO login(Map<String, String> map) {
		return dao.login(map);
	}

	public int passwdChk(Map<String, String> map) {
		return dao.passwdChk(map);
	}


	public void memberUpdate(MemberDTO member) {
		dao.memberUpdate(member);
	}

	public MemberDTO getMember(String userid) {
		return dao.getMember(userid);
	}
	
}
