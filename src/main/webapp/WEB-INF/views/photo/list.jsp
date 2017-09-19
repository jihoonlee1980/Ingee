<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ page session="true"%>
<script src="/assets/jquery-3.2.1.min.js"></script>
<c:set var="root_" value="<%=request.getContextPath() %>" />
<c:set var="root" value="${root_}/resources" />
<link href="/assets/css/bootstrap.css?ver=2" rel="stylesheet">
<style>
a.list-group-item {
    height:auto;
    min-height:220px;
}
a.list-group-item.active small {
    color:#fff;
}
div.input-group{
	width: 100% !important;
}
@media(max-width: 768px){
	.search-form{
		width: 100%;
		margin: 0;
		padding: 0;
	}
}
</style>
<script type="text/javascript">
	$(function(){
		document.getElementById("list_div").oncontextmenu = function(e){
			alert("Right-click is restricted.");
			return false;
		}
		
		$('.search-panel .dropdown-menu').find('a').click(function(e) {
			e.preventDefault();
			var param = $(this).attr("href").replace("#","");
			var concept = $(this).text();
			$('.search-panel span#type').text(concept);
			$('.input-group #search_type').val(param);
		});
	});
	
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
	
	function boardInsert(){
		var isInsert = true;
		
		isInsert = maxLengthCheck($("#subject").val(), 300, "Subject");
		if(isInsert)
			isInsert = maxLengthCheck($("#content").val(), 2000, "Content");
		
		return isInsert;
	}
	
	function validateFile(obj){
		var maxSize = 1024 * 1024 * 10;
		var fileSize = obj.files[0].size;
		var fileName = obj.files[0].name;
		var fileExtension = fileName.substring(fileName.lastIndexOf(".") + 1);
		var imgExtension = ["png", "jpg", "jpeg", "bmp", "gif"];
		
		if(!imgExtension.includes(fileExtension.toLowerCase())){
			alert('You must upload the file extension name as one of “jpeg”," jpg "," bmp "," png ", or “ gif ”.');
			obj.value = "";
			return false;
		}
		
		if(fileSize > maxSize){
			alert("Please upload file size less than 10MB.");
			obj.value = "";
			return false;
		}
	}
