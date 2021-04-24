package com.vampa.controller;

import java.util.Random;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.vampa.model.MemberVO;
import com.vampa.service.MemberService;

@Controller//해당 클래스가 Controller 역할을 한다고 알림
@RequestMapping(value = "/member") //member 밑에 여러 도메인이 존재할 것이므로 클래스 위에 member 도메인을 매핑해줌 즉 /memeber/ 매핑 해줌
public class MemberController {
	private static final Logger logger = LoggerFactory.getLogger(BookController.class); //로그 기록을 남기기 위해 Logger 클래스인 logger변수 선언
	
	@Autowired
	private MemberService memberservice; //MemberService.java가 MemberController.java에 자동 주입이 되도록
	
	@Autowired
	private JavaMailSender mailSender; //이메일 전송을 위한 JavaMailSender 클래스를 mailSender 생성자 생성
	
	@Autowired
	private BCryptPasswordEncoder pwEncoder; //BCryptPasswordEncoder 의존성 주입
	
	/*
	 * 회원가입 페이지 이동
	 */
	@RequestMapping(value = "join", method = RequestMethod.GET)
	public void joinGET() {
		logger.info("회원가입 페이지 진입");
	}
	
	/*
	 * 회원가입 서비스(기능) 수행 - POST요청
	 */
	@RequestMapping(value = "/join", method = RequestMethod.POST)
	public String joinPOST(MemberVO member) throws Exception {

		//기본 회원가입 -> memberservice.memberJoin(member);
		
		//스프링 시큐리티 회원가입
		String rawPw = ""; //BCrypt 인코딩 전 패스워드
		String encodePw = ""; //인코딩 후 패스워드
		
		rawPw = member.getMemberPw(); //MemberVO에서 getter를 통해 패스워드 획득
		encodePw = pwEncoder.encode(rawPw); //본래 패스워드 암호화
		member.setMemberPw(encodePw); //암호화된 패스워드 Setter를 통해 저장
		memberservice.memberJoin(member); //회원가입 쿼리 실행
		
		return "redirect:/main"; //메인 페이지로 이동
	}
	
	/*
	 * 아이디 중복성 검사 서비스(기능) 수행 - POST 요청
	 */
	@RequestMapping(value = "/memberIdChk", method = RequestMethod.POST)
	@ResponseBody //join.jsp에 해당 메소드의 return값(fail/success)를 반환해주기 위함
	public String memberIdChkPOST(String memberId) throws Exception {
		//logger.info("memberIdChk() 메소드 진입")
		int result = memberservice.idCheck(memberId); //존재하면 0, 존재하지 않으면 1 반환
		logger.info("결과값: "+ result);
		if(result != 0) {
			return "fail"; //중복된 아이디 존재
		}
		else {
			return "success"; //중복된 아이디가 없음
		}
	}
	
	/*
	 * 이메일 주복성 검사
	 */
	@RequestMapping(value = "/memberMailChk", method = RequestMethod.POST)
	@ResponseBody
	public String memberMailChkPOST(String memberMail) throws Exception {
		int result = memberservice.mailCheck(memberMail);
		if(result != 0) {
			return "fail";
		}
		else {
			return "success";
		}
	}
	
	/*
	 * 이메일 인증(테스트코드)
	 */
	@RequestMapping(value = "/mailCheck", method = RequestMethod.GET)
	@ResponseBody //값 반환을 위해
	public String mailCheckGET(String email) throws Exception {
		//join.jsp (view. 회원가입 페이지)로부터 넘어온 데이터 확인
		logger.info("이메일 데이터 전송 확인");
		logger.info("이메일: " + email);
		Random random = new Random(); //java 기본제공 Random 클래스
		int checkNum = random.nextInt(888888) + 111111; //111111~999999범위 얻기 위해
		logger.info("인증번호: " + checkNum);
		
		//인증번호 이메일 보내기 - 송수신자 설정 및 메일제목/내용 설정
		String setFrom = "jeehwnn@gmail.com"; //root-context.xml에 입력한 내 이메일 주소 이메일 주소 풀로 입력해야 함.
		String toMail = email; //수신 받을 이메일
		String title = "회원가입을 위한 인증번호입니다."; //이메일 제목
		String content = //이메일 내용
				"홈페이지를 방문해주셔서 ㄳ" +
				"<br>" + "인증번호는 " + checkNum + "입니다." +
				"해당 인증번호를 인증번호 확인란에 기입해 주세요.";
		try {
			MimeMessage message = mailSender.createMimeMessage(); //멀티파트 데이터를 처리하는 MimeMessage 객체 사용
			MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8"); //true: 멀티파트 메시지 사용하겠다는 의미. 단순 텍스트만 보낼 시 true 생략 가능
			helper.setFrom(setFrom);
			helper.setTo(toMail);
			helper.setSubject(title);
			helper.setText(content, true); //ture: html사용
			mailSender.send(message);
		} catch (Exception e) {
			e.printStackTrace();
		}
		String num = Integer.toString(checkNum); //ajax를 통해 뷰로 값 반환 시 String으로만 반환가능하기 때문에 String으로 변환
		return num;
	}
	
	
	/*
	 * 로그인 페이지 이동
	 */
	@RequestMapping(value= "login", method = RequestMethod.GET)
	public void loginGET() {
		logger.info("로그인 페이지 진입");
	}
	
	/*
	 * 로그인 기능 수행 - @@@   안돼서 주석처리 해뒀음 혹시 참고할 거면 참고하라고 @@@@
	 */
	
	/*코드주석
	@RequestMapping(value= "login", method = RequestMethod.POST)
	public String loginPOST(HttpServletRequest request, MemberVO member, RedirectAttributes rttr) throws Exception {
		
		HttpSession session = request.getSession(); //세션을 사용하기 위한 전형적인 방법
		MemberVO lvo = memberservice.memberLogin(member); //서버로부터 받은 member변수를 사용
														  //memberLogin메소드 수행 시 MemberMapper.java를 거쳐 로그인 쿼리 실행 -> 결과값이 담긴 MemberVO객체를 lvo에 저장
		//lvo는 아디/비번이 존재하면 memberId, memberName, adminCk, (money, point: 내 기준 나중에 삭제할 요소들) 데이터가 담긴 MemberVO 객체로 저장됨.
		//->만약 아디/비번이 존재하지 않으면 null이 저장됨. 따라서 null->로그인 실패->로그인페이지로 다시 redirect 하여 로그인 재요청
		if(lvo == null) { //아디/비번 존재하지 않을 시
			int result = 0;
			rttr.addFlashAttribute("result", result); //redirect시 데이터를 전달 자세한 건 용어정리 폴더에 RedirectAttributes.txt 파일 참고 간단하게 말해서 여러개 데이터 전송 + 휘발성데이터
			System.out.println(result);
			return "redirect:/member/login";
		}
		
		session.setAttribute("member", lvo); //아디/비번이 존재함 -> 로그인 성공
		
		return "redirect:/main";
	}
	코드 주석 끝 */

}
