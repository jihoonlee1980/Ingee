<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ page session="true"%>
<spring:htmlEscape defaultHtmlEscape="true" />
<c:set var="root_" value="<%=request.getContextPath() %>" />
<c:set var="root" value="${root_}/resources" />
<style>
.chat
{
    list-style: none;
    margin: 0;
    padding: 0;
}

.chat li{
	min-height:100px;
}
.chat-content{
	white-space: pre-wrap;
    word-break: break-all;
}
.img-circle {
	width:50px;
	height:50px;
}
.panel-body{
	min-height:750px;
	max-height:750px;
	overflow-y:scroll;
}
.primary-font{
	cursor:pointer;	
}
.primary-font:hover{
	background: #c8dbea;
    border-radius: 20px;
}
.list-li:nth-child(even){
	background:#e0e0e0;
}
.list-li:nth-child(odd){
	background:#fff;
}
.list-li:hover{
	background: #cad0a7;
}

</style>
<script type="text/javascript" src="<c:url value="/resources/assets/jquery-3.2.1.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/sockjs.js"/>"></script>
<script src="/resources/js/popup.js"></script>
<script type="text/javascript">
	$(function(){
		$("#btn-chat").click(function() {			
			if(maxLengthCheck()){
				sendMessage();
				$("#btn-input").val("");
			}
		});
		$("#btn-input").keypress(function(e){			
			if(e.keyCode == 13){				
				if(maxLengthCheck()){
					sendMessage();
					$("#btn-input").val("");	
				}
			}
		});
	});	
	function maxLengthCheck(){		
		var check = true;
		  var textLength = $('#btn-input').val().length;
		  if(textLength <= 0){
			  alert("Please enter your message");
			  return false;
		  }
		  else{
		  var byteCnt = 0;
		  var maxLength = 200;
		  for (i = 0; i < textLength; i++) {
		   var charTemp = $('#btn-input').val().charAt(i);
		   if (escape(charTemp).length == 6) {
		    byteCnt += 2;
		    forIE= true;
		   } else {
		    byteCnt += 1;
		    forIE = false;
		   }
		  }
		  if( byteCnt > maxLength){
			  check = false;
		    alert("You can not exceed "+maxLength+" characters.");//ie에서 한글일때		   
		  }
		  return check;
		  }
	}
	var sock;
	sock = new SockJS("/chat/");
	sock.onmessage = onMessage;
	sock.onclose = onClose;
	sock.onopen = onOpen;
	function sendMessage() {
		var msg = $("#btn-input").val();
		
		if(msg.indexOf('|') == -1){
			sock.send(msg);	
		}
		else{
			alert("You have entered certain characters that can not be included.");
		}
		
	}

	function onMessage(evt) {		
		//console.log(evt);
		var date = new Date(evt.timeStamp);
		var year = date.getYear() + 1900; //단순히 year을 받아오면 2016년 기준으로 116이 리턴됨.
		var month = date.getMonth() + 1; //month는 0부터 시작함. 1월 = 0, 10월 = 9
		var day = date.getDate(); //day는 현재 일자의 요일을 나타냄. 0 = 일요일 1 = 월요일
		var hour = date.getHours();
		var min = date.getMinutes();
		var sec = date.getSeconds();
		var currentTime = year + "." + month + "." + day + " " + hour + ":" + min
		var data =  evt.data.split("|");
		var OUTHTML = "";
		var imgPath = "<c:url value='/resources'/>";
		switch (data[0]) {
		  case 'MsgUser'  :			  
			  OUTHTML = "<li class='left clearfix'><span class='chat-img pull-left'>"
				+ "<img src='"+imgPath+"/profile/"+data[3]+"' alt='User Avatar' class='img-circle'>"
				+ "</span>"
				+ "<div class='chat-body clearfix'>"
				+ "<div class='header dropdown'>"
				+ "<strong class='primary-font dropdown-toggle message-id' data-toggle='dropdown' title='"+data[2]+"'>"+data[1]+"</strong> <small class='pull-right text-muted'>"
				+ "<i class='fa fa-clock-o' aria-hidden='true'></i> "+currentTime+"</small>"
				+ "<ul class='dropdown-menu' role='menu' aria-labelledby='menu1'>"
				+ "<li role='presentation' style='min-height:0px;'><a role='menuitem' tabindex='-1' href='#' onclick='popupOpen(\""+data[2]+"\")'>Profile</a></li>"
				+ "<li role='presentation' style='min-height:0px;'><a role='menuitem' tabindex='-1' href='/message/send?sendto="+data[2]+"' target='_blank'>Reply</a></li>"						      
				+ "</ul>"
				+ "</div>"
				+ "<p class='chat-content'>"
				+ data[4]
				+ "</p>"
				+ "</div>"
				+ "</li>";
				break;
		  case 'MsgMe' :
			  OUTHTML = "<li class='right clearfix'><span class='chat-img pull-right'>"
				  + "<img src='"+imgPath+"/profile/"+data[3]+"' alt='User Avatar' class='img-circle'>"
				  + "</span>"
				  + "<div class='chat-body clearfix'>"
				  + "<div class='header dropdown'>"
				  + "<small class=' text-muted'><i class='fa fa-clock-o' aria-hidden='true'></i> "+currentTime+"</small>"
				  + "<strong class='pull-right primary-font dropdown-toggle message-id' data-toggle='dropdown' title='"+data[2]+"'>"+data[1]+"</strong>"
				  + "<ul class='dropdown-menu' role='menu' aria-labelledby='menu1' style='right:0; left:auto;'>"
				  + "<li role='presentation' style='min-height:0px;'><a role='menuitem' tabindex='-1' href='#' onclick='popupOpen(\""+data[2]+"\")'>Profile</a></li>"
				  + "<li role='presentation' style='min-height:0px;'><a role='menuitem' tabindex='-1' href='/message/send?sendto="+data[2]+"' target='_blank'>Reply</a></li>"						      
				  + "</ul>"
				  + "</div>"
				  + "<p class='chat-content'>"
				  + data[4]
                  + "</p>"
                  + "</div>"
                  + "</li>";
				break;
		  case 'ConnectionMe'  :
			  OUTHTML = "<li style='min-height: 35px;'>"+data[1]+"</li>";
			  	break;
		  case 'ConnectionUser'  :
			  OUTHTML = "<li style='min-height: 35px;'>"+data[1]+"</li>";
			  	break;
		  case 'Off'  :			  
			  OUTHTML = "<li style='min-height: 35px;'>"+data[1]+"</li>";
			  $("#chatList").each(function(){
				 if($(this).children(".primary-font").text()==data[2])
					alert($(this).children(".primary-font").text());
			  });
			  	break;
		  case 'Overlap'  :
			  OUTHTML = "<li style='min-height: 35px;'>"+data[1]+"</li>";
			  	break;
		  case 'userList' :			  
			  $("#chatList").empty();
				  var listJob = JSON.parse(data[1]);
				  for(var i = 0; i < listJob.nick.length; i++){
					  var nick = listJob.nick[i]
					  var id = listJob.id[i]
					  var profile = listJob.profile[i]
					  var CHATLISTHTML = "<li class='left clearfix list-li' style='min-height:50px;'><span class='chat-img pull-left' ><img "
							+ "src='"+imgPath+"/profile/"+profile+"' alt='User Avatar'"
							+ "class='img-circle'></span>"
							+ "<div class='chat-body clearfix'>"
							+ "<div class='header dropdown'>"
							+ "<strong class='primary-font dropdown-toggle message-id'"
							+ "data-toggle='dropdown' title='"+id+"' style='font-size:0.8em; line-height:50px; white-space: nowrap; text-overflow:ellipsis;'>"+nick+"</strong>"										
							+ "<ul class='dropdown-menu' role='menu' aria-labelledby='menu1' style='min-width:120px;'>"
							+ "<li role='presentation' style='min-height: 0px;'><a"
							+ "role='menuitem' tabindex='-1' href='#'"
							+ "onclick='popupOpen(\""+id+"\")'>Profile</a></li>"
							+ "<li role='presentation' style='min-height: 0px;'><a "
							+ "role='menuitem' tabindex='-1'"
							+ "href='/message/send?sendto="+id+"' target='_blank'>Reply</a></li>"
							+ "</ul>"
							+ "</div>"
							+ "</div>"
							+ "</li>";
					  $(CHATLISTHTML).appendTo("#chatList");
				  }
				  $("#chatTotal").text("("+listJob.nick.length+")");
			   break;
		  default   :
			  OUTHTML = "<li style='min-height: 35px;'>ERROR</li>";
			  	break;
		}
		$(OUTHTML).appendTo("#chatForm");
		var objDiv = document.getElementById("panel-body");
		objDiv.scrollTop = objDiv.scrollHeight;
	}
	function onClose(evt) {
		$("Disconnected").appendTo("#chatForm");
	}
	function onOpen (evt) {
		//console.log("open!!!");
		//console.log(evt);
		
	}
