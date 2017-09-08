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
	$('.star').on('click', function () {
      $(this).toggleClass('star-checked');
    });

    $('.ckbox label').on('click', function () {
      $(this).parents('tr').toggleClass('selected');
    });

    $('.btn-filter').on('click', function () {
      var $target = $(this).data('target');
      if ($target != 'all') {
        $('.table tr').css('display', 'none');
        $('.table tr[data-status="' + $target + '"]').fadeIn('slow');
      } else {
        $('.table tr').css('display', 'none').fadeIn('slow');
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
					<h3 class="text-success">Message</h3>
					<div class="btn-group">
								<button type="button" class="btn btn-success" onclick="javascript:location.href='/message/'">받은쪽지함</button>
								<button type="button" class="btn btn-warning" onclick="javascript:location.href='/message/?DISC=sent'">보낸쪽지함</button>
								<button type="button" class="btn btn-primary" onclick="javascript:location.href='/message/send'">쪽지쓰기</button>
					</div>					
	                <hr/>
					<ul class="comments">
					<c:choose>
					   <c:when test="${totalCount > 0}">
							<c:forEach var="messageDTO" items="${messageDTOs }" varStatus="status">
							<li class="clearfix">
							<c:choose>
								<c:when test="${DISC == 'recv' }">
									<img src="${root }/profile/${messageDTO.receiver_profile}" class="avatar" alt="">
								</c:when>
								<c:otherwise>
									<img src="${root }/profile/${messageDTO.sender_profile}" class="avatar" alt="">
								</c:otherwise>
							</c:choose>
							  
							  <div class="post-comments">
							      <p class="meta"><fmt:formatDate value="${messageDTO.date_sent}" pattern=" HH:mm MMM dd yyyy" /> &nbsp;
							      	<a href="#">${messageDTO.sender_nick}(${messageDTO.sender})</a> says : <b style="font-size:16px;">${messageDTO.subject}</b>							      	
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