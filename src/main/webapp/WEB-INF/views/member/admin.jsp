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
<script type="text/javascript">
	$(function(){
		$('.search-panel .dropdown-menu').find('a').click(function(e) {
			e.preventDefault();
			var param = $(this).attr("href").replace("#","");
			var concept = $(this).text();
			$('.search-panel span#type').text(concept);
			
			if(param == "username")
				param = "id";
			
			$('.input-group #search_type').val(param);
		});
	});
</script>
<!-- Header -->
<style>
table.admin {
	margin-top: 30px;
	font-size: 10.5pt;
	border: 1px solid #e3e3e3;
    border-radius: 4px;
    box-shadow: inset 0 1px 1px rgba(0,0,0,.05);
}

table.admin caption {
	text-align: left;
	margin-bottom: 10px;
}

table.admin thead tr th{
	text-align: center;
	font-size: 1.0em;
}

table.admin tbody tr{
	height: 40px;
}

table.admin tbody tr td{
	text-align: center;
	font-size: 1.0em;
	vertical-align: middle;
}

table.admin>tbody>tr:nth-of-type(odd){
	background-color: #FFF !important;
}

table.admin thead tr th a {
	color: black;
	text-decoration: underline;
}
@media(max-width: 767px){
	table.admin{
		font-size: 5pt;
	}
	table.admin .search-form{
		width: 100% !important;
	}
}
</style>
<c:if test="${not empty param.sort }">
	<c:set var="sortStr" value="&sort=${param.sort }"/>
</c:if>
<c:if test="${not empty param.region}">
	<c:set var="regionStr" value="&region=${param.region}"/>
</c:if>
<c:if test="${not empty param.search_type}">
	<c:set var="searchStr" value="&search_type=${param.search_type}&keyword=${param.keyword }"/>
