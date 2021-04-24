<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/resources/css/member/join.css">
<script
  src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
</head>
<body>

<div class="wrapper">
	<form id="join_form" method="post">
	<div class="wrap">
			<div class="subjecet">
				<span>회원가입</span>
			</div>
			<div class="id_wrap">
				<div class="id_name">아이디</div>
				<div class="id_input_box">
					<input class="id_input" name="memberId">
				</div>
				<span class="id_input_re_1">사용 가능한 아이디입니다.</span>
				<span class="id_input_re_2">해당 아이디가 이미 존재합니다.</span>
				<span class="final_id_ck" style = "color:red">아이디를 입력해주세요.</span>
			</div>
			<div class="pw_wrap">
				<div class="pw_name">비밀번호</div>
				<div class="pw_input_box">
					<input type="password" class="pw_input" name="memberPw">
				</div>
				<span>※비밀번호는 영문+숫자+특수문자를 포함한 8자리 이상이어야 합니다.</span>
				<span class="final_pw_ck" style = "color:red">비밀번호를 입력해주세요.</span>
				<sapn class="pw_input_box_warn" style = "font-weight: bold; color:red"></sapn>
			</div>
			<div class="pwck_wrap">
				<div class="pwck_name">비밀번호 확인</div>
				<div class="pwck_input_box">
					<input type="password" class="pwck_input">
				</div>
				<span class="final_pwck_ck" style = "color:red">비밀번호 확인을 입력해주세요.</span>
				<span class="pwck_input_re_1">비밀번호가 일치합니다.</span>
				<span class="pwck_input_re_2">비밀번호가 일치하지 않습니다.</span>
			</div>
			<div class="user_wrap">
				<div class="user_name">이름</div>
				<div class="user_input_box">
					<input class="user_input" name="memberName">
				</div>
				<span class="final_name_ck" style = "color:red">이름을 입력해주세요.</span>
			</div>
			<div class="mail_wrap">
				<div class="mail_name">이메일</div> 
				<div class="mail_input_box">
					<input class="mail_input" name="memberMail">
				</div>
				<span class="mail_input_re_1">사용가능한 이메일입니다.</span><br>
				<span class="mail_input_re_2">해당 이메일이 이미 존재합니다.</span><br>
				<span class="final_mail_ck" style = "color:red">이메일을 입력해주세요.</span>
				<sapn class="mail_input_box_warn" style = "color:red"></sapn>
				<div class="mail_check_wrap">
					<div class="mail_check_input_box" id="mail_check_input_box_false">
						<input class="mail_check_input" disabled="disabled">
					</div>
					<div class="mail_check_button">
						<span>인증번호 전송</span>
					</div>
					<div class="clearfix"></div>
					<span id="mail_check_input_box_warn"></span>
				</div>
			</div>
			<div class="address_wrap">
				<div class="address_name">주소</div>
				<div class="address_input_1_wrap">
					<div class="address_input_1_box">
						<input class="address_input_1" name="memberAddr1" readonly="readonly">
					</div>
					<div class="address_button" onclick="execution_daum_address()">
						<span>주소 찾기</span>
					</div>
					<div class="clearfix"></div>
				</div>
				<div class ="address_input_2_wrap">
					<div class="address_input_2_box">
						<input class="address_input_2" name="memberAddr2" readonly="readonly">
					</div>
				</div>
				<div class ="address_input_3_wrap">
					<div class="address_input_3_box">
						<input class="address_input_3" name="memberAddr3" readonly="readonly">
					</div>
				</div>
				<span class="final_addr_ck" style = "color:red">주소를 입력해주세요.</span>
			</div>
			<div class="join_button_wrap">
				<input type="button" class="join_button" value="가입하기">
			</div>
		</div>
	</form>
</div>

<!-- 주소록 API 외부 스크립트 파일 연결 코드 추가-->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<!-- 
회원가입 클릭 시 회원가입 기능이 작동하도록 jquery코드 추가
84번째 줄의 "가입하기"버튼 <input type="button" class="join_button" value="가입하기"> 클릭 시 
form태그의 속성 action이 추가되고(url경로), form태그가 서버에 제출이 된다는 의미. 제출방식은 form태그의 POST형식
 -->
<script>

var code = ""; //Controller(MemberController.java의 mailCheckGET()메소드)로부터 전달받은 인증번호 저장
/*
 * 회원가입 유효성 검사 통과유무 변수
 */
