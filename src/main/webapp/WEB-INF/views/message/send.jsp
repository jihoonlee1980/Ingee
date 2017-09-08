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
<link href="/assets/css/bootstrap.css?ver=2" rel="stylesheet">
<script type="text/javascript">
$(document).ready(function(){
    $("#addRecvBtn").click(function(){
    	if($("#addAllRecvBtn").attr("check")=="false"){
	    	$("input[name='receiver']").prop("required",true);
	    	if(idValidCheck()){
	    		//$("#recvAddForm").html("");
	        	$('#recvAddForm').empty();
	    		var receiver = $("input[name='receiver']").val();    		
	    		var OUTHTML = "<div class='input-group' ><span class='input-group-addon'><i class='fa fa-envelope'></i></span>"
	    					+ "<input type='email' class='form-control' style='width:75%;' value='"+receiver+"' readonly='readonly'>";    					 
	    					
	    		$(OUTHTML).appendTo("#recvAddForm");
	    		$("#myModal").modal();
	    	}
    	}
    	else
    		alert("All button is enabled");
    });
    $("#addAllRecvBtn").click(function(){
    	if($(this).attr("check")=="false"){
    		$("input[name='receiver']").prop("required",false);
    		$("input[name='receiver']").val("all");
    		$("input[name='recvlist']").val("all");
    		$("input[name='receiver']").prop("readonly",true);
    		$(this).attr("check","true");
    	}
    	else{
    		$("input[name='receiver']").prop("required",true);
    		$("input[name='receiver']").val("");
    		$("input[name='recvlist']").val("all");
    		$("input[name='receiver']").prop("readonly",false);
    		$(this).attr("check","false");
    	}
    		
    });
    $('[data-toggle="tooltip"]').tooltip();  
});
function recvAdd() {	
	var size = $("#recvAddForm").children(".input-group").size();
	if(size < 10){
		var OUTHTML = "<div class='input-group' ><span class='input-group-addon'><i class='fa fa-envelope'></i></span>"
					+ "<input type='email' class='form-control' style='width:75%;' value=''>"
					+ "<a class='btn icon-btn btn-warning' href='#' onclick=\"javascript:recvRemove(this);\"><span class='glyphicon btn-glyphicon glyphicon-minus img-circle text-warning'></span>Remove</a></div>"; 
					
		$(OUTHTML).appendTo("#recvAddForm");
	}
	else{
		alert("You can only send to up to 10 people.");
	}
}

function recvRemove(obj) {
	$(obj).parent(".input-group").remove();	
}

function idValidCheck(){
	var check = false;
	var receiver = $("input[name='receiver']").val(); 
	var id = receiver.replace(" ", "");
	var reg_email = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/;

	if(id == ""){
		alert("Please enter your username(eamil address)");
		check = false;
	}
	
	if(!reg_email.test(id) && ($("input[name='receiver']").val()==null || $("input[name='receiver']").val()=="")){
		alert("It’s not a valid email form.");
		check = false;
	}
	else{
		check = true;
	}
	return check;
	
}

function idValidCheckMulti(){
	var check = false;	
	$("#recvAddForm").children(".input-group").each(function(index){
			
		var receiver = $(this).children(".form-control").val();
		var id = receiver.replace(" ", "");
		var reg_email = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/;

		if(id == ""){
			alert("Please enter your username(eamil address)");
			check = false;
		}
		
		if(!reg_email.test(id)){
			alert("It’s not a valid email form. ["+receiver+"]");
			check = false;
		}
		else{
			check = true;
		}
		
	});
	return check;
}

