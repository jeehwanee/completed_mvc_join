package com.vampa.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.vampa.mapper.MemberMapper;
import com.vampa.model.MemberVO;

@Service
public class MemberServicelmpl implements MemberService {
	
	@Autowired
	MemberMapper membermapper; //insert
	
	/*
	 * 회원가입 기능 구현
	 */
	@Override
	public void memberJoin(MemberVO member) throws Exception { // MemberService 인터페이스를 상속받기 때문에 사용 가능
		membermapper.memberJoin(member); //Mapper의 memberJoin 수행
	}
	
	/*
	 * 아이디 중복성 검사
	 */
	@Override
	public int idCheck(String memberId) throws Exception {
		return membermapper.idCheck(memberId); //Mapper의 idCheck 수행
	}
}
