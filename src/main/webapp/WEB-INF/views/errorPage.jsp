<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<c:set var="root_" value="<%=request.getContextPath() %>"/>
<c:set var="root" value="${root_}/resources"/>
<link href="${root}/css/error.css" rel="stylesheet">
<html>
<body>
    <div id="block_error">
	    <div>
			<h2>${errorCode }</h2>
	    <p>
	    	${errorMsg }
	    </p>
	    </div>
	</div>
</body>
</html>