function idCheck(){
	if(idValidCheckMulti()){
		var arrData = new Array();        
        
		$("#recvAddForm").children(".input-group").each(function(index){
			arrData[index] = $(this).children(".form-control").val();	 
		});
		console.log(arrData);
		jQuery.ajaxSettings.traditional = true;
		$.ajax({
			url : "/message/check/id",
			type : "get",
			data : {"arrData" : arrData},
			dataType : "json",
			success : function(data){
				console.log(data);
				var resultData = "Invalid ID :";
				if(data.resultList.length > 0){
					for(var i =0 ; i < data.resultList.length; i++){
						resultData += (data.resultList[i] + " , ");
					}
					alert(resultData);
				}
				else{
					var recvList = "";
					var recvListSize = $("#recvAddForm").children(".input-group").size();
					$("#recvAddForm").children(".input-group").each(function(index){
						
						if(index === (recvListSize - 1))
							recvList += ($(this).children(".form-control").val());	 
						else{
							recvList += ($(this).children(".form-control").val()+",");	
						}
					});
					var originValue = $("input[name='receiver']").val();
					$("input[name='receiver']").attr("title",recvList);
					$("input[name='receiver']").val(originValue+"  ...");
					$("input[name='receiver']").prop("required",true);
					$("input[name='recvlist']").val("");
					$("input[name='recvlist']").val(recvList);
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
}



</script>
<style>
.form-group input[type="checkbox"] {
    display: none;
}

.form-group input[type="checkbox"] + .btn-group > label span {
    width: 20px;
}

.form-group input[type="checkbox"] + .btn-group > label span:first-child {
    display: none;
}
.form-group input[type="checkbox"] + .btn-group > label span:last-child {
    display: inline-block;   
}

.form-group input[type="checkbox"]:checked + .btn-group > label span:first-child {
    display: inline-block;
}
.form-group input[type="checkbox"]:checked + .btn-group > label span:last-child {
    display: none;   
}
.checkbox label:after, 
.radio label:after {
    content: '';
    display: table;
    clear: both;
}

.checkbox .cr,
.radio .cr {
    position: relative;
    display: inline-block;
    border: 1px solid #a9a9a9;
    border-radius: .25em;
    width: 1.3em;
    height: 1.3em;
    float: left;
    margin-right: .5em;
}

.radio .cr {
    border-radius: 50%;
}

.checkbox .cr .cr-icon,
.radio .cr .cr-icon {
    position: absolute;
    font-size: .8em;
    line-height: 0;
    top: 50%;
    left: 20%;
}

.radio .cr .cr-icon {
    margin-left: 0.04em;
}

.checkbox label input[type="checkbox"],
.radio label input[type="radio"] {
    display: none;
}

.checkbox label input[type="checkbox"] + .cr > .cr-icon,
.radio label input[type="radio"] + .cr > .cr-icon {
    transform: scale(3) rotateZ(-20deg);
    opacity: 0;
    transition: all .3s ease-in;
}

.checkbox label input[type="checkbox"]:checked + .cr > .cr-icon,
.radio label input[type="radio"]:checked + .cr > .cr-icon {
    transform: scale(1) rotateZ(0deg);
    opacity: 1;
}

.checkbox label input[type="checkbox"]:disabled + .cr,
.radio label input[type="radio"]:disabled + .cr {
    opacity: .5;
    
.btn-glyphicon { padding:8px; background:#ffffff; margin-right:4px; }
.icon-btn { padding: 1px 15px 3px 2px; border-radius:50px;}
}
</style>
<div class="content-section-a">
	<div class="container">
		<h1>
			Send
		</h1>
		<form class="col-md-12 well" action="/message/send" method="post" onsubmit="return idValidCheck()">
             <div class="row">				
				<!-- Modal -->
				<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
				  <div class="modal-dialog">
				    <div class="modal-content">
				      <div class="modal-header">
				        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">Close</span></button>
				        <h4 class="modal-title" id="myModalLabel"><i class="fa fa-share-alt"></i> Share</h4>
				      </div>
				      <div class="modal-body">
				        <p><a title="Facebook" href=""><span class="fa-stack fa-lg"><i class="fa fa-square-o fa-stack-2x"></i><i class="fa fa-facebook fa-stack-1x"></i></span></a> <a title="Twitter" href=""><span class="fa-stack fa-lg"><i class="fa fa-square-o fa-stack-2x"></i><i class="fa fa-twitter fa-stack-1x"></i></span></a> <a title="Google+" href=""><span class="fa-stack fa-lg"><i class="fa fa-square-o fa-stack-2x"></i><i class="fa fa-google-plus fa-stack-1x"></i></span></a> <a title="Linkedin" href=""><span class="fa-stack fa-lg"><i class="fa fa-square-o fa-stack-2x"></i><i class="fa fa-linkedin fa-stack-1x"></i></span></a> <a title="Reddit" href=""><span class="fa-stack fa-lg"><i class="fa fa-square-o fa-stack-2x"></i><i class="fa fa-reddit fa-stack-1x"></i></span></a> <a title="WordPress" href=""><span class="fa-stack fa-lg"><i class="fa fa-square-o fa-stack-2x"></i><i class="fa fa-wordpress fa-stack-1x"></i></span></a> <a title="Digg" href=""><span class="fa-stack fa-lg"><i class="fa fa-square-o fa-stack-2x"></i><i class="fa fa-digg fa-stack-1x"></i></span></a>  <a title="Stumbleupon" href=""><span class="fa-stack fa-lg"><i class="fa fa-square-o fa-stack-2x"></i><i class="fa fa-stumbleupon fa-stack-1x"></i></span></a><a title="E-mail" href=""><span class="fa-stack fa-lg"><i class="fa fa-square-o fa-stack-2x"></i><i class="fa fa-envelope fa-stack-1x"></i></span></a>  <a title="Print" href=""><span class="fa-stack fa-lg"><i class="fa fa-square-o fa-stack-2x"></i><i class="fa fa-print fa-stack-1x"></i></span></a></p>
				        
				        <h2><i class="fa fa-envelope"></i> Newsletter</h2>
				                
				                <p>Subscribe to our weekly Newsletter and stay tuned.
					                <a class="btn icon-btn btn-success" href="#" onclick="recvAdd()"><span class="glyphicon btn-glyphicon glyphicon-plus img-circle text-success">
					                </span>Add</a>
				                </p>
				                
				                <form action="" method="post">
				                	<div id="recvAddForm">
				                    
									</div>
				                    <br />
				                    <button type="button" value="sub" name="sub" class="btn btn-primary" onclick="idCheck()"><i class="fa fa-share"></i> Subscribe Now!</button>
				              </form>
				      </div>
				      <div class="modal-footer">
				        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				      </div>
				    </div>
				  </div>
				</div>
                 <div class="col-md-6">
                     <div class="form-group">
                         <label for="sender">Sender</label>
                         <input type="text" class="form-control" name="sender" value='<c:out value="${id }"/>' readonly="readonly">
                     </div>
                     <div class="form-group">                     	
                         <label for="receiver">Receiver</label>
                        <div class="input-group" style="width:100%;">
                         <input type="text" class="form-control" name="receiver" data-toggle="tooltip" title="" placeholder="Receiver" required="required" style="width:75%;" >
                         <input type="hidden" name="recvlist" style="width:75%;" >
                         <button type="button" id="addRecvBtn" style="padding: 5px 12px;"><i class="fa fa-users" aria-hidden="true"></i>Add</button>
                         <button type="button" id="addAllRecvBtn" style="padding: 5px 12px;" check="false"><i class="fa fa-users" aria-hidden="true"></i>All</button>                         
                        </div>				        
                     </div>
                     <div class="form-group">
                         <label for="subject">Subject</label>
                         <input type="text" class="form-control" name="subject" placeholder="Subject" required="required">
                     </div>                        
                 </div>
         
                 <div class="col-md-6">
                     <div class="form-group">
                         <label for="message">Message</label>
                         <textarea class="form-control" name="content" rows="11" placeholder="Enter Message" required="required"></textarea>
                     </div>
                     <div class="form-group">
                        <button class="btn btn-primary pull-right" type="submit">Send</button>
                     </div>
                 </div>
             </div>
		</form>
	</div>
</div>