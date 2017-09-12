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
<script type="text/javascript">
function popupOpen(){

	var popUrl = "test.html";	//팝업창에 출력될 페이지 URL

	var popOption = "width=370, height=360, resizable=no, scrollbars=no, status=no;";    //팝업창 옵션(optoin)

		window.open(popUrl,"",popOption);

	}

$(document).ready(function () {
	$('.search-panel .dropdown-menu').find('a').click(function(e) {
		e.preventDefault();
		var param = $(this).attr("href").replace("#","");
		var concept = $(this).text();
		$('.search-panel span#type').text(concept);
		
		if(param == "receiver")
			$("input[name='DISC']").val("sent");
		else
			$("input[name='DISC']").val("recv");
		
		$('.input-group #search_type').val(param);
	});
	$(".comments .post-comments .checkbox").children("input[type='checkbox']").change(function(){
		var checkValue = true;
		$(".comments .post-comments .checkbox").each(function(index){
			if(!($(this).children("input[type='checkbox']").is(":checked"))){
				checkValue = false;
			}			
		});
		if(!checkValue)
			$("#deleteAll").prop('checked', false);		
		else
			$("#deleteAll").prop('checked', true);
	});
	$("#deleteAll").change(function(){		
        if($("#deleteAll").is(":checked")){
        	$(".comments .post-comments .checkbox").children("input[type='checkbox']").prop('checked', true);        	
            //alert("체크박스 체크했음!");
        }else{
        	$(".comments .post-comments .checkbox").children("input[type='checkbox']").prop('checked', false);
        }
    });
	$("#deleteBtn").click(function(event) {
		event.preventDefault();
		var checkValueArr = new Array();
		$(".comments .post-comments .checkbox").each(function(index){
			 var $checkData = $(this).children("input[type='checkbox']");
			 if($checkData.is(":checked")){				 
				 checkValueArr[index] = $checkData.attr("num");
			 }			 
		 });
		if(checkValueArr.length > 0){
			jQuery.ajaxSettings.traditional = true;
			$.ajax({
				url : "/message/delete",
				type : "get",
				data : {"arrData" : checkValueArr},
				dataType : "json",
				async: false,
				success : function(data){
					if(data.resultCheck > 0){
						history.go(0);
					}
					else{
						alert("delete failed");
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
		
		
		
	});
	
 });
</script>
<style>

body{
    background:#eee;
}

hr {
    margin-top: 20px;
    margin-bottom: 20px;
    border: 0;
    border-top: 1px solid #FFFFFF;
}
a {
    color: #82b440;
    text-decoration: none;
}
.blog-comment::before,
.blog-comment::after,
.blog-comment-form::before,
.blog-comment-form::after{
    content: "";
	display: table;
	clear: both;
}

.blog-comment{
    /* padding-left: 15%;
	padding-right: 15%; */
}

.blog-comment ul{
	list-style-type: none;
	padding: 0;
}

.blog-comment img{
	opacity: 1;
	filter: Alpha(opacity=100);
	-webkit-border-radius: 4px;
	   -moz-border-radius: 4px;
	  	 -o-border-radius: 4px;
			border-radius: 4px;
}

.blog-comment img.avatar {
	position: relative;
	float: left;
	margin-left: 0;
	margin-top: 0;
	width: 65px;
	height: 65px;
}

.blog-comment .post-comments{
	border: 1px solid #eee;
    margin-bottom: 20px;
    margin-left: 85px;
	margin-right: 0px;
    padding: 10px 20px;
    position: relative;
    -webkit-border-radius: 4px;
       -moz-border-radius: 4px;
       	 -o-border-radius: 4px;
    		border-radius: 4px;
	background: #fff;
	color: #6b6e80;
	position: relative;
}

.blog-comment .meta {
	display:inline;
	font-size: 13px;
	color: #aaaaaa;
	padding-bottom: 8px;
	margin-bottom: 10px !important;
	border-bottom: 1px solid #eee;
}

.blog-comment ul.comments ul{
	list-style-type: none;
	padding: 0;
	margin-left: 85px;
}

.blog-comment-form{
	padding-left: 15%;
	padding-right: 15%;
	padding-top: 40px;
}

.blog-comment h3,
.blog-comment-form h3{
	margin-bottom: 40px;
	font-size: 26px;
	line-height: 30px;
	font-weight: 800;
}
.clearfix:hover {
	/* border:1px solid #9a7e61 */
}
.checkbox {
  padding-left: 20px;
  display: inline;
  float:right; }
  .checkbox label {
    display: inline-block;
    position: relative;
    padding-left: 5px; }
    .checkbox label::before {
      content: "";
      display: inline-block;
      position: absolute;
      width: 17px;
      height: 17px;
      left: 0;
      margin-left: -20px;
      border: 1px solid #cccccc;
      border-radius: 3px;
      background-color: #fff;
      -webkit-transition: border 0.15s ease-in-out, color 0.15s ease-in-out;
      -o-transition: border 0.15s ease-in-out, color 0.15s ease-in-out;
      transition: border 0.15s ease-in-out, color 0.15s ease-in-out; }
    .checkbox label::after {
      display: inline-block;
      position: absolute;
      width: 16px;
      height: 16px;
      left: 0;
      top: 0;
      margin-left: -20px;
      padding-left: 3px;
      padding-top: 1px;
      font-size: 11px;
      color: #555555; }
  .checkbox input[type="checkbox"] {
    opacity: 0; }
    .checkbox input[type="checkbox"]:focus + label::before {
      outline: thin dotted;
      outline: 5px auto -webkit-focus-ring-color;
      outline-offset: -2px; }
    .checkbox input[type="checkbox"]:checked + label::after {
      font-family: 'FontAwesome';
      content: "\f00c"; }
    .checkbox input[type="checkbox"]:disabled + label {
      opacity: 0.65; }
      .checkbox input[type="checkbox"]:disabled + label::before {
        background-color: #eeeeee;
        cursor: not-allowed; }
  .checkbox.checkbox-circle label::before {
    border-radius: 50%; }
  .checkbox.checkbox-inline {
    margin-top: 0; }

.checkbox-primary input[type="checkbox"]:checked + label::before {
  background-color: #428bca;
  border-color: #428bca; }
.checkbox-primary input[type="checkbox"]:checked + label::after {
  color: #fff; }

.checkbox-danger input[type="checkbox"]:checked + label::before {
  background-color: #d9534f;
  border-color: #d9534f; }
.checkbox-danger input[type="checkbox"]:checked + label::after {
  color: #fff; }

.checkbox-info input[type="checkbox"]:checked + label::before {
  background-color: #5bc0de;
  border-color: #5bc0de; }
.checkbox-info input[type="checkbox"]:checked + label::after {
  color: #fff; }

.checkbox-warning input[type="checkbox"]:checked + label::before {
  background-color: #f0ad4e;
  border-color: #f0ad4e; }
.checkbox-warning input[type="checkbox"]:checked + label::after {
  color: #fff; }

.checkbox-success input[type="checkbox"]:checked + label::before {
  background-color: #5cb85c;
  border-color: #5cb85c; }
.checkbox-success input[type="checkbox"]:checked + label::after {
  color: #fff; }

.radio {
  padding-left: 20px; }
  .radio label {
    display: inline-block;
    position: relative;
    padding-left: 5px; }
    .radio label::before {
      content: "";
      display: inline-block;
      position: absolute;
      width: 17px;
      height: 17px;
      left: 0;
      margin-left: -20px;
      border: 1px solid #cccccc;
      border-radius: 50%;
      background-color: #fff;
      -webkit-transition: border 0.15s ease-in-out;
      -o-transition: border 0.15s ease-in-out;
      transition: border 0.15s ease-in-out; }
    .radio label::after {
      display: inline-block;
      position: absolute;
      content: " ";
      width: 11px;
      height: 11px;
      left: 3px;
      top: 3px;
      margin-left: -20px;
      border-radius: 50%;
      background-color: #555555;
      -webkit-transform: scale(0, 0);
      -ms-transform: scale(0, 0);
      -o-transform: scale(0, 0);
      transform: scale(0, 0);
      -webkit-transition: -webkit-transform 0.1s cubic-bezier(0.8, -0.33, 0.2, 1.33);
      -moz-transition: -moz-transform 0.1s cubic-bezier(0.8, -0.33, 0.2, 1.33);
      -o-transition: -o-transform 0.1s cubic-bezier(0.8, -0.33, 0.2, 1.33);
      transition: transform 0.1s cubic-bezier(0.8, -0.33, 0.2, 1.33); }
  .radio input[type="radio"] {
    opacity: 0; }
    .radio input[type="radio"]:focus + label::before {
      outline: thin dotted;
      outline: 5px auto -webkit-focus-ring-color;
      outline-offset: -2px; }
    .radio input[type="radio"]:checked + label::after {
      -webkit-transform: scale(1, 1);
      -ms-transform: scale(1, 1);
      -o-transform: scale(1, 1);
      transform: scale(1, 1); }
    .radio input[type="radio"]:disabled + label {
      opacity: 0.65; }
      .radio input[type="radio"]:disabled + label::before {
        cursor: not-allowed; }
  .radio.radio-inline {
    margin-top: 0; }

.radio-primary input[type="radio"] + label::after {
  background-color: #428bca; }
.radio-primary input[type="radio"]:checked + label::before {
  border-color: #428bca; }
.radio-primary input[type="radio"]:checked + label::after {
  background-color: #428bca; }

.radio-danger input[type="radio"] + label::after {
  background-color: #d9534f; }
.radio-danger input[type="radio"]:checked + label::before {
  border-color: #d9534f; }
.radio-danger input[type="radio"]:checked + label::after {
  background-color: #d9534f; }

.radio-info input[type="radio"] + label::after {
  background-color: #5bc0de; }
.radio-info input[type="radio"]:checked + label::before {
  border-color: #5bc0de; }
.radio-info input[type="radio"]:checked + label::after {
  background-color: #5bc0de; }

.radio-warning input[type="radio"] + label::after {
  background-color: #f0ad4e; }
.radio-warning input[type="radio"]:checked + label::before {
  border-color: #f0ad4e; }
.radio-warning input[type="radio"]:checked + label::after {
  background-color: #f0ad4e; }

.radio-success input[type="radio"] + label::after {
  background-color: #5cb85c; }
.radio-success input[type="radio"]:checked + label::before {
  border-color: #5cb85c; }
.radio-success input[type="radio"]:checked + label::after {
  background-color: #5cb85c; }
</style>
<div class="content-section-a">
	<div class="container bootstrap snippet">
	    <div class="row">
			<div class="col-md-12">
			    <div class="blog-comment">
					<h3 class="text-success">					
					Message
					<c:choose>
						<c:when test="${DISC == 'sent' }">
							Sent messages
						</c:when>
						<c:otherwise>
							Received messages
						</c:otherwise>
					</c:choose>		
					</h3>
					<div class="btn-group">
								<button type="button" class="btn btn-success" onclick="javascript:location.href='/message/'">Received messages</button>
								<button type="button" class="btn btn-warning" onclick="javascript:location.href='/message/?DISC=sent'">Sent messages</button>
								<button type="button" class="btn btn-primary" onclick="javascript:location.href='/message/send'">Write</button>
					</div>
					<form action="/message/" class="form-horizontal" style="width: 30%; float: right;" method="post">
						<div class="col-xs-12">
						    <div class="input-group">
				                <div class="input-group-btn search-panel">
				                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
				                    <c:choose>
										<c:when test="${DISC == 'sent' }">
											<c:if test="${empty searchType}">
												<span id="type">receiver</span> <span class="caret"></span>	
											</c:if>
											<c:if test="${!empty searchType}">
												<span id="type">${searchType}</span> <span class="caret"></span>
											</c:if>
										</c:when>
										<c:otherwise>
											<c:if test="${empty searchType}">
												<span id="type">sender</span> <span class="caret"></span>
											</c:if>
											<c:if test="${!empty searchType}">
												<span id="type">${searchType}</span> <span class="caret"></span>
											</c:if>
										</c:otherwise>
									</c:choose>
				                    		
				                    </button>
				                    <ul class="dropdown-menu" role="menu">
				                    <c:choose>
										<c:when test="${DISC == 'sent' }">
											<li><a href="#receiver">receiver</a></li>	
										</c:when>
										<c:otherwise>
											<li><a href="#sender">sender</a></li>
										</c:otherwise>
									</c:choose>					                    				                    	
										<li><a href="#content">content</a></li>
										<li><a href="#subject">subject</a></li>
				                    </ul>
				                </div>
				                <c:choose>
										<c:when test="${DISC == 'sent' }">
											<c:if test="${empty searchType}">											
												<input type="hidden" name="searchType" value ="receiver" id="search_type">
											</c:if>
											<c:if test="${!empty searchType}">
												<input type="hidden" name="searchType" value ="${searchType}" id="search_type">
											</c:if>				                			
										</c:when>
										<c:otherwise>
											<c:if test="${empty searchType}">
												<input type="hidden" name="searchType" value ="sender" id="search_type">
											</c:if>
											<c:if test="${!empty searchType}">
				                				<input type="hidden" name="searchType" value ="${searchType }" id="search_type">
				                			</c:if>
										</c:otherwise>
								</c:choose>
				                
				                <input type="hidden" name="page" value="${currentPage}">
				                <input type="hidden" name="DISC" value="${DISC}">
				                	<c:if test="${empty keyword}">
				                		<input type="text" class="form-control" name="keyword" value="">
				                	</c:if>
				                	<c:if test="${!empty keyword}">
				                		<input type="text" class="form-control" name="keyword" value="${keyword}">
				                	</c:if>
				                <span class="input-group-btn">
				                    <button class="btn btn-default" type="submit"><i class="fa fa-search"></i></button>
				                </span>
				            </div>
				        </div>
					</form>
	                <hr/>
	                <div style="padding-right:10px;">
	                	
						<div class="checkbox checkbox-warning">						
						<a class="btn btn-danger" id="deleteBtn" style="margin-right:20px;"><i class="fa fa-trash-o fa-lg"></i> Delete</a>
                        <input id="deleteAll" type="checkbox">
                        <label for="deleteAll">
                            All Select
                        </label>
                    	</div>
					</div>
					<ul class="comments" style="clear:both;">
					<c:choose>
					   <c:when test="${totalCount > 0}">
							<c:forEach var="messageDTO" items="${messageDTOs }" varStatus="status">
							<li class="clearfix">
							<c:choose>
								<c:when test="${DISC == 'sent' }">
									<img src="${root }/profile/${messageDTO.receiver_profile}" class="avatar" alt="">
								</c:when>
								<c:otherwise>
									<img src="${root }/profile/${messageDTO.sender_profile}" class="avatar" alt="">
								</c:otherwise>
							</c:choose>							  
							  <div class="post-comments">
							      <p class="meta"><fmt:formatDate value="${messageDTO.date_sent}" pattern=" HH:mm MMM dd yyyy" /> &nbsp;
							      	<div class="dropdown" style="display:inline-block;">
							      	<button class="btn btn-default dropdown-toggle" style="border:none;" type="button" id="menu1" data-toggle="dropdown">
							      	<c:choose>
										<c:when test="${DISC == 'sent' }">
											<c:out value="${messageDTO.receiver_nick }"/>(<c:out value="${messageDTO.receiver }"/>)									
											</button>	
										    <ul class="dropdown-menu" role="menu" aria-labelledby="menu1">
										      <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="popupOpen('/')">Profile</a></li>
										      <li role="presentation"><a role="menuitem" tabindex="-1" href="/message/send?sendto=${messageDTO.receiver}">Reply</a></li>								      
										    </ul>
										</c:when>
										<c:otherwise>
											<c:out value="${messageDTO.sender_nick }"/>(<c:out value="${messageDTO.sender }"/>)
											</button>	
										    <ul class="dropdown-menu" role="menu" aria-labelledby="menu1">
										      <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Profile</a></li>
										      <li role="presentation"><a role="menuitem" tabindex="-1" href="/message/send?sendto=${messageDTO.sender}">Reply</a></li>								      
										    </ul>
										</c:otherwise>
									</c:choose>		
    								</button>	  
							      	</div> says : <b style="font-size:16px;">${messageDTO.subject}</b>
							      		<div class="checkbox checkbox-success">
					                        <input id="checkbox${messageDTO.num}" num="${messageDTO.num}" type="checkbox">
					                        <label for="checkbox${messageDTO.num}">
					                            Select
					                        </label>
							              </div>						      					      	
							      </p>
							      <p>
							      	${messageDTO.content}
							          
							      </p>
							  </div>
							</li>
							</c:forEach>
						</c:when>
						<c:otherwise>								         	
						</c:otherwise>
					</c:choose>
					
					</ul>
					
					<nav class="my-4" align="center">
					    <ul class="pagination pagination-circle pg-blue mb-0">
					        <li class="page-item"><a class="page-link" href="/message/?page=1&DISC=${DISC}">&laquo;</a></li>
					        <c:if test="${startPage ne 1 }">
					        <li class="page-item">
					            <a class="page-link" href="/message/?page=${startPage-1 }&DISC=${DISC}" aria-label="Previous">
					                <span aria-hidden="true">&lt;</span>
					                <span class="sr-only">Previous</span>
					            </a>
					        </li>
					        </c:if>
							<c:forEach begin="${startPage}" end="${endPage}" var="page">
										<li class="page-item ${page eq currentPage ? 'active ' : '' }">						
											<a class="page-link" href="/message/?page=${page }&DISC=${DISC}"><c:out value="${page}"/></a>
										</li>
							</c:forEach>	
					        <c:if test="${totalPage ne endPage }">
					        <li class="page-item">
					            <a class="page-link" href="/message/?page=${endPage+1}&DISC=${DISC}" aria-label="Next">
					                <span aria-hidden="true">&gt;</span>
					                <span class="sr-only">Next</span>
					            </a>
					        </li>
					        </c:if>
					        <li class="page-item"><a class="page-link" href="/message/?page=${totalPage}&DISC=${DISC}">&raquo;</a></li>
					    </ul>
					</nav>
				</div>
			</div>
		</div>
	</div>	
</div>
</div>