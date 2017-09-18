<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ page session="true"%>
<c:set var="root_" value="<%=request.getContextPath() %>" />
<c:set var="root" value="${root_}/resources" />
<script src="/assets/jquery-3.2.1.min.js"></script>
<link href="${root }/css/sweetalert.css" rel="stylesheet">
<script src="${root }/js/sweetalert-dev.js"></script>
<script src="${root }/js/sweetalert.min.js"></script>
<!-- Header -->
<script type="text/javascript">
	function loginCheck(){
		var check = true;
		
		if($("#id").val() == "" || $("#pass").val() == ""){
			alert("username or password is blank")
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
			title : "Forgot your password.",
			text : "Please enter your username.\n The password will be sent shortly to the email you registered.",
			type : "input",
			showCancelButton : true,
			closeOnConfirm : false,
			animation : "slide-from-top",
			inputPlaceholder : "username(email)"
		}, function(inputValue) {
			var idCheck = true;
			var email;
			
			if (inputValue === false)
				return false;

			if (inputValue === "") {
				swal.showInputError("Please input your username(email)");
				return false
			}
			
			$.ajax({
				url : "/member/initpass",
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
						alert("No data.");
					},
					500 : function() {
						alert("Server or grammatical error.");
					}
				}
			});
			
			if (idCheck){
				swal.showInputError("The problem occurs due to a wrong username being used or an error in sending email.");
				return false;
			}
			
			swal("", "An email is sent to " + email, "success");
		});
	}
</script>
 <c:if test="${not empty result }">
   	<c:if test="${result == 1 }">
   		<script type="text/javascript">
   			alert("There is no matching information. Please check username or password.");
   		</script>
   	</c:if>
</c:if>
<div class="content-section-a" style="margin-bottom: 140px;">
	<div class="container">
		<div class="row" style="margin:0;">
			<c:if test="${not empty result }">
			   	<c:if test="${result == 2 }">
			   		<div style="width: 80%; padding-top: 30px; margin-left: 10%; white-space: pre-line; word-break: break-all;">
			   			<h1 style="font-weight: bold;">Welcome to InGee fanclub.com</h1>
						<p>We welcome you to be a member of InGee Fan Club website where fans of In​Gee gather to share stories and photos and encourage her with our supports. It's a fun site full of In Gee's smiles and comments with room reserved for your participation. 
			
						Let’s thoroughly enjoy this fanclub website and root for InGee whenever and wherever she plays. Have fun!</p>
			   		</div>			   		
			   	</c:if>
			   	<c:if test="${result != 2 }">
			   		<div style="height: 150px"></div>
			   	</c:if>
			</c:if>
			<c:if test="${empty result }">
		   		<div style="height: 150px"></div>
		   	</c:if>		   		
		    <div class="col-md-6 col-md-offset-3 col-sm-6 col-sm-offset-3 col-xs-12">
		        <h1 style="text-align: center" >Login</h3>
		    </div>
		    
		    <hr class="col-md-6 col-md-offset-3 col-sm-6 col-sm-offset-3 col-xs-12" />
		
		    <div class="col-md-6 col-md-offset-3 col-sm-6 col-sm-offset-3 col-xs-12">
		        <form class="" action="/member/login/proc" autocomplete="off" method="post" onsubmit="return loginCheck();">
		            <div class="input-group">
		                <span class="input-group-addon"><i class="fa fa-user fa-fw"></i></span>
		                <c:choose>
		                	<c:when test="${not empty loginID }">
		                		<input type="email" class="form-control" id="id" name="id" placeholder="username(eamil address)" value="${loginID }" autofocus="autofocus">
		                	</c:when>
		                	<c:when test="${empty loginID}">
		                		<c:choose>
		                			<c:when test="${cookie.isSave ne null }">
		                				<input type="email" class="form-control" id="id" name="id" placeholder="username(eamil address)" value="${cookie.saveID.value }" autofocus="autofocus">		                				
		                			</c:when>
		                			<c:otherwise>
		                				<input type="email" class="form-control" id="id" name="id" placeholder="username(eamil address)" autofocus="autofocus">
		                			</c:otherwise>
		                		</c:choose>
		                	</c:when>
		                </c:choose>
		            </div>
		            <span class="help-block"></span>
		            <div class="input-group">
		                <span class="input-group-addon"><i class="fa fa-lock fa-fw"></i></span>
		                <input type="password" id="pass" class="form-control" name="pass" placeholder="password">
		            </div>
					<span class="help-block"></span>
		            <button class="btn btn-lg btn-primary btn-block" type="submit">Login</button>
		            <input type="hidden" id="saveID" name="saveID">
		        </form>
		    </div>
		    <div class="col-md-6 col-md-offset-3 col-sm-6 col-sm-offset-3 col-xs-12">
		        <div class="col-xs-6 col-sm-6">
		            <label class="checkbox" style="margin-left: 5px;">
		                <input type="checkbox" id="isSave" ${cookie.isSave.value eq 'YES' ? 'checked' : '' }>Remember Me
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