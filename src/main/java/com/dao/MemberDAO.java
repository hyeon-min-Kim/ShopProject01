package com.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dto.MemberDTO;

@Repository
public class MemberDAO {
	@Autowired
	SqlSessionTemplate session;

	public List<MemberDTO> memberList() {
		return session.selectList("MemberMapper.memberList");
	}

	public int idDupliChk(String id) {
		return session.selectOne("MemberMapper.idDupliChk", id);
	}

	public int memberAdd(MemberDTO member) {
		return session.insert("MemberMapper.memberAdd", member);
	}

	public MemberDTO login(Map<String, String> map) {
		return session.selectOne("MemberMapper.login", map);
	}

	public int passwdChk(Map<String, String> map) {
		return session.selectOne("MemberMapper.passwdChk", map);
	}

	public void memberUpdate(MemberDTO member) {
		session.update("MemberMapper.memberUpdate", member);
	}

	public MemberDTO getMember(String userid) {
		return session.selectOne("MemberMapper.getMember", userid);
	}

	
	
	
}
