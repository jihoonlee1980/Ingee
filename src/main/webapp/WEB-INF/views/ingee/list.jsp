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
</style>
<script type="text/javascript">
	$(function(){
		document.getElementById("list_div").oncontextmenu = function(e){
			alert("Right-click is restricted.");
			return false;
		}
	});
</script>
<div class="content-section-a" style="min-height: 750px;">
	<div class="container">
		<div class="event-row" id="div_event">
			<div class="well">
		        <h1 class="text-center">In Gee</h1>
		        <div class="list-group" id="list_div">
		        	<c:if test="${totalCount > 0 }">
			        	<c:forEach items="${boardList}" var="boardDTO" varStatus="status">
			        		<a href="/board/ingee/${boardDTO.num }?page=${currentPage}" class="list-group-item">
			        			<c:if test="${boardDTO.saved_filename != 'NO' }">
				                	<div class="media col-md-3" style="margin-top: 2%">
					                    <figure class="pull-left">
				                        	<img class="media-object img-rounded img-responsive" src="${root}/board/${boardDTO.saved_filename}" alt="${boardDTO.subject}" style="max-height: 180px; max-width: 250px;">
				                    	</figure>
				                	</div>
			                	</c:if>
			                	<div class="col-md-${boardDTO.saved_filename != 'NO' ? 6 : 9}" style="margin-top: 2%">
				                    <h4 class="list-group-item-heading"><span style="font-size: 10pt; font-weight: 600; color: #e69b0b"></span><c:out value="${boardDTO.subject}"/><span style="font-size: 10pt; font-weight: 600; color: red">&nbsp;&nbsp;&nbsp;[ ${boardDTO.comment_count } ]</span></h4>
			                    	<hr style="width: 100%; height: 2px; background: #777; margin-top: 5px 5px;">
			                    	 <p class="list-group-item-text" style="max-height: 70px; word-break: break-all; white-space: pre-line; overflow: hidden;"> <c:out value="${boardDTO.content}"/> </p>
			                	</div>
			                	<div class="col-md-3 text-center" style="margin-top: 2%">
				                    <h4> <c:out value="${boardDTO.readcount}"/> <small> Views </small></h4>
			                    	<br>
			                    	<p> Posted by: <c:out value="${boardDTO.writer}"/></p>
			                    	<br>
			                    	<p><fmt:formatDate value="${boardDTO.writedate}" pattern="yyyy-MM-dd HH:mm"/></p>
			                	</div>
			          		</a>
			        	</c:forEach>
			        </c:if>
			        <c:if test="${totalCount == 0 }">
			        	<div class="media col-md-12" style="margin-top: 2%; text-align: center;">
			        		<span style="font-size: 20pt; font-weight: 700; color: #999">No bulletins.</span>
			        	</div>
			        </c:if>  
		        </div>
		        <div style="width:100%;" align="center">
					<ul class="pagination">
						<c:if test="${startPage > 1}">
							<li><a href="/board/ingee/list?page=${startPage - 1}">&lt;</a></li>
						</c:if>
						<c:forEach begin="${startPage}" end="${endPage}" var="page">
							<li ${page eq currentPage ? "class='active'" : "" }>						
								<a href="/board/ingee/list?page=${page}">
									<c:out value="${page}"/>
								</a>
							</li>
						</c:forEach>
						<c:if test="${totalPage ne endPage}">
							<li><a href="/board/ingee/list?page=${endPage + 1}">&gt;</a></li>
						</c:if>
					</ul>
				</div>
				<c:if test="${not empty isLogin }">
<%-- 					<c:if test="${isIngee ne null}"> --%>
					<c:if test="${isAdmin ne null}">
						<div align="right">
							<a class="btn btn-default btn-sm" data-toggle="modal" data-target="#write" data-original-title>Write</a>
						</div>
					</c:if>
				</c:if>
			</div>
		</div>
		<div class="modal fade" id="write" tabindex="-1" role="dialog" aria-labelledby="contactLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="well well-sm">
					<form class="form-horizontal" action="/board/ingee/insert" method="post" enctype="multipart/form-data">
						<fieldset>
							<legend class="text-center"><h1>In Gee</h1></legend>
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
										<textarea class="form-control" rows="10" cols="" name="content" required="required" style="width: 100%;"></textarea>
									</div>
								</div>
							</div>
							<div class="form-group">
								<div class="input-group">
									<label class="col-md-2 control-label">Image</label>
									<div class="col-md-9">
										<input type="file" class="form-control" name="upload_file" id="upload_file">
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
	</div><!--  container end -->
</div>