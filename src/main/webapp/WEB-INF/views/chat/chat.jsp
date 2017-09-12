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
</style>
<script type="text/javascript" src="<c:url value="/resources/assets/jquery-3.2.1.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/sockjs.js"/>"></script>
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
		  var forIE = false; //IE에서 한글이 전부 지워지는 경우가 있다
		  var maxLength = 200;
		  for (i = 0; i < textLength; i++) {
		   var charTemp = $('#btn-input').val().charAt(i);
		   if (escape(charTemp).length > 4) {
		    byteCnt += 2;
		    forIE= true;
		   } else {
		    byteCnt += 1;
		    forIE = false;
		   }
		  }
		  if( byteCnt > maxLength){
			  check = false;
		   if(forIE){
		    alert("You can not exceed "+maxLength+" characters.");//ie에서 한글일때
		    $('#btn-input').val($('#btn-input').val().substr(0,textLength-1));
		   }else{
		    $('#btn-input').val($('ebtn-input').val().substr(0,textLength-1));
		   }
		  }
		  return check;
		  }
	}
	var sock;
	sock = new SockJS("/chat/");
	sock.onmessage = onMessage;
	sock.onclose = onClose;
	
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
		console.log(evt);
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
				
		switch (data[0]) {
		  case 'MsgUser'  :
			  OUTHTML = "<li class='left clearfix'><span class='chat-img pull-left'>"
				+ "<img src='http://ingeefanclub.com/resources/profile/"+data[3]+"' alt='User Avatar' class='img-circle'>"
				+ "</span>"
				+ "<div class='chat-body clearfix'>"
				+ "<div class='header'>"
				+ "<strong class='primary-font' title='"+data[2]+"'>"+data[1]+"</strong> <small class='pull-right text-muted'>"
				+ "<i class='fa fa-clock-o' aria-hidden='true'></i> "+currentTime+"</small>"
				+ "</div>"
				+ "<p class='chat-content'>"
				+ data[4]
				+ "</p>"
				+ "</div>"
				+ "</li>";
				break;
		  case 'MsgMe' :
			  OUTHTML = "<li class='right clearfix'><span class='chat-img pull-right'>"
				  + "<img src='http://ingeefanclub.com/resources/profile/"+data[3]+"' alt='User Avatar' class='img-circle'>"
				  + "</span>"
				  + "<div class='chat-body clearfix'>"
				  + "<div class='header'>"
				  + "<small class=' text-muted'><i class='fa fa-clock-o' aria-hidden='true'></i> "+currentTime+"</small>"
				  + "<strong class='pull-right primary-font' title='"+data[2]+"'>"+data[1]+"</strong>"
				  + "</div>"
				  + "<p class='chat-content'>"
				  + data[4]
                  + "</p>"
                  + "</div>"
                  + "</li>";
				break;
		  case 'ConnectionMe'  :
			  OUTHTML = "<li>"+data[1]+"</li>";
			  	break;
		  case 'ConnectionUser'  :
			  OUTHTML = "<li>"+data[1]+"</li>";
			  	break;
		  case 'Off'  :
			  OUTHTML = "<li>"+data[1]+"</li>";
			  	break;
		  case 'Overlap'  :
			  OUTHTML = "<li>"+data[1]+"</li>";
			  	break;
		  default   :
			  OUTHTML = "<li>ERROR</li>";
			  	break;
		}
		$(OUTHTML).appendTo("#chatForm");
		var objDiv = document.getElementById("panel-body");
		objDiv.scrollTop = objDiv.scrollHeight;
	}
	function onClose(evt) {
		$("Disconnected").appendTo("#chatForm");
	}
</script>
<div class="container">
    <div class="row">
        <div class="col-md-12">
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