</script>
<div class="content-section-a" style="margin-top: 10px; min-height: 750px;">
	<div class="container">
		<div class="event-row" id="div_event">
			<div class="well">
		        <h1 class="text-center">Photo</h1>
		        <div class="list-group" id="list_div">
		        	<c:if test="${totalCount > 0 }">
			        	<c:forEach items="${boardList}" var="boardDTO" varStatus="status">
			        		<c:if test="${param.search_type eq null}">
			        			<c:set var="href" value="/board/photo/${boardDTO.num }?page=${currentPage}"/>
			        		</c:if>
			        		<c:if test="${param.search_type ne null}">
			        			<c:set var="href" value="/board/photo/${boardDTO.num }?page=${currentPage}&search_type=${param.search_type }&keyword=${param.keyword }"/>
			        		</c:if>
			        		
			        		<a href="${href }" class="list-group-item">
			        			<c:if test="${boardDTO.saved_filename != 'NO' }">
				                	<div class="media col-md-3" style="margin-top: 2%">
					                    <figure class="pull-left">
				                        	<img class="media-object img-rounded img-responsive" src="${root}/board/${boardDTO.saved_filename}" alt="${boardDTO.subject}" style="max-height: 180px; max-width: 250px;">
				                    	</figure>
				                	</div>
			                	</c:if>
			                	<div class="col-md-${boardDTO.saved_filename != 'NO' ? 6 : 9}" style="margin-top: 2%">
				                    <h4 class="list-group-item-heading"><span style="font-size: 10pt; font-weight: 600; color: #e69b0b"></span>${boardDTO.subject}<span style="font-size: 10pt; font-weight: 600; color: red">&nbsp;&nbsp;&nbsp;[ ${boardDTO.comment_count } ]</span></h4>
			                    	<hr style="width: 100%; height: 2px; background: #777; margin-top: 5px 5px;">
			                    	 <p class="list-group-item-text" style="max-height: 70px; word-break: break-all; white-space: pre-line; overflow: hidden;">${boardDTO.content}</p>
			                	</div>
			                	<div class="col-md-3 text-center" style="margin-top: 2%">
				                    <h4> ${boardDTO.readcount} <small> Views </small></h4>
			                    	<br>
			                    	<p> Posted by: ${boardDTO.writer}</p>
			                    	<br>
			                    	<p><fmt:formatDate value="${boardDTO.writedate }" pattern="HH:mm, MMM dd, YYYY"/></p>
			                	</div>
			          		</a>
			        	</c:forEach>
			        </c:if>
			        <c:if test="${totalCount == 0 }">
			        	<c:if test="${param.search_type ne null }">
				        	<div class="media col-md-12" style="margin-top: 2%; text-align: center;">
				        		<span style="font-size: 20pt; font-weight: 700; color: #999">No results founded with "${param.keyword }".</span>
				        	</div>
			        	</c:if>
			        	<c:if test="${param.search_type eq null }">
				        	<div class="media col-md-12" style="margin-top: 2%; text-align: center;">
				        		<span style="font-size: 20pt; font-weight: 700; color: #999">No bulletins.</span>
				        	</div>
			        	</c:if>
			        </c:if>  
		        </div>
		        <!-- pagination start -->
		        <div style="width:100%;" align="center">
					<ul class="pagination">
						<c:if test="${startPage > 1}">
							<c:if test="${param.search_type ne null }">
								<li><a href="/board/photo/list?page=${startPage-1}&search_type=${param.search_type}&keyword=${param.keyword}">&lt;</a></li>
							</c:if>
							<c:if test="${param.search_type eq null }">
								<li><a href="/board/photo/list?page=${startPage - 1}">&lt;</a></li>
							</c:if>
						</c:if>
						<c:forEach begin="${startPage}" end="${endPage}" var="page">
							<c:if test="${param.search_type ne null }">
								<li ${page eq currentPage ? "class='active'" : "" }>						
									<a href="/board/photo/list?page=${page}&search_type=${param.search_type}&keyword=${param.keyword}">
										${page}
									</a>
								</li>
							</c:if>
							<c:if test="${param.search_type eq null  }">
								<li ${page eq currentPage ? "class='active'" : "" }>						
									<a href="/board/photo/list?page=${page}">
										${page}
									</a>
								</li>
							</c:if>
						</c:forEach>
						<c:if test="${totalPage ne endPage}">
							<c:if test="${param.search_type ne null }">
								<li><a href="/member/search?page=${endPage + 1}&sort=${param.sort}&search_type=${param.search_type}&keyword=${param.keyword}">&gt;</a></li>
							</c:if>
							<c:if test="${param.search_type eq null }">
								<li><a href="/board/photo/list?page=${endPage + 1}">&gt;</a></li>
							</c:if>
						</c:if>
					</ul>
				</div>
				<!-- pagination end/search start -->
				<div style="width: 100%; min-height: 50px;">
					<form action="/board/photo/list" class="form-horizontal search-form col-md-6">
						<div class="col-md-12">
						    <div class="input-group">
				                <div class="input-group-btn search-panel">
				                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
				                    	<c:if test="${param.search_type eq null }">
				                    		<span id="type">Writer</span> <span class="caret"></span>
				                    	</c:if>
				                    	<c:if test="${param.search_type ne null }">
				                    		<span id="type" style="text-transform: capitalize;">${param.search_type }</span> <span class="caret"></span>
				                    	</c:if>
				                    </button>
				                    <ul class="dropdown-menu" role="menu" style="text-transform: capitalize;">
										<li><a href="#writer">writer</a></li>
										<li><a href="#subject">subject</a></li>
										<li><a href="#content">content</a></li>
				                    </ul>
				                </div>
				                <c:if test="${param.search_type eq null }">
				                	<input type="hidden" name="search_type" value="writer" id="search_type">
				                </c:if>
								<c:if test="${param.search_type ne null }">
				                	<input type="hidden" name="search_type" value="${param.search_type }" id="search_type">
				                </c:if>
				                <input type="hidden" name="page" value="${param.page }">
				                <input type="text" class="form-control" name="keyword" value="${param.keyword }">
				                <span class="input-group-btn">
				                    <button class="btn btn-default" type="submit"><i class="fa fa-search"></i></button>
				                </span>
				            </div>
				        </div>
					</form>
					<c:if test="${isLogin ne null}">
						<div class="col-md-6" align="right">
							<a class="btn btn-default btn-sm" data-toggle="modal" data-target="#write" data-original-title>Write</a>
						</div>
					</c:if>
				</div>
				<!-- search end/write start -->
				<!-- write end -->
			</div>
		</div>
		<!-- write modal satrt -->
		<div class="modal fade" id="write" tabindex="-1" role="dialog" aria-labelledby="contactLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="well well-sm">
					<form class="form-horizontal" action="/board/photo/insert" method="post" enctype="multipart/form-data" onsubmit="return boardInsert();">
						<fieldset>
							<legend class="text-center"><h1>Photo</h1></legend>
							<div class="form-group">
								<div class="input-group">
									<label class="col-md-2 control-label">Subject</label>
									<div class="col-md-9">
										<input id="subject" name="subject" type="text" placeholder="subject" class="form-control" required="required">
									</div>
								</div>
							</div>
							<div class="form-group">
								<div class="input-group">
									<label class="col-md-2 control-label">Content</label>
									<div class="col-md-9">
										<textarea class="form-control" rows="10" cols="" id="content" name="content" required="required" style="width: 100%;"></textarea>
									</div>
								</div>
							</div>
							<div class="form-group">
								<div class="input-group">
									<label class="col-md-2 control-label">Image</label>
									<div class="col-md-9">
										<input type="file" class="form-control" name="upload_file" id="upload_file" required="required" onchange="validateFile(this)">
										<span class="help-block" style="padding-left: 5px; color: red;">※ When upload photos using camera please take a picture horizontally.</span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<div class="input-group">
									<label class="col-md-2 control-label">Source</label>
									<div class="col-md-9">
										<input id="source" name="source" type="text" placeholder="source" class="form-control" required="required">
									</div>
								</div>
							</div>
							<div class="panel-footer">
								<input type="hidden" name="writer" value="${loginNick }">
	                            <input type="submit" class="btn btn-success" value="OK"/>
	                            <input type="reset" class="btn btn-danger" value="Clear" />
	                            <button style="float: right;" type="button" class="btn btn-default btn-close" data-dismiss="modal">Close</button>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
		<!-- write modal end -->
	</div><!--  container end -->
</div>