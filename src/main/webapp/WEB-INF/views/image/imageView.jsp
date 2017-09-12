<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<c:set var="root_" value="<%=request.getContextPath() %>"/>
<c:set var="root" value="${root_}/resources"/>
<link href="${root}/css/error.css" rel="stylesheet">
<html>
<body>
	<img alt="aaasdf" src="${root }/board/${fileName }" title="이미지를 클릭하시면 창이 닫힙니다." onclick="javascript:window.close();" style="cursor: pointer;">
</body>
</html>