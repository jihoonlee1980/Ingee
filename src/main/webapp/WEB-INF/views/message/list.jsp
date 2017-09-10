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
	border:1px solid #9a7e61
}
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
					<ul class="comments">
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
							      	<a href="#">
							      	<c:choose>
										<c:when test="${DISC == 'sent' }">
											<c:out value="${messageDTO.receiver_nick }"/>(<c:out value="${messageDTO.receiver }"/>)
										</c:when>
										<c:otherwise>
											<c:out value="${messageDTO.sender_nick }"/>(<c:out value="${messageDTO.sender }"/>)
										</c:otherwise>
									</c:choose>							      	
							      	</a> says : <b style="font-size:16px;"><c:out value="${messageDTO.subject}"/></b>							      	
							      </p>
							      <p>
							      	<c:out value="${messageDTO.content}"/>
							          
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