</c:if>
<div class="content-section-a" style="min-height: 750px;">
	<div class="container">
		<div class="row" style="margin:0;">
			<table class="table table-striped table-condensed admin">
				<caption style="padding-left: 10px;">
					<span>※ You can sort the username or name.</span><br>
					<span>※ You can send an email by clicking on the email(username).</span><br>
				</caption>
				<thead>
					<tr>
						<th colspan="4">
							<div class="search-form" style="width: 27%; float: left;">
								<div class="col-md-12">
									<div class="input-gorup">
										<c:if test="${param.search_type ne null }">
											<a href="/member/search?region=all${not empty param.sort ? sortStr : '' }${not empty param.search_type ? searchStr : ''}">ALL</a>&nbsp;&nbsp;
											<a href="/member/search?region=West${not empty param.sort ? sortStr : '' }${not empty param.search_type ? searchStr : ''}">West</a>&nbsp;&nbsp;
											<a href="/member/search?region=MidWest${not empty param.sort ? sortStr : '' }${not empty param.search_type ? searchStr : ''}">MidWest</a>&nbsp;&nbsp;
											<a href="/member/search?region=NorthEast${not empty param.sort ? sortStr : '' }${not empty param.search_type ? searchStr : ''}">NorthEast</a>&nbsp;&nbsp;
											<a href="/member/search?region=South${not empty param.sort ? sortStr : '' }${not empty param.search_type ? searchStr : ''}">South</a>
										</c:if>
										<c:if test="${param.search_type eq null }">
											<a href="/member/admin?region=all${not empty param.sort ? sortStr : '' }${not empty param.search_type ? searchStr : ''}">ALL</a>&nbsp;&nbsp;
											<a href="/member/admin?region=West${not empty param.sort ? sortStr : '' }${not empty param.search_type ? searchStr : ''}">West</a>&nbsp;&nbsp;
											<a href="/member/admin?region=MidWest${not empty param.sort ? sortStr : '' }${not empty param.search_type ? searchStr : ''}">MidWest</a>&nbsp;&nbsp;
											<a href="/member/admin?region=NorthEast${not empty param.sort ? sortStr : '' }${not empty param.search_type ? searchStr : ''}">NorthEast</a>&nbsp;&nbsp;
											<a href="/member/admin?region=South${not empty param.sort ? sortStr : '' }${not empty param.search_type ? searchStr : ''}">South</a>
										</c:if>
									</div>
								</div>
							</div>
							<form action="/member/search" class="form-horizontal search-form" style="width: 40%; float: right;">
								<div class="col-xs-12">
								    <div class="input-group">
						                <div class="input-group-btn search-panel">
						                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
						                    	<c:if test="${param.search_type eq null }">
						                    		<span id="type">USERNAME</span> <span class="caret"></span>
						                    	</c:if>
						                    	<c:if test="${param.search_type ne null }">
						                    		<span id="type">${param.search_type == 'id' ? 'USERNAME' : 'NAME' }</span><span class="caret"></span>
						                    	</c:if>
						                    </button>
						                    <ul class="dropdown-menu" role="menu">
												<li><a href="#username">USERNAME</a></li>
												<li><a href="#name">NAME</a></li>
						                    </ul>
						                </div>
						                <c:if test="${param.search_type eq null }">
						                	<input type="hidden" name="search_type" value="id" id="search_type">
						                </c:if>
										<c:if test="${param.search_type ne null }">
						                	<input type="hidden" name="search_type" value="${param.search_type == 'id' ? 'id' : 'name' }" id="search_type">
						                </c:if>
						                <input type="hidden" name="page" value="${param.page }">
						                <input type="hidden" name="sort" value="${param.sort }">
						                <input type="hidden" name="region" value="${param.region }">
						                <input type="text" class="form-control" name="keyword" value="${param.keyword }">
						                <span class="input-group-btn">
						                    <button class="btn btn-default" type="submit"><i class="fa fa-search"></i></button>
						                </span>
						            </div>
						        </div>
							</form>
						</th>
					</tr>
					<tr>
						<c:if test="${param.search_type ne null }">
							<th><a href="/member/search?sort=name&search_type=${param.search_type }&keyword=${param.keyword}${not empty param.region ? regionStr : '' }">NAME</a></th>
							<th><a href="/member/search?sort=id&search_type=${param.search_type }&keyword=${param.keyword}${not empty param.region ? regionStr : '' }">USERNAME</a></th>
						</c:if>
						<c:if test="${param.search_type eq null }">
							<th><a href="/member/admin?sort=name${not empty param.region ? regionStr : '' }">NAME</a></th>
							<th><a href="/member/admin?sort=id${not empty param.region ? regionStr : '' }">USERNAME</a></th>
						</c:if>
						<th width="50%">ADDRESS</th>
						<th>H.P</th>
					</tr>
				</thead>   
				<tbody>
					<c:if test="${fn:length(memberList) > 0 }">
						<c:forEach var="memberDTO" items="${memberList }">
							<tr>
			                    <td>${memberDTO.name }</td>
			                    <td><a href="mailto:${memberDTO.id }">${memberDTO.id }</a></td>
			                    <td>${memberDTO.region }<br>${memberDTO.detailed_address }, ${memberDTO.city }, ${memberDTO.state }, ${memberDTO.zipcode } </td>
			                    <td>${memberDTO.hp }</td>
		                	</tr>
						</c:forEach>
						<tr>
							<td colspan="4" style="text-align: right; padding-right: 10px;"><span>${fn:length(memberList) } 명의 회원정보가 있습니다.</span></td>
						</tr>
					</c:if>
					<c:if test="${fn:length(memberList) == 0 }">
						<tr>
							<td colspan="4">
								<c:if test="${param.search_type eq null }">
									No registered members.
								</c:if>
								<c:if test="${param.search_type ne null }">
									No results founded with "${param.keyword }".
								</c:if>
							</td>
						</tr>
					</c:if>
				</tbody>
			</table>
			<c:if test="${totalPage > 0}">
				<div style="width:100%;" align="center">
					<ul class="pagination">
						<c:if test="${startPage > 1}">
							<c:if test="${param.search_type ne null }">
								<li><a href="/member/search?page=${startPage-1}&sort=${param.sort}&search_type=${param.search_type}&keyword=${param.keyword}">&lt;</a></li>
							</c:if>
							<c:if test="${param.search_type eq null }">
								<li><a href="/member/admin?page=${startPage - 1}&sort=${param.sort}">&lt;</a></li>
							</c:if>
						</c:if>
						<c:forEach begin="${startPage}" end="${endPage}" var="page">
							<c:if test="${param.search_type ne null }">
								<li ${page eq currentPage ? "class='active'" : "" }>						
									<a href="/member/search?page=${page}&sort=${param.sort}&search_type=${param.search_type}&keyword=${param.keyword}">
										<c:out value="${page}"/>
									</a>
								</li>
							</c:if>
							<c:if test="${param.search_type eq null }">
								<li ${page eq currentPage ? "class='active'" : "" }>						
									<a href="/member/admin?page=${page}&sort=${param.sort}">
										<c:out value="${page}"/>
									</a>
								</li>
							</c:if>
						</c:forEach>
						<c:if test="${totalPage ne endPage}">
							<c:if test="${param.search_type ne null }">
								<li><a href="/member/search?page=${endPage + 1}&sort=${param.sort}&search_type=${param.search_type}&keyword=${param.keyword}">&gt;</a></li>
							</c:if>
							<c:if test="${param.search_type eq null }">
								<li><a href="/member/admin?page=${endPage + 1}&sort=${param.sort}">&gt;</a></li>
							</c:if>
						</c:if>
					</ul>
				</div>
			</c:if>
		</div>
	</div><!--  container end -->
</div> 