<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ page session="true"%>
<script src="/assets/jquery-3.2.1.min.js"></script>
<link href="${root }/css/sweetalert.css" rel="stylesheet">
<script src="${root }/js/sweetalert-dev.js"></script>
<script src="${root }/js/sweetalert.min.js"></script>
<link href="/assets/css/bootstrap.css?ver=2" rel="stylesheet">
<c:set var="root_" value="<%=request.getContextPath() %>" />
<c:set var="root" value="${root_}/resources" />
<style>
.span-date{
	margin-left: 10px;
	line-height: 36px;
	vertical-align: middle;
}

#comments-list>li{
	display : none;
}

#comments-list>li.active{
	display : block;
}

#comment-pagination li a{
	cursor: pointer;
}

#comment-pagination>li{
	display : none;
}
#comment-pagination>li.show{
	display : inline !important;
}

div.input-group{
	width: 100% !important;
}
.remove-file{
	text-decoration: line-through;
	color: #999;
}
</style>
<script type="text/javascript">
	$(function(){
		$(document).on("click", ".updateReplyForm", function(){
			var content_div = $(this).parents().siblings(".comment-content");
			var current_content = $(this).siblings("p.comment-hidden").text();
			var num = $(this).attr("num");
			var board_num = $(this).attr("board_num");
			var page = $(this).attr("page");
			
			if($(this).hasClass("active")){
				$(this).css("color", "#a6a6a6");
				$(this).removeClass("active");
				content_div.empty();
				content_div.text(current_content);
			} else {
				$(this).css("color", "#03658c");
				$(this).addClass("active");
				var html = "<textarea rows='4' cols='' style='width: 100%'>";
				html += current_content;
				html += "</textarea>";
				html += "<div style='width: 100%' align='right'><button type='button' class='btn btn-sm btn-success updateBtn'>Edit</button><button type='button' class='btn btn-sm btn-default updateCancel'>Cancel</button></div>";
				$(document).on("click", ".updateBtn", function(){
					var update_btn = $(this);
					swal({
						title : "Are you sure you want to edit the comment?",
						type : "warning",
						showCancelButton : true,
						confirmButtonColor : "#DD6B55",
						confirmButtonText : "YES",
						cancelButtonText : "NO",
						closeOnConfirm : false,
						closeOnCancel : false
					}, function(isConfirm) {
						if (isConfirm) {
							var new_content = update_btn.parents().siblings("textarea").val();
							location.href = "/comment/video/update?num=" + num + "&content=" + new_content + "&board_num=" + board_num + "&page=" + page;
						} else {
							swal("Cancel", "The editing the comment is cancelled.", "error");
						}
					});
				});
				
				$(document).on("click", ".updateCancel", function(){
					var content_div = $(this).parents(".comment-content");
					content_div.empty();
					content_div.text(content_div.siblings(".comment-head").children("p.comment-hidden").text());
					content_div.siblings(".comment-head").children("i.fa-pencil-square-o").css("color", "#a6a6a6");
					content_div.siblings(".comment-head").children("i.fa-pencil-square-o").removeClass("active");
				});
				content_div.html(html);
			}
		});
	});
	
	function commnetPagination(obj, perPage, perBlock, totalPage){
		var liLength = $("#comments-list li").length;
		$(obj).siblings().removeClass("active");
		$(obj).addClass("active");
		
		$("#comments-list li").removeClass("active");
		var currentPage = parseInt($(obj).find("a").text()); 
		var startNum = (currentPage - 1) * perPage;
		var endNum = startNum + perPage;
		endNum = endNum > liLength ? liLength : endNum;
		$("#comments-list li").slice(startNum, endNum).addClass("active");
		
		var startIndex = currentPage - parseInt(perBlock/2) - 1;
		
		if(startIndex < 0)
			startIndex = 0;
		
		var endIndex = startIndex + perBlock;
		
		if(endIndex > totalPage)
			endIndex = totalPage;
		
		if((endIndex - startIndex) < perBlock)
			startIndex = endIndex - perBlock;
		
		if(startIndex < 0)
			startIndex = 0;
		
		$("#comment-pagination>li").removeClass("show");
		$("#comment-pagination>li").slice(startIndex, endIndex).addClass("show")
	}
	
	function deleteCheck(num, page) {
		swal({
			title : "Are you sure you want to delete the bulletin?",
			text : "The bulletin deleted cannot be recovered.",
			type : "warning",
			showCancelButton : true,
			confirmButtonColor : "#DD6B55",
			confirmButtonText : "YES",
			cancelButtonText : "NO",
			closeOnConfirm : false,
			closeOnCancel : false,
			allowOutsideClick: true
		}, function(isConfirm) {
			if (isConfirm) {
				swal("Complete", "The bulletin is deleted", "success");
				location.href = "/board/video/delete?num=" + num + "&page=" + page;
			} else {
				swal("Cancel", "The editing the bulletin is cancelled.", "error");
			}
		});
	}
	
	function getReply(obj, board_num, comment_num, isLogin, loginNick, loggedInProfile, board_writer, page){
		if($(obj).hasClass("active")){
			$(obj).removeClass("active");
			$(obj).css("color", "#a6a6a6");
			$(obj).parents("li").children("ul").remove();
		} else {
			$(obj).addClass("active");
			$(obj).css("color", "#03658c");
			
			var html = "";
			html += "<ul class='comments-list reply-list'>";
			
			if(isLogin != ""){
				html += "<li>";
				html += "<form action='/comment/video/insert' class='reply-input' method='get'>";
				html += "<div class='reply-input-avatar'>";
				html += "<img src='${root }/profile/" + loggedInProfile + "' alt=''>";
				html += "</div>";
				html += "<div class='reply-textarea-div'>";
				html += "<textarea class='reply-textarea' style='width: 100%; height: 75px' name='content' required='required' placeholder='  As we all fans of gorgeous InGee, let`s encourage all together while keeping netiquette.'></textarea>";
				html += "</div>";
				html += "<div style='background: #fff;' align='right'>";
				html += "<input type='hidden' name='board_num' value='" + board_num + "'>";
				html += "<input type='hidden' name='comment_num' value='" + comment_num + "'>";
				html += "<input type='hidden' name='writer' value='" + loginNick + "'>";
				html += "<input type='hidden' name='page' value='" + page + "'>";
				html += "<button type='submit' class='btn btn-default btn-sm'>Input</button>";
				html += "</div>";
				html += "</form>";
				html += "</li>";
			}
	
			$.ajax({
				url : "/comment/video/reply/list",
				type : "get",
				data : {"comment_num" : comment_num},
				dataType : "json",
				async: false,
				success : function(data){
					//document.write(JSON.stringify(data.commentDTO));
					var profile_files = data.profile_files;
					
					for (var i = 0; i < data.commentDTO.length; i++){
						var commentDTO = data.commentDTO[i];
						
						html += "<li>";
						html += "<div class='comment-avatar'><img src='${root}/profile/" + profile_files[i] + "' alt=''></div>";
						html += "<div class='comment-box'>";
						html += "<div class='comment-head'>";
						html += "<h6 class='comment-name" + (board_writer == commentDTO.writer ? " by-author" : "") + "'>" + commentDTO.writer + "</h6>";
						html += "<span class='span-date'>" + formatDate(commentDTO.writetime) +  "</span>";
						if(commentDTO.writer == loginNick){
							html += "<i class='fa fa-trash' onclick='deleteReply(this)' num='" + commentDTO.num + "' comment_num='" + comment_num + "' board_num='" + board_num +"' page='" + page + "'></i>";
							html += "<i class='fa fa-pencil-square-o updateReplyForm' num='" + commentDTO.num + "' board_num='" + board_num + "' page='" + page + "'></i>";
							html += "<p class='comment-hidden' style='display: none;'>" + commentDTO.content + "</p>";
						}
						html += "</div>";
						html += "<div class='comment-content'><p style= 'word-break: break-all; white-space: pre-line;'>";
						html += commentDTO.content;
						html += "</p></div>";
						html += "</div>";
						html += "</li>";
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
			html += "</ul>";
		
			$(obj).parents("li").append(html);
		}
	}
	
	function formatDate(date) {
		var m_names = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
		var d = new Date(date);
		var year = d.getYear() - 100;
		var month = m_names[d.getMonth()];
		var day = "" + d.getDate();
		var hour = "" + d.getHours();
		var minutes = "" + d.getMinutes();
		
		if (day.length < 2)
			day = "0" + day;
		if (hour.length < 2)
			hour = "0" + hour;
		if (minutes.length < 2)
			minutes = "0" + minutes;
		
		return hour + ":" + minutes + ", " + month + " " + day + ", " + year;
	}
	
	function updateCommentForm(obj, num, board_num, page){
		var content_div = $(obj).parents().siblings(".comment-content");
		var current_content = $(obj).siblings("p.comment-hidden").text();
		
		if($(obj).hasClass("active")){
			$(obj).css("color", "#a6a6a6");
			$(obj).removeClass("active");
			content_div.empty();
			content_div.text(current_content);
		} else {
			$(obj).css("color", "#03658c");
			$(obj).addClass("active");
			var html = "<textarea rows='4' cols='' style='width: 100%'>";
			html += current_content;
			html += "</textarea>";
			html += "<div style='width: 100%' align='right'><button type='button' class='btn btn-sm btn-success' id='updateBtn" + num + "'>Edit</button><button type='button' class='btn btn-sm btn-default' id='updateCancel" + num + "''>Cancel</button></div>";
			
			$(document).on("click", "#updateBtn" + num, function(){
				var update_btn = $(this);
				swal({
					title : "Are you sure you want to edit the comment?",
					type : "warning",
					showCancelButton : true,
					confirmButtonColor : "#DD6B55",
					confirmButtonText : "YES",
					cancelButtonText : "NO",
					closeOnConfirm : false,
					closeOnCancel : false
				}, function(isConfirm) {
					if (isConfirm) {
						var new_content = update_btn.parents().siblings("textarea").val();
						location.href = "/comment/video/update?num=" + num + "&content=" + new_content + "&board_num=" + board_num + "&page=" + page;
					} else {
						swal("Cancel", "The editing the comment is cancelled.", "error");
					}
				});
			});
			
			$(document).on("click", "#updateCancel" + num, function(){
				var content_div = $(this).parents(".comment-content");
				content_div.empty();
				content_div.text(content_div.siblings(".comment-head").children("p.comment-hidden").text());
				content_div.siblings(".comment-head").children("i.fa-pencil-square-o").css("color", "#a6a6a6");
				content_div.siblings(".comment-head").children("i.fa-pencil-square-o").removeClass("active");
			});
			content_div.html(html);
		}
	}
	
	function deleteComment(num, board_num, page) {
		swal({
			title : "Are you sure you want to delete the comment?",
			text : "The comment deleted cannot be recovered.",
			type : "warning",
			showCancelButton : true,
			confirmButtonColor : "#DD6B55",
			confirmButtonText : "YES",
			cancelButtonText : "NO",
			closeOnConfirm : false,
			closeOnCancel : false,
			allowOutsideClick: true
		}, function(isConfirm) {
			if (isConfirm) {
				swal("Complete", "The comment is deleted.", "success");
				location.href = "/comment/video/delete?num=" + num + "&board_num=" + board_num + "&page=" + page;
			} else {
				swal("Cancel", "The deleting the comment is cancelled.", "error");
			}
		});
	}
	
	function deleteReply(obj) {
		swal({
			title : "Are you sure you want to delete the comment?",
			text : "The comment deleted cannot be recovered.",
			type : "warning",
			showCancelButton : true,
			confirmButtonColor : "#DD6B55",
			confirmButtonText : "YES",
			cancelButtonText : "NO",
			closeOnConfirm : false,
			closeOnCancel : false,
			allowOutsideClick: true
		}, function(isConfirm) {
			if (isConfirm) {
				swal("Complete", "The comment is deleted.", "success");
				location.href = "/comment/video/reply/delete?num=" + $(obj).attr("num") + "&board_num=" + $(obj).attr("board_num")  + "&comment_num=" + $(obj).attr("comment_num") + "&page=" + $(obj).attr("page");
			} else {
				swal("Cancel", "The deleting the comment is cancelled.", "error");
			}
		});
	}
	
	function validateFile(obj){
		var maxSize = 1024 * 1024 * 100;
		var fileSize = obj.files[0].size;
		var fileName = obj.files[0].name;
		var fileExtenstion = fileName.substring(fileName.lastIndexOf(".") + 1);
		
		if(fileExtenstion.toLowerCase() != "mp4"){
			alert('You must upload the file extension name to "mp4".');
			obj.value = "";
			return false;
		}
		
		if(fileSize > maxSize){
			alert("Please upload file size less than 100MB.");
			obj.value = "";
			return false;
		}
	}
</script>
<!-- Header -->
<div class="content-section-a" style="min-height: 750px; margin-top: 10px;">
	<div class="container">
		<div class="board-row">
			<div class="col-md-4 well pricing-table" style="width: 100% ">
	            <div class="pricing-table-holder">
	                <center>
	                    <h2>${boardDTO.subject }</h3>
	                </center>
	                <span style="width: 50%; display: inline-block; float: left">
						views  :  ${boardDTO.readcount }
					</span>
	                <span style="width:50%; text-align: right; display: inline-block; float: left">
						posted by : ${boardDTO.writer }
					</span>
					<p align="right">
						<fmt:formatDate value="${boardDTO.writedate }" pattern="HH:mm, MMM dd, YYYY"/>
					</p>
	            </div>
	            <hr style="height: 2px; background: #777; width: 100%;">
				<div class="content-div" id="content_img_div">
                   	<video style="max-width: 100%;" controls="controls" src="${root }/board/${boardDTO.saved_filename}" autoplay="autoplay"></video>
				</div>
				<div class="content-div">
					<p style="margin-left: 20px; word-break: break-all; white-space: pre-line;">
						${boardDTO.content }
					</p>
				</div>
				<div class="row" style="margin: 0 auto; width: 100%; display: inline-block;">
					<div class="content-div" style="width: 100%; text-align: right;">
						<c:if test="${loginNick eq boardDTO.writer}">
						    <a class="btn btn-warning btn-sm" data-toggle="modal" data-target="#update" data-original-title>Modify</a>
		       				<a class="btn btn-danger btn-sm" onclick="deleteCheck('${boardDTO.num}','${param.page }');">Delete</a>
	       				</c:if>
	       				<c:if test="${param.search_type ne null }">
							<a class="btn btn-default btn-sm" href="/board/video/list?page=${param.page }&search_type=${param.search_type}&keyword=${param.keyword}">List</a>
						</c:if>
	       				<c:if test="${param.search_type eq null }">
	       					<a class="btn btn-default btn-sm" href="/board/video/list?page=${param.page }">List</a>
	       				</c:if>
       				</div>
       				<div class="row" style="margin-top:65px; padding-left: 5px;">
       					<div id="comment" style="width: 100%; height: 0px;"></div>
						<c:if test="${isLogin ne null }">
							<form action="/comment/video/insert" class="comment-input" method="get">
								<div class="comment-input-avatar">
									<img src="${root }/profile/${loggedInProfile}" alt="">
								</div>
								<div class="comment-textarea-div">
									<textarea class="comment-textarea" style="min-height: 100px; width: 100%;" name="content" required="required" placeholder="  As we all fans of gorgeous InGee, let's encourage all together while keeping netiquette."></textarea>
								</div>
								<div style="background: #fff;" align="right">
									<input type="hidden" name="board_num" value="${boardDTO.num }">
									<input type="hidden" name="comment_num" value="0">
									<input type="hidden" name="writer" value="${loginNick }">
									<input type="hidden" name="page" value="${param.page }">
									<button type="submit" class="btn btn-default btn-sm">Input</button>
								</div>
							</form>
						</c:if>
						
						<!-- 댓글 페이징 변수 -->
						<c:set var="totalComment" value="${fn:length(commentList) }"/>
						<c:set var="perPage" value="10"/>
						<c:set var="perBlock" value="7"/>
						<fmt:parseNumber var="totalPage" integerOnly="true" value="${totalComment % perPage == 0 ? totalComment / perPage : totalComment / perPage + 1 }"/>
						<c:set var="startPage" value="1"/>
						<c:set var="endPage" value="${totalPage > perBlock ? perBlock : totalPage }"/>
						<!-- 댓글 페이징 변수 끝 -->
						
						<c:if test="${totalComment > 0}">
							<div class="comments-container">
								<h5 style="margin-left: 5px;">Comments: [ ${totalComment } ]</h5>
								<ul class="comments-list" id="comments-list">
									<c:forEach var="commentDTO" items="${commentList }" varStatus="status">
										<li class="${status.index < perPage ? 'active' : '' }">
											<div class="comment-main-level">
												<div class="comment-avatar"><img src="${root }/profile/${profile_file[status.index]}" alt=""></div>
												<div class="comment-box">
													<div class="comment-head">
														<h6 class="comment-name ${boardDTO.writer == commentDTO.writer ? 'by-author' : '' }">${commentDTO.writer }</h6>
														<span class="span-date"><fmt:formatDate value="${boardDTO.writedate }" pattern="HH:mm, MMM dd, yy"/></span>
														<i class="fa fa-reply" onclick="getReply(this, '${boardDTO.num }', '${commentDTO.num}', '${isLogin }', '${loginNick }', '${loggedInProfile }', '${boardDTO.writer }', '${param.page }')">[${commentDTO.reply_count }]</i>
														<c:if test="${loginNick == commentDTO.writer }">
															<i class="fa fa-trash" onclick="deleteComment(${commentDTO.num}, ${boardDTO.num }, ${param.page })"></i>
															<i class="fa fa-pencil-square-o" onclick="updateCommentForm(this, ${commentDTO.num}, ${commentDTO.board_num }, ${param.page })"></i>
															<p style="display: none;" class="comment-hidden">${commentDTO.content }</p>
														</c:if>
													</div>
													<div class="comment-content"><p style="word-break: break-all; white-space: pre-line;">${commentDTO.content }</p></div>
												</div>
											</div>
										</li>
									</c:forEach>
								</ul>
								
								<div style="width:100%;" align="center">
									<ul class="pagination" id="comment-pagination">
										<c:forEach begin="${startPage}" end="${totalPage}" var="page">
											<li class="${page eq startPage ? 'active ' : '' } ${page <= perBlock ? 'show' : ''}" onclick="commnetPagination(this, ${perPage }, ${perBlock }, ${totalPage })">						
												<a href="#comment"><c:out value="${page}"/></a>
											</li>
										</c:forEach>
									</ul>
								</div>
							</div>
						</c:if>
       				</div>
				</div>
	        </div>
		</div>
		<div class="modal fade" id="update" tabindex="-1" role="dialog" aria-labelledby="contactLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="well well-sm">
					<form class="form-horizontal" action="/board/video/update" method="post" enctype="multipart/form-data">
						<fieldset>
							<legend class="text-center"><h1>Video</h1></legend>
							<div class="form-group">
								<div class="input-group">
									<label class="col-md-2 control-label">Subject</label>
									<div class="col-md-9">
										<input id="subject" name="subject" type="text" placeholder="subject" class="form-control" required="required" value=${boardDTO.subject }>
									</div>
								</div>
							</div>
							<div class="form-group">
								<div class="input-group">
									<label class="col-md-2 control-label">Content</label>
									<div class="col-md-9">
										<textarea class="form-control" rows="10" cols="" name="content" required="required" style="width: 100%;">${boardDTO.content }</textarea>
									</div>
								</div>
							</div>
							<div class="form-group">
								<div class="input-group">
									<label class="col-md-2 control-label">Image</label>
									<div class="col-md-9">
										<input type="file" class="form-control" name="upload_file" id="upload_file" onchange="validateFile(this)">
										<c:if test="${boardDTO.saved_filename != 'NO' }">
											<span class="help-block" style="margin-bottom: 0; color: red; font-size: 9pt;">Delete the attachment(Please check what you want to delete).</span>
											<c:set var="saved_file" value="${fn:split(boardDTO.saved_filename, ',') }"/>
											<c:forTokens items="${boardDTO.origin_filename }" delims="," var="origin_file" varStatus="status">
												<input type="checkbox" value="${saved_file[status.index] }" name="remove_file"> ${origin_file }
											</c:forTokens>
										</c:if>
										<span class="help-block" style="padding-left: 5px; color: red;">※ Please select a file only if you want to change uploaded image.</span>
									</div>
								</div>
							</div>
							<div class="panel-footer">
								<input type="hidden" name="writer" value="${boardDTO.writer }">
								<input type="hidden" name="num" value="${boardDTO.num }">
	                            <input type="submit" class="btn btn-success" value="OK" id="updateSubmit"/>
<!-- 	                            <input type="hidden" name="remove_file" value=""> -->
	                            <input type="reset" class="btn btn-danger" value="Clear" />
	                            <button style="float: right;" type="button" class="btn btn-default btn-close" data-dismiss="modal">Close</button>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div> <!--  container end -->
</div>