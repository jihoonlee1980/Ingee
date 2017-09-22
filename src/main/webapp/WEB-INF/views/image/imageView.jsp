<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<c:set var="root_" value="<%=request.getContextPath() %>"/>
<c:set var="root" value="${root_}/resources"/>
<link href="${root}/css/error.css" rel="stylesheet">
<html>
<body>
	<img alt="In Gee Fan Club" src="${root }/board/${fileName }" title="Please click the image to close the window." onclick="javascript:window.close();" style="cursor: pointer;">
</body>
</html>