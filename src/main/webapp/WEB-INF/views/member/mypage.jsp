<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ page session="false"%>
<c:set var="root_" value="<%=request.getContextPath() %>" />
<c:set var="root" value="${root_}/resources" />
<script src="/assets/jquery-3.2.1.min.js"></script>
<link href="${root }/css/fancy-tab.css" rel="stylesheet">
<link href="/assets/css/bootstrap.css" rel="stylesheet">
<style>
.content-div {
	padding-top: 10px;
	float: left;
	height: 100%;
}
.modal-header-primary {
    color:#fff;
    padding:9px 15px;
    border-bottom:1px solid #eee;
    background-color: #428bca;
    -webkit-border-top-left-radius: 5px;
    -webkit-border-top-right-radius: 5px;
    -moz-border-radius-topleft: 5px;
    -moz-border-radius-topright: 5px;
     border-top-left-radius: 5px;
     border-top-right-radius: 5px;
}

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
	#pass_tab{
		top: 40px;
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
						alert("fail");
					}
				}
			};
			client.send();
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

	function profileSubmitCheck(){
		var check = true;
		var reg_hp = /\d{3}-\d{3}-\d{4}/g;
		
		if(!reg_hp.test($("#hp").val().replace(" ",""))){
			alert("Please check your mobile number.(ex.123-123-1234)");
			check = false;
		}

		if(!$("#nickCheckBtn").is(":disabled")){
			alert("Please check your nickname to avoid duplicate use.")
			check = false;
		}
		
		if($("select[name='region']").val() == ""){
			alert("Pleaes select a region.");
			check = false;
		}
		
		return check;
	}
	
	
	function checkPass(num, pass){
		var result;
		
		$.ajax({
			url : "/member/check/pass",
			type : "post",
			data : {"num" : num, "pass" : pass},
			dataType : "json",
			async: false,
			success : function(data){
				result =  data.result;
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
		
		return result;
	}
	
	function passSubmitCheck(num){
		var reg_pass = /[a-zA-Z0-9]{8,20}$/g;
		var check = true;
		
		if(!checkPass(num, $("#current_pass").val())){
			alert("The current password is incorrect.");
			check = false;
		}
		
		if(!reg_pass.test($("#current_pass").val())){
			alert("Please make your current password with 8 ~ 20 letters(Case insensitive.)")
			check = false;
		}
		
		reg_pass.test(""); //이게 왜 있어야 하는거지
		
		if(!reg_pass.test($("#pass").val())){
			alert("Please make your new password with 8 ~ 20 letters(Case insensitive.)")
			check = false;
		}
		
		if($("#current_pass").val() == $("#pass").val()){
			alert("New password must be different from previous one.")
			check = false;
		}
		
		if($("#pass").val() != $("#check_new_pass").val()){
			alert("The new password is not matching");
			check = false;
		}
		
		return check;
	}
	
	function withdrawal(){
		var div = $("div.delete-form");
		if(div.is(":visible")){
			div.hide();
		} else {
			div.show();
		}
	}
	
	function deleteOnSubmit(num){
		var result = checkPass(num, $("#delete_pass").val());
		
		if(!result){
			alert("The password is incorrect.");
		}
		
		return result;
	}
	
	function validate(obj){
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
					$("#IDCheckBtn").prop("disabled", true);
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
	
	function nickValidCheck(){
		var nick = $("#nick").val().replace(" ", "");
		var reg_nick = /[a-zA-Z0-9]{8,16}$/g;

		if(nick == ""){
			alert("Please enter your nickname");
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
					alert(nick + " is in use by others");
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
	
	function validateFile(obj){
		var maxSize = 1024 * 1024;
		var fileSize = obj.files[0].size;
		
		if(fileSize > maxSize){
			alert("Please upload file size less than 1MB.");
			obj.value = "";
			return false;
		}
	}
</script>
<div class="content-section-a">
	<div class="container">
		<div class="[ row ]">
			<div class="[ col-xs-12 col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3 ]" role="tabpanel">
	            <div class="[ col-xs-4 col-sm-12 ]">
	                <!-- Nav tabs -->
	                <ul class="[ nav nav-justified ]" id="nav-tabs" role="tablist">
	                    <li role="presentation" class="active">
	                        <a href="#profile_div" aria-controls="profile_div" role="tab" data-toggle="tab">
	                            <img class="img-circle" src="/assets/img/main/mp_profile.png" />
	                            <span class="quote"><i class="fa fa-quote-left"></i></span>
	                        </a>
	                    </li>
	                    <li role="presentation" class="">
	                        <a href="#pass_div" aria-controls="pass_div" role="tab" data-toggle="tab" id="pass_tab">
	                            <img class="img-circle" src="/assets/img/main/mp_pass.png" />
	                            <span class="quote"><i class="fa fa-quote-left"></i></span>
	                        </a>
	                    </li>
	                </ul>
	            </div>
	            <div class="[ col-xs-8 col-sm-12 ]">
	                <!-- Tab panes -->
	                <div class="tab-content" id="tabs-collapse" style="border: none;">            
	                    <div role="tabpanel" class="tab-pane fade in active" id="profile_div">
	                        <div class="tab-inner">                    
	                        	<div style="width: 100%; text-align: center;">
	                        		<c:if test="${memberDTO.saved_filename == 'NO' }">
	                        			<img src="${root }/profile/none_profile.png" style="width: 40%;">
	                        		</c:if>
	                        		<c:if test="${memberDTO.saved_filename != 'NO' }">
	                        			<img src="${root }/profile/${memberDTO.saved_filename}" style="width: 40%;">
	                        		</c:if>
	                            </div>
	                            <hr>
	                            <p><strong>NAME : ${memberDTO.name }</strong></p>
	                            <p><strong>NICK : ${memberDTO.nick }</strong></p>
	                            <p><strong>REGION : ${memberDTO.region }</strong></p>
	                            <p><strong>ADDR : ${memberDTO.detailed_address }, ${memberDTO.city }, ${memberDTO.state }, ${memberDTO.zipcode }</strong></p>
	                            <p><strong>H·P : ${memberDTO.hp }</strong></p>
	                            <span class="help-block"></span>
	                            <div align="right">
		                    		<a class="btn btn-sm btn-default" href="#profile_modal" data-toggle="modal">Edit Profile</a>
		                    		<button type="button" class="btn btn-sm btn-danger" onclick="withdrawal()">Withdrawal</button>
		                    	</div>
		                    	<div class="delete-form" style="display: none;">
		                    		<form action="/member/delete" method="get" class="form-horizontal" onsubmit="return deleteOnSubmit('${memberDTO.num}');">
		                    			<div class="form-group">
		                    				<div class="col-sm-12">
		                    					<div style="width: 100%; margin-top: 1%;" align="right">
			                    					<input type="password" id="delete_pass" class="form-control" placeholder="password" maxlength="20" style="width: 50%; display: inline-block;">
			                    					<input type="hidden" name="num" value="${memberDTO.num }">
			                    					<input type="hidden" name="nick" value="${memberDTO.nick }">
			                    					<button type="submit" class="btn btn-sm btn-danger">Withdrawal</button>
		                    					</div>
		                    				</div>
		                    			</div>
		                    		</form>
		                    	</div>
	                        </div>
	                    </div>
	                    
	                    <div role="tabpanel" class="tab-pane fade" id="pass_div">
	                    	<div align="center">The change of password causes you to get automatically logged out</div>
	                        <div class="tab-inner">
		                    	<form action="/member/update/pass" class="form-horizontal" method="post" onsubmit="return passSubmitCheck('${memberDTO.num}');">
									<div class="form-group">
										<div class="col-sm-12">
											<div class="input-group">
												<div class="input-group-addon">
													<i class="fa fa-lock"></i>
					                            </div>
					                    		<input type="password" class="form-control" id="current_pass" placeholder="current password" required="required" maxlength="20">
					                    	</div>
										</div>
									</div>
									<div class="form-group">
										<div class="col-sm-12">
											<div class="input-group">
												<div class="input-group-addon">
													<i class="fa fa-lock"></i>
					                            </div>
					                    		<input type="password" class="form-control" id="pass" name="pass" placeholder="new password" required="required" maxlength="20">
					                    	</div>
				                        	<div class="input-group">
												<div class="input-group-addon">
													<i class="fa fa-lock"></i>
					                            </div>
					                    		<input type="password" class="form-control" id="check_new_pass" placeholder="new password" required="required" maxlength="20">
					                    	</div>
										</div>
									</div>
									<div align="right">
										<input type="hidden" name="num" value="${memberDTO.num }">
										<button type="submit" class="btn btn-sm btn-default">change</button>
									</div>
								</form>
	                        </div> 
	                    </div>
	                </div>
	            </div>        
	        </div>
		</div>
	</div> <!--  container end -->
</div>

<div class="modal fade" id="profile_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header modal-header-primary">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
				<h1><i class="fa fa-user-circle-o"></i>Edit Profile</h1>
			</div>
			<form action="/member/update" class="form-horizontal" method="post" enctype="multipart/form-data" onsubmit="return profileSubmitCheck();">
	            <div class="modal-body">
					<div class="form-group">
						<div class="col-sm-12">
							<div class="input-group">
								<div class="input-group-addon">
									<i class="fa fa-user"></i>
								</div>
								<input type="text" class="form-control" id="name" name="name" value="${memberDTO.name }">
							</div>
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-12">
							<div class="input-group">
								<div class="input-group-addon">
									<i class="fa fa-briefcase"></i>
								</div>
								<input type="text" class="form-control join_text" id="nick" name="nick" value="${memberDTO.nick }">
								<button type="button" id="nickCheckBtn" class="btn btn-success" onclick="nickValidCheck();" disabled="disabled">Verify</button>
							</div>
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
									<option value="West" ${memberDTO.region == 'West' ? 'selected' : '' }>West</option>
									<option value="MidWest" ${memberDTO.region == 'MidWest' ? 'MidWest' : '' }>MidWest</option>
									<option value="NorthEast" ${memberDTO.region == 'NorthEast' ? 'selected' : '' }>East</option>
									<option value="South" ${memberDTO.region == 'South' ? 'selected' : '' }>South</option>
								</select>
							</div>
	                    </div>
	                    <div class="col-sm-6">
	                    	<span class="region" style="text-decoration: underline; cursor: pointer; line-height: 100%; vertical-align: bottom;">Unfold the regional network.</span>
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
								<input type="text" class="form-control zipcode" id="zipcode" name="zipcode" placeholder="zipcode" style="width: 25%;" value="${memberDTO.zipcode }">
								<input type="button" class="btn btn-success form-control zipcode" id="zipcode_btn" value="Search" onclick="daumPostcode()" style="width: 15%">
								<input type="text" class="form-control zipcode" id="city" placeholder="city" name="city" style="width: 23%;" required="required" readonly="readonly" value="${memberDTO.city }">
								<input type="text" class="form-control zipcode" id="state" placeholder="state" name="state" style="width: 20%;" required="required" readonly="readonly" value="${memberDTO.state }">
								<input type="text" class="form-control zipcode" id="detailed_address" placeholder="detailed_address" name="detailed_address" style="width: 100%;" required="required" value="${memberDTO.detailed_address }">
							</div>
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-12">
							<div class="input-group">
								<div class="input-group-addon">
									<i class="fa fa-briefcase"></i>
								</div>
								<input type="text" class="form-control" id="hp" name="hp" value="${memberDTO.hp }">
							</div>
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-12">
							<div class="input-group">
								<div class="input-group-addon">
									<i class="fa fa-file-image-o"></i>
								</div>
								<input type="file" class="form-control" id="profile_file" name="profile_file" accept="image/*" onchange="validateFile(this)">
							</div>
							<c:if test="${memberDTO.saved_filename != 'NO' }">
								<span class="help-block" style="margin-bottom: 0; color: red; font-size: 9pt;">Delete the attachment(Please check what you want to delete).</span>
								<c:set var="saved_file" value="${fn:split(memberDTO.saved_filename, ',') }"/>
								<c:forTokens items="${memberDTO.origin_filename }" delims="," var="origin_file" varStatus="status">
									<input type="checkbox" value="${saved_file[status.index] }" name="remove_file"> ${origin_file }
								</c:forTokens>
							</c:if>
							<span class="help-block" style="padding-left: 5px; color: red;">※ Please select a file only if you want to change your profile photo.</span>
							<span class="help-block" style="padding-left: 5px; color: red;">※ When upload photos using camera please take a picture horizontally.</span>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<input type="hidden" name="num" value="${memberDTO.num }">
					<button type="button" class="btn btn-danger" data-dismiss="modal">cancel</button>
					<button type="submit" class="btn btn-success">Edit</button>
				</div>
			</form>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div>