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
			<a class="navbar-brand" href="/">InGee Fan Club</a>
		</div>
		<div>
		    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			    <nav>
					<ul class="nav navbar-nav navbar-right">
						<li>
							<c:if test="${isLogin eq null }">
								<a href="/member/login">LOGIN</a>
							</c:if>
							<c:if test="${isLogin ne null }">
								<a href="/member/logout">LOGOUT</a>
							</c:if>
						</li>
						<li><a href="/ingee">INGEE</a></li>
						<li><a href="/board">NOTICE</a></li>
						<li><a href="/photo">PHOTO</a></li>
						<li><a href="/video">VIDEO</a></li>
						<li><a href="/tour">TOUR</a></li>
						<li><a href="/network">NETWORK</a></li>
						<li><a href="/message/">MESSAGE</a></li>
						<li><a href="/chat/">CHAT</a></li>
					</ul>
				</nav>
			</div><!-- /.navbar-collapse -->
		</div>
	</div>
</div>