</script>
<div class="container">
    <div class="row">
    	<div class="col-md-2">
    		<div class="panel panel-danger">
                <div class="panel-heading">
                    <i class="fa fa-users" aria-hidden="true"></i> List <span id="chatTotal"></span>
                </div>
                <div class="panel-body" style="padding:0;">
                    <ul class="chat" id="chatList">
					</ul>
                </div>
                <!-- <div class="panel-footer" style="padding:10px 5px;">
                    <div class="input-group">
                        <input id="search_" type="text" class="form-control input-sm" title="Search for Nickname" placeholder="Search for Nickname">
                        <span class="input-group-btn">
                            <button class="btn btn-warning btn-sm" id="search_btn">
                                Search</button>
                        </span>
                    </div>
                </div> -->
            </div>
    	</div>
        <div class="col-md-10">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <i class="fa fa-comments-o" aria-hidden="true"></i> Chat
                </div>
                <div class="panel-body" id="panel-body">
                    <ul class="chat" id="chatForm">                        
                    </ul>
                </div>
                <div class="panel-footer">
                    <div class="input-group">
                        <input id="btn-input" type="text" class="form-control input-sm" placeholder="Type your message here...">
                        <span class="input-group-btn">
                            <button class="btn btn-warning btn-sm" id="btn-chat">
                                Send</button>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
