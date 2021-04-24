package com.vampa.model;

import lombok.Data;

@Data //Getter, Setter
public class MemberVO {
	
	//회원 id
	private String memberId;
	
	//회원 pw
	private String memberPw;
	
	//회원 이름
	private String memberName;
	
	//회원 이메일
	private String memberMail;
	
	//회원 우편번호
	private String memberAddr1;
	//회원 주소
	private String memberAddr2;
	//회원 상세주소
	private String memberAddr3;
	
	//관리자 구분 (0:일반사용자 / 1:관리자)
	private int adminCk;
	
	//등록일자
	private int regDate;
	
	//회원 돈
	private int money;
	//호원 포인트
	private int point;
	
	@Override /*상속 시 메소드를 재정의해서 내가 원하는대로 코딩을 가능하게 만듦. 
				VS
				부모 클래스로부터 오버라이드 되었다는 것을 표시. 부모클래스 인터페이스가 수정되었을 때, 자식 클래스를 수정하지 않으면 지옥 가는데@Override를 쓰면 컴파일러가 에러를 내준다*/
	public String toString() {
		return "MemberVO [memberId=" + memberId + ", memberPw=" + memberPw + ", memberName=" + memberName
				+ ", memberMail=" + memberMail + ", memberAddr1=" + memberAddr1 + ", memberAddr2=" + memberAddr2
				+ ", memberAddr3=" + memberAddr3 + ", adminCk=" + adminCk + ", regDate=" + regDate + ", money=" + money
				+ ", point=" + point + "]";
	}
}
