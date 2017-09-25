<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ page session="true" %>
<style>
@media (max-width : 768px){
	ul.nav>li {
		height: 45px;
	}
}
</style>
<div id="navigation" class="navbar navbar-inverse navbar-fixed-top default" role="navigation">
	<div class="container">
    <!-- Brand and toggle get grouped for better mobile display -->
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
				<span class="icon-bar"></span>
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="/">In Gee Fan Club</a>
		</div>
		<div>
		    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			    <nav>
					<ul class="nav navbar-nav navbar-right">
<!-- 						<li><a href="/board/ingee/list">IN GEE</a></li> -->
						<li><a href="/board/notice/list">NOTICES</a></li>
						<li><a href="/board/photo/list">PHOTOS</a></li>
						<li><a href="/board/video/list">MOVIES</a></li>
						<li><a href="/board/tour/list">TOURNAMENTS</a></li>
						<li><a href="/board/network/list">NETWORK</a></li>
						<c:if test="${isLogin ne null }">
							<li><a href="/message/">MESSAGES</a></li>
 							<li><a href="/chat/">CHATTING</a></li>
						</c:if>
						<c:if test="${isLogin eq null }">
							<li><a href="/member/login">LOGIN</a></li>
							<li><a href="/member/join">JOIN US</a></li>
						</c:if>
						<c:if test="${isLogin ne null }">
							<li><a href="/member/logout">LOGOUT</a></li>
						</c:if>
						<c:if test="${isLogin ne null }">
							<li>
								<a href="/member/mypage">MYPAGE</a>
							</li>
							<c:if test="${isAdmin ne null && isAdmin == 'YES'}">
								<li>
									<a href="/member/admin">ADMIN</a>
								</li>
							</c:if>
						</c:if>
					</ul>
				</nav>
			</div><!-- /.navbar-collapse -->
		</div>
	</div>
</div>