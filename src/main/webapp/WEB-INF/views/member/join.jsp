<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ page session="false"%>
<script src="/assets/jquery-3.2.1.min.js"></script>
<c:set var="root_" value="<%=request.getContextPath() %>" />
<c:set var="root" value="${root_}/resources" />
<script type="text/javascript">
	$(function(){
		$("#zipcode_btn").click(function() {
			var client = new XMLHttpRequest();
			var zipcode = $("input[name='zipcode']").val().substring(0, 5);
			client.open("GET", "http://api.zippopotam.us/us/" + zipcode, true);
			client.onreadystatechange = function() {
				if(client.readyState == 4) {
					if(client.status == 200){
						var data = JSON.parse(client.responseText);
						$("input[name='state']").val();
						$("input[name='city']").val();
						$("input[name='state']").val(data.places[0].state);
						$("input[name='city']").val(data.places[0]["place name"]);
					} else if (client.status == 403 || client.status == 404){
						alert("실패");
					}
				}
			};
			client.send();
		});
	});
	
	function idValidCheck(){
		$.ajax({
			url : "/member/check/id",
			type : "get",
			data : {"id" : $("#id").val()},
			dataType : "json",
			success : function(data){
				if(data.isValid){
					alert("You're almost done — just click the link below to verify your email address and you’re all set. Then, you can use your email address as your InGeefanclub username to log in to your account online.");
				} else {
					alert($("#id").val() + " is in use by others");
				}
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
	}
	
	function submitCheck(){
		var reg_id = /[a-zA-Z0-9]{8,16}$/g;
		var reg_pass = /[a-zA-Z0-9]{8,20}$/g;
		var reg_hp = /^((010-\d{4})|(01[1|6|7|8|9]-\d{3,4}))-\d{4}$/g;
		var check = true;
		
		if(!reg_pass.test($("#pass").val())){
			alert("Please make your password with 8 ~ 20 letters(Case insensitive.)")
			check = false;
		}
		
		if($("#pass").val() != $("#checkPass").val()){
			alert("비밀번호가 서로 다릅니다.");
			check = false;
		}
		
		if(!reg_hp.test($("#hp").val().replace(" ",""))){
			alert("Please check your mobile number.(ex.010-1234-1234)");
			check = false;
		}
		
		if(!$("#IDcheckBtn").is(":disabled")){
			alert("아이디 중복체크를 해주세요.")
			check = false;
		}
		
		return check;
	}
</script>
<!-- Header -->
<div class="content-section-a">
	<div class="container">
		<div class="row">
			<div class="col-md-2"> </div>
			<div class="col-md-8">
				<h1>회원가입</h1>
				<p class="lead">서비스 이용에는 로그인이 필요합니다.</p>
				<p>회원가입을 위해 다음과 같은 항목들을 입력해주세요.</p> <br> 
			        <!-- BEGIN DOWNLOAD PANEL -->
				<div class="panel panel-default well">
					<div class="panel-body">
						<form action="/member/join/proc" class="form-horizontal track-event-form bv-form" method="post" enctype="multipart/form-data" onsubmit="return submitCheck();" autocomplete="off">
							<div class="form-group">
			              		<div class="col-sm-6">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-user"></i>
			                            </div>
			                    			<input type="text" class="form-control" id="name" placeholder="name" name="name" required="required" autofocus="autofocus">
			                    	</div>
								</div>          
								<div class="col-sm-6">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-briefcase"></i>
			                            </div>
			                            <input type="text" class="form-control" id="nick" placeholder="nick" name="nick" required="required">
									</div>
								</div>
							</div>
							<div class="form-group">
								<div class="col-sm-6">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-id-card"></i>
										</div>
										<input type="email" class="form-control" id="id" placeholder="username" name="id" required="required" style="width:80.5%">
										<button type="button" id="IDcheckBtn" class="btn btn-success" onclick="idValidCheck();">확인</button>
									</div>
			                    </div>
			                    <div class="col-sm-6">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-file-image-o"></i>
										</div>
										<input type="file" class="form-control" id="profile_file" name="profile_file" accept="image/*">
									</div>
								</div>     
							</div>
							<div class="form-group">
								 <div class="col-sm-6">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-lock"></i>
			                            </div>
			                    		<input type="password" class="form-control" id="pass" placeholder="password" name="pass" required="required" maxlength="20">
			                        </div>
								</div>  
								 <div class="col-sm-6">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-lock"></i>
			                            </div>
			                    		<input type="password" class="form-control" id="checkPass" placeholder="password" required="required" maxlength="20">
			                        </div>
								</div>   
							</div>
							<div class="form-group">
								<div class="col-sm-12">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-mobile"></i>
										</div>
					                    <input type="text" class="form-control" id="hp" placeholder="HP" name="hp" required="required">
									</div>                                    
								</div>  
							</div>
							
							<div class="form-group">
								<div class="col-sm-12">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-address-card-o"></i>
										</div>
										<input type="text" class="form-control" id="zipcode" name="zipcode" placeholder="zipcode" style="width: 25%;">
										<input type="button" class="btn btn-success form-control" id="zipcode_btn" value="find" onclick="daumPostcode()" style="width: 10%">
										<input type="text" class="form-control" id="city" placeholder="city" name="city" style="width: 20%;" required="required" readonly="readonly">
										<input type="text" class="form-control" id="state" placeholder="state" name="state" style="width: 20%;" required="required" readonly="readonly">
										<input type="text" class="form-control" id="detailed_address" placeholder="detailed_address" name="detailed_address" style="width: 100%;" required="required">
									</div>
								</div>
							</div>
			                      
							<div class="form-group">
								<div class="col-sm-12">
									<button id="contacts-submit" type="submit" class="btn btn-default btn-info" style="float:right;">회원가입</button>
								</div>
							</div>
						</form>
					</div><!-- end panel-body -->
				</div><!-- end panel -->
			</div><!-- end col-md-8 -->
			<div class="col-md-2"></div>
		</div>
	</div> <!--  container end -->
</div>
