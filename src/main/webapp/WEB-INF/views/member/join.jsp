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
		width: 100% !important;
	}
	#IDCheckBtn{
		width: 100% !important;
	}
	#nickCheckBtn{
		width: 100% !important;
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
						alert("Please check your zip code.");
					}
				}
			};
			client.send();
		});
		
		$("#id").on('input',function(){
			$("#IDCheckBtn").prop("disabled", false);
		});
		
		$("#nick").on('input',function(){
			$("#nickCheckBtn").prop("disabled", false);
		});
		
		$("span.region").click(function(){
			if($(this).hasClass("show")){
				$("div.region-div").css("display", "none");
				$(this).removeClass("show");
			} else {
				$("div.region-div").css("display", "block");
				$(this).addClass("show");
			}
		});
	});
	
	function validateFile(obj){
		var maxSize = 1024 * 1024;
		var fileSize = obj.files[0].size;
		
		if(fileSize > maxSize){
			alert("Please upload file size less than 1MB.");
			obj.value = "";
			return false;
		}
	}
	
	function idValidCheck(){
		var id = $("#id").val().replace(" ", "");
		var reg_email = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/;

		if(id == ""){
			alert("Please enter your username(eamil address).");
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
					//alert("Important : You're almost done — just click the link below to verify your email address and you’re all set. Then, you can use your email address as your InGeefanclub username to log in to your account online.");
					var check = confirm("A verification email will be sent to your email address.\nYou can not receive verification email if it is not valid.\n\nWould you like to use this email?\n(※ The verification email will be invalidated after 1 day and you will need to sign up again.)");
					if(check){
						$("#IDCheckBtn").prop("disabled", true);
					} else {
						$("#IDCheckBtn").prop("disabled", false);
					}
				} else {
					alert(id + " is in use by others.");
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
	
	function nickValidCheck(){
		var nick = $("#nick").val().replace(" ", "");
		var reg_nick = /^[a-zA-Z0-9]{8,16}$/g;

		if(nick == ""){
			alert("Please enter your nickname.");
			return;
		}
		
		if(!reg_nick.test(nick)){
			alert("Please make your nickname with 8 ~ 16 letters.(Case insensitve.)");
			return;
		}
		
		$.ajax({
			url : "/member/check/nick",
			type : "get",
			data : {"nick" : nick},
			dataType : "json",
			success : function(data){
				if(data.isValid){
					alert("Available nickname.");
					$("#nickCheckBtn").prop("disabled", true);
				} else {
					alert(nick + " is in use by others.");
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
		var reg_id = /^[a-zA-Z0-9]{8,16}$/g;
		var reg_pass = /^[a-zA-Z0-9]{8,20}$/g;
		var reg_hp = /\d{3}-\d{3}-\d{4}/g;
		var check = true;
		
		if(!reg_pass.test($("#pass").val())){
			alert("Please make your password with 8 ~ 20 letters(Case insensitive.)");
			check = false;
		}
		
		if($("#pass").val() != $("#checkPass").val()){
			alert("The password is not matching");
			check = false;
		}
		
		if(!reg_hp.test($("#hp").val().replace(" ",""))){
			alert("Please check your mobile number.(ex.123-123-1234)");
			check = false;
		}
		
		if($("#city").val() == "" || $("#state").val() == ""){
			alert("Please click the zipcode search button.");
			check = false;
		}			
		
		if(!$("#IDCheckBtn").is(":disabled")){
			alert("Please check your username to avoid duplicate use.");
			check = false;
		}
		
		if(!$("#nickCheckBtn").is(":disabled")){
			alert("Please check your nickname to avoid duplicate use.");
			check = false;
		}
		
		if($("select[name='region']").val() == ""){
			alert("Pleaes select a region.");
			check = false;
		}
		
		if(!maxLengthCheck($("#detailed_address").val(), 150, "Detailed address"))
			check = false;
		
		return check;
	}
	
	function maxLengthCheck(text, maxLength, type){
		var check = true;
		var textLength = text.length;
		var byteCnt = 0;
		
		for (i = 0; i < textLength; i++) {
			var charTemp = text.charAt(i);
			if (escape(charTemp).length > 4)
				byteCnt += 2;
			else
				byteCnt += 1;
		}
		
		if (byteCnt > maxLength) {
			check = false;
			alert(type + " length can not exceed " + maxLength + " characters.");
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
				<h1>Sing up</h1><br>
				<p style="font-size: 20pt;">This service is requiring your login.</p><br>
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
											<i class="fa fa-smile-o"></i>
			                            </div>
			                            <input type="text" class="form-control join_text" id="nick" placeholder="nickname(case insensitive)" name="nick" required="required">
			                            <button type="button" id="nickCheckBtn" class="btn btn-success" onclick="nickValidCheck();">Verify</button>
									</div>
								</div>
							</div>
							<div class="form-group">
								<div class="col-sm-12">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-id-card"></i>
										</div>
										<input type="email" class="form-control join_text" id="id" placeholder="username(email)" name="id" required="required">
										<button type="button" id="IDCheckBtn" class="btn btn-success" onclick="idValidCheck();">Verify my email address</button>
									</div>
			                    </div>
							</div>
							<div class="form-group">
								 <div class="col-sm-6">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-lock"></i>
			                            </div>
			                    		<input type="password" class="form-control" id="pass" placeholder="password(case insensitive.)" name="pass" required="required" maxlength="20">
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
					                    <input type="text" class="form-control" id="hp" placeholder="cell phone(eg.123-123-1234)" name="hp" required="required">
									</div>                                    
								</div>
								 <div class="col-sm-6">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-file-image-o"></i>
										</div>
										<input type="file" class="form-control" id="profile_file" name="profile_file" accept="image/*" onchange="validateFile(this)">
									</div>
									<span class="help-block" style="padding-left: 5px; color: red; font-size: 8pt; width: 110%;">※ When upload photos using camera please take a picture horizontally.</span>
								</div>   
							</div>		
							<div class="form-group">
								<div class="col-sm-6">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-globe"></i>
										</div>
										<select name="region" class="form-control">
											<option value="">select..</option>
											<option value="West">West</option>
											<option value="MidWest">MidWest</option>
											<option value="NorthEast">NorthEast</option>
											<option value="South">South</option>
										</select>
									</div>
			                    </div>
			                    <div class="col-sm-12" style="margin-left: 20px;">
			                    	<span class="region" style="text-decoration: underline; cursor: pointer; font-size: 9pt;">• Please click below to find which group you belong to in the US. If you are not living in the US, please select " West"</span>
			                    </div>
			                    <div class="col-sm-12 region-div" style="display: none;">
			                    	<img alt="" src="${root }/img/main/region.jpg" style="max-width: 100%;" onclick="imageView(this, 'img/main/region.jpg')">
			                    </div>
							</div>					
							<div class="form-group">
								<div class="col-sm-12">
									<div class="input-group">
										<div class="input-group-addon">
											<i class="fa fa-address-card-o"></i>
										</div>
										<input type="text" class="form-control zipcode" id="detailed_address" placeholder="detailed_address" name="detailed_address" style="width: 100%;" required="required">
										<input type="text" class="form-control zipcode" id="city" placeholder="city" name="city" style="width: 20%;" required="required" readonly="readonly">
										<input type="text" class="form-control zipcode" id="state" placeholder="state" name="state" style="width: 20%;" required="required" readonly="readonly">
										<input type="text" class="form-control zipcode" id="zipcode" name="zipcode" placeholder="zipcode(eg.10001)" style="width: 25%;">
										<input type="button" class="btn btn-success form-control zipcode" id="zipcode_btn" value="Search" style="width: 10%">
									</div>
								</div>
							</div>
			                      
							<div class="form-group">
								<div class="col-sm-12">
									<button id="contacts-submit" type="submit" class="btn btn-default btn-info" style="float:right;">Sign up</button>
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
