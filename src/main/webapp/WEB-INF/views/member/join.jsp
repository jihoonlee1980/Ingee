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
<style>
@media(min-width : 768px){
	div.input-group .join_text{
		width: 40%;
	}
}
@media(max-width : 768px){
	div.input-group .zipcode{
		width: 100%;
	}
}
</style>
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
						alert("Check your zip code.");
					}
				}
			};
			client.send();
		});
	});
	
	function idValidCheck(){
		var id = $("#id").val().replace(" ", "");
		var reg_email = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/;

		if(id == ""){
			alert("Please enter your username(eamil address)");
			return;
		}
		
		if(!reg_email.test(id)){
			alert("It’s not a valid email form.");
			return;
		}
		
		$.ajax({
			url : "/member/check/id",
			type : "get",
			data : {"id" : id},
			dataType : "json",
			success : function(data){
				if(data.isValid){
					alert("Important : Please verify your email address\n Verify your email address\n\n You're almost done — just click the link below to verify your email address and you’re all set. Then, you can use your email address as your InGeefanclub username to log in to your account online.");
					$("#IDcheckBtn").prop("disabled", true);
				} else {
					alert(id + " is in use by others");
				}
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
	}
	
	function submitCheck(){
		var reg_id = /[a-zA-Z0-9]{8,16}$/g;
		var reg_pass = /[a-zA-Z0-9]{8,20}$/g;
		var reg_hp = /\d{3}-\d{3}-\d{4}/g;
		var check = true;
		
		if(!reg_pass.test($("#pass").val())){
			alert("Please make your password with 8 ~ 20 letters(Case insensitive.)")
			check = false;
		}
		
		if($("#pass").val() != $("#checkPass").val()){
			alert("The password is not matching");
			check = false;
		}
		
		if(!reg_hp.test($("#hp").val().replace(" ",""))){
			alert("Please check your mobile number.(ex.123-1234-1234)");
			check = false;
		}
		
		if(!$("#IDcheckBtn").is(":disabled")){
			alert("Please check your username to avoid duplicate use.")
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
				<h1>Sing up</h1>
				<p class="lead">This service is requiring your login.</p>
				<p>Please enter the following items for joining.</p> <br> 
			        <!-- BEGIN DOWNLOAD PANEL -->
				<div class="panel panel-default well">
					<div class="panel-body">
						<form action="/member/join/proc" class="form-horizontal track-event-form bv-form" method="post" enctype="multipart/form-data" onsubmit="return submitCheck();" autocomplete="off">
							<div class="form-group">
			              		<div class="col-sm-12">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-user"></i>
			                            </div>
		                    			<input type="text" class="form-control join_text" id="name" placeholder="name" name="name" required="required" autofocus="autofocus">
			                    	</div>
								</div>          
							</div>
							<div class="form-group">
								<div class="col-sm-12">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-briefcase"></i>
			                            </div>
			                            <input type="text" class="form-control join_text" id="nick" placeholder="nick" name="nick" required="required">
			                            <button type="button" id="IDcheckBtn" class="btn btn-success" onclick="nickValidCheck();">Verify</button>
									</div>
								</div>
							</div>
							<div class="form-group">
								<div class="col-sm-12">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-id-card"></i>
										</div>
										<input type="email" class="form-control join_text" id="id" placeholder="username(email)" name="id" required="required" style="width:72.5%">
										<button type="button" id="IDcheckBtn" class="btn btn-success" onclick="idValidCheck();">Verify my email address</button>
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
								<div class="col-sm-6">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-mobile"></i>
										</div>
					                    <input type="text" class="form-control" id="hp" placeholder="HP" name="hp" required="required">
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
								<div class="col-sm-12">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-address-card-o"></i>
										</div>
										<input type="text" class="form-control zipcode" id="zipcode" name="zipcode" placeholder="zipcode" style="width: 25%;">
										<input type="button" class="btn btn-success form-control zipcode" id="zipcode_btn" value="Search" onclick="daumPostcode()" style="width: 10%">
										<input type="text" class="form-control zipcode" id="city" placeholder="city" name="city" style="width: 20%;" required="required" readonly="readonly">
										<input type="text" class="form-control zipcode" id="state" placeholder="state" name="state" style="width: 20%;" required="required" readonly="readonly">
										<input type="text" class="form-control zipcode" id="detailed_address" placeholder="detailed_address" name="detailed_address" style="width: 100%;" required="required">
									</div>
								</div>
							</div>
			                      
							<div class="form-group">
								<div class="col-sm-12">
									<button id="contacts-submit" type="submit" class="btn btn-default btn-info" style="float:right;">sing up</button>
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