var idCheck = false;
var idckCheck = false;
var pwCheck = false;
var pwckCheck = false;
var pwckcorCheck = false;
var nameCheck = false;
var mailCheck = false;
var mailckCheck = false;
var mailnumCheck = false;
var addressCheck = false
$(document).ready(function(){
	//회원가입 버튼(회원가입 기능 작동)
	$(".join_button").click(function(){
		//입력값 변수
		var id = $('.id_input').val();
		var pw = $('.pw_input').val();
		var pwck = $('.pwck_input').val();
		var pattern1 = /[0-9]/;
		var pattern2 = /[a-zA-Z]/;
		var pattern3 = /[~!@#$%^&*><]/;
		var warnMsg = $(".pw_input_box_warn");
		var name = $('.user_input').val();
		var mail = $('.mail_input').val();
		var addr = $('.address_input_3').val();
        //$("#join_form").attr("action", "/member/join");
        //$("#join_form").submit();
        
		//아이디 유효성 검사
		if(id == ""){
			$('.final_id_ck').css('display','block');
			idCheck = false;
		}else{
			$('.final_id_ck').css('display', 'none');
			idCheck = true;
		}
		
		//비밀번호 유효성 검사
		if(pw ==""){
			$('.final_pw_ck').css('display','block');
			pwCheck = false;
		}
		else if(!pattern1.test(pw)||!pattern2.test(pw)||!pattern3.test(pw)||pw.length<8||pw.length>50){
			warnMsg.html(" 조건 불충분");
			pwCheck = false;
		}
		else{
			$('.final_pw_ck').css('display','none');
			pwCheck = true;
		}
		
		//비밀번호 확인 유효성 검사
		if(pwck ==""){
			$('.final_pwck_ck').css('display','block');
			pwckCheck = false;
		}else{
			$('.final_pwck_ck').css('display', 'none');
			pwckCheck = true;
		}
		
		//이름 확인 유효성 검사
        if(name == ""){
            $('.final_name_ck').css('display','block');
            nameCheck = false;
        }else{
            $('.final_name_ck').css('display', 'none');
            nameCheck = true;
        }
		
		//이메일 유효성 검사
        if(mail == ""){
            $('.final_mail_ck').css('display','block');
            mailCheck = false;
        }else{
            $('.final_mail_ck').css('display', 'none');
            mailCheck = true;
        }
		
		//주소 유효성 검사
        if(addr == ""){
            $('.final_addr_ck').css('display','block');
            addressCheck = false;
        }else{
            $('.final_addr_ck').css('display', 'none');
            addressCheck = true;
        }
		
		//최종 유효성 검사
        if(idCheck && idckCheck && pwCheck && pwckCheck && pwckcorCheck && nameCheck && mailCheck && mailckCheck && mailnumCheck && addressCheck){
            $("#join_form").attr("action", "/member/join");
            $("#join_form").submit(); 
            alert("회원가입이 완료되었습니다.");
        }
        else{
        	alert("입력 정보를 다시 확인해주세요.");
        	return false;
        }
	});
});

/*
 * 아이디 영문 + 숫자만 가능하게
 */
$('.id_input').keyup(function(event){
	if(!(event.keyCode >= 37 && event.keyCode<=40)){
		var inputVal = $(this).val();
		$(this).val(inputVal.replace(/[^a-z0-9]/gi,''));
	}
})

/*
 * 아이디 중복성 검사
 */
$('.id_input').on("propertychange change keyup paste input", function(){
	var memberId = $('.id_input').val(); // .id_input에 입력되는 값을 memberId에 저장
	var data = {memberId : memberId} // 컨트롤에 넘길 데이터 이름 : 데이터(.id_input에 입력된 값)
	
	$.ajax({
		type: "post",
		url: "/member/memberIdChk",
		data: data,
		success: function(result){
			if(result != 'fail'){
				$('.id_input_re_1').css("display","inline-block");
				$('.id_input_re_2').css("display","none");
				idckCheck = true;
			} else{
				$('.id_input_re_2').css("display","inline-block");
				$('.id_input_re_1').css("display","none");
				idckCheck = false;
			}
		} //success 종료
	}); //ajax 종료
}); //function 종료

/*
 * 이름 한글만 가능하게
 */
 $('.user_input').keyup(function(event){
	 if(!(event.keyCode >= 37 && event.keyCode<=40)){
			var inputVal = $(this).val();
			$(this).val(inputVal.replace(/[a-z0-9]/gi,''));
		}
	})
 
/*
 * 인증번호 이메일 전송
 */
$(".mail_check_button").click(function(){ //.mail_check_button태그를 갖는 것을 .click 클릭하면 function() 함수 실행
	
	var email = $(".mail_input").val(); //사용자가 입력한 이메일
	var checkBox = $(".mail_check_input"); //인증번호 입력란
	var boxWrap = $(".mail_check_input_box"); //인증번호 입력란 박스
	var warnMsg = $(".mail_input_box_warn"); //이메일 입력 경고글
    //이메일 형식 유효성 검사
    if(mailFormCheck(email)){ //올바른 이메일 형식이면 mailFormCheck()가 true를 반환
    	alert("이메일이 전송되었습니다.");
        warnMsg.html("<h3>이메일이 전송 되었습니다. 이메일을 확인해주세요.</h3>");
        warnMsg.css("display", "inline-block");
    } else {
        warnMsg.html("이메일 형식이 올바르지 않습니다.");
        warnMsg.css("display", "inline-block");
        return false; //다음 ajax를 실행하지 못하도록 메소드에서 벗어나기 위해
    }    
	$.ajax({//이메일 인증번호 전송을 요청하는 ajax
		type:"GET", //url을 통해 데이터를 보낼 수 있도록 GET 방식으로 요청 , url명은 Controller의 매핑에 맞게 mailCheck로 설정
		url:"mailCheck?email=" + email, //? 쿼리 요청 시 입력된 email을 집어넣음
		success:function(data){// ajax 성공 시 해당 함수 실행
			checkBox.attr("disabled", false); //입력란에 입력가능하도록 속성을 변경 disabled -> false
			boxWrap.attr("id", "mail_check_input_box_true"); //입력란의 색상이 변경되도록 회색-> 흰색이 되도록
			code = data;
		}
	});
});

/*
 * 인증번호 비교
 */
$(".mail_check_input").blur(function(){
	var inputCode = $(".mail_check_input").val();//사용자 입력 코드
	var checkResult = $("#mail_check_input_box_warn"); //비교 결과 span태그의 일치, 불일치
	
    if(inputCode == code){                            // 일치할 경우
        checkResult.html("인증번호가 일치합니다.");
        checkResult.attr("class", "correct");
        mailnumCheck = true;
    } else {                                            // 일치하지 않을 경우
        checkResult.html("인증번호를 다시 확인해주세요.");
        checkResult.attr("class", "incorrect");
        mailnumCheck = false;
    }
});

/*
 * 이메일 중복성 검사
 */
$('.mail_input').on("propertychange change keyup paste input", function(){
	var memberMail = $('.mail_input').val(); //이메일 입력 값 memberMail에 저장
	var data = {memberMail : memberMail} //컨트롤러에 넘길 데이터이름: 넘길데이터
	$.ajax({
		type: "post",
		url: "/member/memberMailChk",
		data: data,
		success: function(result) {
			if(result != 'fail'){
				$('.mail_input_re_1').css("display","inline-block");
				$('.mail_input_re_2').css("display","none");
				mailckCheck = true;
			} else{
				$('.mail_input_re_2').css("display","inline-block");
				$('.mail_input_re_1').css("display","none");
				mailckCheck = false;
			}
		}
	});
});

/*
 * 다음 주소 연동 (주소 검색 기능 메소드)
 */
 function execution_daum_address(){
	//다음 주소 팝업창 띄우기
	new daum.Postcode({
		oncomplete: function(data){
			// 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수
            var extraAddr = ''; // 참고항목 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if(data.userSelectedType === 'R'){
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
                //주소 변수 문자열과 참고항목 문자열 합치기
                addr += extraAddr;
            
            } else {
                addr += ' ';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            $(".address_input_1").val(data.zonecode);
            $(".address_input_2").val(addr);
            // 커서를 상세주소 필드로 이동한다.
            $(".address_input_3").attr("readonly",false);
            $(".address_input_3").focus();
		}
	}).open();
}

 
/*
 * 비밀번호 확인 일치 유효성 검사 
 */
 $('.pwck_input').on("propertychange change keyup paste input", function(){
	 
	    var pw = $('.pw_input').val();
	    var pwck = $('.pwck_input').val();
	    $('.final_pwck_ck').css('display', 'none');
	    if(pw == pwck){
	        $('.pwck_input_re_1').css('display','block');
	        $('.pwck_input_re_2').css('display','none');
	        pwckcorCheck = true;
	    }else{
	        $('.pwck_input_re_1').css('display','none');
	        $('.pwck_input_re_2').css('display','block');
	        pwckcorCheck = false;
	    }
	});

/*
 * 입력 이메일 형식 유효성 검사
 */
 function mailFormCheck(email) {
	 var form = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i; 
	 return form.test(email);//매개변수 email이 form에 저장된 부합할 경우 true, 아닐경우 false반환
}
</script>

</body>
</html>