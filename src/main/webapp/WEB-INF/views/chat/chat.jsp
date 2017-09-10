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
</style>
<script type="text/javascript" src="<c:url value="/resources/assets/jquery-3.2.1.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/sockjs.js"/>"></script>
<script type="text/javascript">
	$(function(){
		$("#btn-chat").click(function() {
			sendMessage();
			$("#btn-input").val("");
		});
		$("#btn-input").keypress(function(e){
			if(e.keyCode == 13){
				sendMessage();
				$("#btn-input").val("");
			}
		})
	});
	
	$(document).ready(function() {
		
	});
	var sock;
	sock = new SockJS("<c:url value='/chat/'/>");
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
		//console.log(evt);
		var date = new Date();
		var year = date.getYear() + 1900; //단순히 year을 받아오면 2016년 기준으로 116이 리턴됨.
		var month = date.getMonth() + 1; //month는 0부터 시작함. 1월 = 0, 10월 = 9
		var day = date.getDate(); //day는 현재 일자의 요일을 나타냄. 0 = 일요일 1 = 월요일
		var hour = date.getHours();
		var min = date.getMinutes();
		var sec = date.getSeconds();
		var currentTime = year + "." + month + "." + day + "-" + hour + ":" + min
		var data =  evt.data.split("|");
		var OUTHTML = "";
				
		switch (data[0]) {
		  case 'MsgUser'  :
			  OUTHTML = "<li class='left clearfix'><span class='chat-img pull-left'>"
				+ "<img src='http://placehold.it/50/55C1E7/fff&amp;text=U' alt='User Avatar' class='img-circle'>"
				+ "</span>"
				+ "<div class='chat-body clearfix'>"
				+ "<div class='header'>"
				+ "<strong class='primary-font'>"+data[1]+"</strong> <small class='pull-right text-muted'>"
				+ "<span class='glyphicon glyphicon-time'></span>"+currentTime+"</small>"
				+ "</div>"
				+ "<p>"
				+ data[2]
				+ "</p>"
				+ "</div>"
				+ "</li>";
				break;
		  case 'MsgMe' :
			  OUTHTML = "<li class='right clearfix'><span class='chat-img pull-right'>"
				  + "<img src='http://placehold.it/50/FA6F57/fff&amp;text=ME' alt='User Avatar' class='img-circle'>"
				  + "</span>"
				  + "<div class='chat-body clearfix'>"
				  + "<div class='header'>"
				  + "<small class=' text-muted'><span class='glyphicon glyphicon-time'></span>"+currentTime+"</small>"
				  + "<strong class='pull-right primary-font'>"+data[1]+"</strong>"
				  + "</div>"
				  + "<p>"
				  + data[2]
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
                    <span class="glyphicon glyphicon-comment"></span> Chat
                    <div class="btn-group pull-right">
                        <button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown">
                            <span class="glyphicon glyphicon-chevron-down"></span>
                        </button>
                        <ul class="dropdown-menu slidedown">
                            <li><a href="http://www.jquery2dotnet.com"><span class="glyphicon glyphicon-refresh">
                            </span>Refresh</a></li>
                            <li><a href="http://www.jquery2dotnet.com"><span class="glyphicon glyphicon-ok-sign">
                            </span>Available</a></li>
                            <li><a href="http://www.jquery2dotnet.com"><span class="glyphicon glyphicon-remove">
                            </span>Busy</a></li>
                            <li><a href="http://www.jquery2dotnet.com"><span class="glyphicon glyphicon-time"></span>
                                Away</a></li>
                            <li class="divider"></li>
                            <li><a href="http://www.jquery2dotnet.com"><span class="glyphicon glyphicon-off"></span>
                                Sign Out</a></li>
                        </ul>
                    </div>
                </div>
                <div class="panel-body">
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
