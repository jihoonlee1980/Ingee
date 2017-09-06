<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ page session="true"%>
<c:set var="root_" value="<%=request.getContextPath() %>" />
<c:set var="root" value="${root_}/resources" />
<!-- Header -->
<script type="text/javascript">
	function loginCheck(){
		var check = true;
		
		if($("#id").val() == ""){
			alert("ID가 공백입니다.")
			check = false;
		}
		
		if($("#pass").val() == ""){
			alert("비밀번호가 공백입니다.")
			check = false;
		}
		
		if($("#isSave").is(":checked")){
        	$("#saveID").val("YES");
        }else{
        	$("#saveID").val("");
        }
		
		return check;
	}
	

	function findPass() {
		swal({
			title : "비밀번호 찾기",
			text : "아이디를 입력해 주세요.\n회원가입시 등록한 이메일로 비밀번호가 발송됩니다.",
			type : "input",
			showCancelButton : true,
			closeOnConfirm : false,
			animation : "slide-from-top",
			inputPlaceholder : "아이디"
		}, function(inputValue) {
			var idCheck = true;
			var email;
			
			if (inputValue === false)
				return false;

			if (inputValue === "") {
				swal.showInputError("아이디를 써주세요!");
				return false
			}
			
			$.ajax({
				url : "/sendmail",
				type : "get",
				data : {"id" : inputValue},
				dataType : "json",
				async: false,
				success : function(data){
					idCheck = data.isValid;
					email = data.email;
				},
				statusCode : {
					404 : function() {
						alert("해당 데이터 존재X");
					},
					500 : function() {
						alert("서버 혹은 문법적 오류");
					}
				}
			});
			
			if (idCheck){
				swal.showInputError("아이디가 틀렸거나 메일 발송중 문제가 생겼습니다.");
				return false;
			}
			
			swal("메일발송", email + "로\n메일이 발송되었습니다.", "success");
		});
	}
</script>
 <c:if test="${not empty result }">
   	<c:if test="${result == 2 }">
   		<script type="text/javascript">
   			swal({
   				title : "일치하는 정보가 없습니다!",
   				text : "ID나 비밀번호를 확인해 주세요.<br><a href='/join'>아직 회원이 아니시라면 지금 가입하세요!<a>",
   				type : "error",
   				html : true,
   				confirmButtonText: "확인"
   			});
   		</script>
   	</c:if>
</c:if>
<c:if test="${not empty result }">
   	<c:if test="${result == 3 }">
   		<script type="text/javascript">
   			swal({
   				title : "로그인 거부",
   				text : "관리자에게 문의하세요.&nbsp\;<a href='mailto:seun80@hanmail.net'>메일 보내기</a>",
   				type : "warning",
   				confirmButtonText: "확인",
   				html : true
   			});
   		</script>
   	</c:if>
</c:if>
<div class="content-section-a" style="margin-top:200px; margin-bottom: 140px;">
	<div class="container">
		<div class="row" style="margin:0;">
		    <div class="col-md-6 col-md-offset-3 col-sm-6 col-sm-offset-3 col-xs-12">
		        <h1 style="text-align: center" >Login</h3>
		    </div>
		    
		    <hr class="col-md-6 col-md-offset-3 col-sm-6 col-sm-offset-3 col-xs-12" />
		
		    <div class="col-md-6 col-md-offset-3 col-sm-6 col-sm-offset-3 col-xs-12">
		        <form class="" action="/login/proc" autocomplete="off" method="post" onsubmit="return loginCheck();">
		            <div class="input-group">
		                <span class="input-group-addon"><i class="fa fa-user fa-fw"></i></span>
		                <c:choose>
		                	<c:when test="${not empty loginID }">
		                		<input type="text" class="form-control" id="id" name="id" placeholder="E-mail" value="${loginID }" autofocus="autofocus">
		                	</c:when>
		                	<c:when test="${empty loginID}">
		                		<c:choose>
		                			<c:when test="${isSave eq 'YES' }">
		                				<input type="text" class="form-control" id="id" name="id" placeholder="E-mail" value="${loggedInID }" autofocus="autofocus">		                				
		                			</c:when>
		                			<c:otherwise>
		                				<input type="text" class="form-control" id="id" name="id" placeholder="E-mail" autofocus="autofocus">
		                			</c:otherwise>
		                		</c:choose>
		                	</c:when>
		                </c:choose>
		            </div>
		            <span class="help-block"></span>
		            <div class="input-group">
		                <span class="input-group-addon"><i class="fa fa-lock fa-fw"></i></span>
		                <input type="password" id="pass" class="form-control" name="pass" placeholder="PASSWORD">
		            </div>
		            <span class="help-block" style="padding-left: 2%; color: red;">
		            	<c:if test="${not empty result }">
		            		<c:if test="${result == 1 }">
		            			비밀번호를 ${failCount }회 틀렸습니다.
		            		</c:if>
		            	</c:if>
		            </span>
		            <button class="btn btn-lg btn-primary btn-block" type="submit">Login</button>
		            <input type="hidden" id="saveID" name="saveID">
		        </form>
		    </div>
		    <div class="col-md-6 col-md-offset-3 col-sm-6 col-sm-offset-3 col-xs-12">
		        <div class="col-xs-6 col-sm-6">
		            <label class="checkbox" style="margin-left: 5px;">
		                <input type="checkbox" id="isSave" ${isSave eq 'YES' ? "checked" : "" }>Remember Me
		            </label>
		        </div>
		        <div class="col-xs-6 col-sm-6" style="margin-top: 10px;">
		            <p class="pull-right">
		                <a href="/member/join">Register</a>&nbsp;&nbsp;&nbsp;&nbsp;<a style="cursor: pointer;" onclick="findPass()">Forgot password?</a>
		            </p>
		        </div>
		    </div>
		</div>
	</div><!--  container end -->
</div> 