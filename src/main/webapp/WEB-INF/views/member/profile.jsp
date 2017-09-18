<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ page session="false"%>
<c:set var="root_" value="<%=request.getContextPath() %>" />
<c:set var="root" value="${root_}/resources" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Profile</title>
    <script src="/assets/jquery-3.2.1.min.js"></script>
    <script src="/assets/js/bootstrap.js"></script>
    <script src="/resources/js/popup.js"></script>
    <link href="/assets/css/font-awesome.min.css?ver=3" rel="stylesheet" type="text/css">
    <link href="/assets/css/bootstrap.css?ver=2" rel="stylesheet">
</head>
<c:if test="${loginCheck eq true}">
<div class="container" style="margin:0; padding: 0;">
      <div class="row">
      </div>
        <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6 col-xs-offset-0 col-sm-offset-0 col-md-offset-3 col-lg-offset-3 toppad" style="padding:0;">
          <div class="panel panel-info">
            <div class="panel-heading">
              <h3 class="panel-title"><c:out value="${memberDTO.nick }"/></h3>
            </div>
            <div class="panel-body">
              <div class="row">
                <div class="col-md-3 col-lg-3 " align="center"> <img style="width:50%;" alt="User Pic" src="${root}/profile/${memberDTO.saved_filename == 'NO' ? 'none_profile.png':memberDTO.saved_filename}" class="img-responsive"> </div>
                <div class=" col-md-9 col-lg-9 "> 
                  <table class="table table-user-information">
                    <tbody>
                     <tr>
                        <td>Name</td>
                        <td>${memberDTO.name }</td>
                      </tr>                                    
                      <tr>
                        <td>Date of Birth</td>
                        <td><fmt:formatDate value="${memberDTO.joindate }" pattern=" HH:mm MMM dd yyyy" /></td>
                      </tr>                       
                        <tr>
                        <td>Address</td>
                        <td>${memberDTO.region }<br>${memberDTO.detailed_address }, ${memberDTO.city }, ${memberDTO.state }, ${memberDTO.zipcode }</td>
                      </tr>
                      <tr>
                        <td>Email</td>
                        <td><a href="mailto:${memberDTO.id}">${memberDTO.id}</a></td>
                      </tr>
                        <td>Phone Number</td>
                        <td>${memberDTO.hp}(Mobile)
                        </td>
                      </tr>
                    </tbody>
                  </table>
                  <div style="float:right;">
                  <a href="#" class="btn btn-primary" onclick="popSendToMessage('${memberDTO.id}')">Send to Message</a>
                  <a href="#" class="btn btn-primary" onclick="javascript:window.close();">Close</a>
                  </div>                
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
 </c:if>
 <c:if test="${loginCheck ne true}">
 <script type="text/javascript">
 	alert("This service requires login.");
 	window.close();
 </script>
 </c:if>
</html>