<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ page session="false" %>
<c:set var="root_" value="<%=request.getContextPath() %>"/>
<c:set var="root" value="${root_}/resources"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>InGee Fan Club(Test Run)</title>
    <link href="/assets/css/bootstrap.css?ver=2" rel="stylesheet">
    <link href="/assets/css/font-awesome.css?ver=2" rel="stylesheet" type="text/css">
    <link href="/assets/css/font-awesome.min.css?ver=3" rel="stylesheet" type="text/css">
<!--     <script src="/assets/jquery-3.2.1.min.js"></script> -->
    <script src="/assets/js/bootstrap.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js"></script>    
    <link rel="stylesheet" href="/assets/css/fancybox/jquery.fancybox.css">	
	<link href="/assets/css/bootstrap-theme.css" rel="stylesheet" />
	<link rel="stylesheet" href="/assets/css/slippry.css">
	<link href="/assets/css/style.css?ver=4" rel="stylesheet" />
	<link rel="stylesheet" href="/assets/color/default.css">
	<link rel="shortcut icon" href="/images/favicon.png">
	<link href="/css/comment.css" rel="stylesheet">
	<!-- =======================================================
	    Theme Name: Groovin
	    Theme URL: https://bootstrapmade.com/groovin-free-bootstrap-theme/
	    Author: BootstrapMade
	    Author URL: https://bootstrapmade.com
	======================================================= -->
	
    <!-- sweet alert -->
<%--     <script src="${root }/js/sweetalert.min.js"></script> --%>
<%--     <link href="${root }/css/sweetalert.css" rel="stylesheet"> --%>
<%--     <link href="${root }/css/comment.css?ver=7" rel="stylesheet"> --%>
<style type="text/css">
header{
	height: 88px;
}

@media (max-width : 991px){
	header {
		height: 131px;
	}
}

@media (max-width : 768px){
	header {
		height: 72px;
	}
}
</style>
</head>
<body>
	<header>
		<tiles:insertAttribute name="header"/>
	</header>
	<div>
		<tiles:insertAttribute name="body"/>
	</div>
    <footer>
    	<tiles:insertAttribute name="footer"/>
    </footer>
</body>
</html>

