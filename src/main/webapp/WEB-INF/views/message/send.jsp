<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ page session="true"%>
<c:set var="root_" value="<%=request.getContextPath() %>" />
<c:set var="root" value="${root_}/resources" />
<script src="/assets/jquery-3.2.1.min.js"></script>
<script type="text/javascript">
</script>
<style>
.form-group input[type="checkbox"] {
    display: none;
}

.form-group input[type="checkbox"] + .btn-group > label span {
    width: 20px;
}

.form-group input[type="checkbox"] + .btn-group > label span:first-child {
    display: none;
}
.form-group input[type="checkbox"] + .btn-group > label span:last-child {
    display: inline-block;   
}

.form-group input[type="checkbox"]:checked + .btn-group > label span:first-child {
    display: inline-block;
}
.form-group input[type="checkbox"]:checked + .btn-group > label span:last-child {
    display: none;   
}
.checkbox label:after, 
.radio label:after {
    content: '';
    display: table;
    clear: both;
}

.checkbox .cr,
.radio .cr {
    position: relative;
    display: inline-block;
    border: 1px solid #a9a9a9;
    border-radius: .25em;
    width: 1.3em;
    height: 1.3em;
    float: left;
    margin-right: .5em;
}

.radio .cr {
    border-radius: 50%;
}

.checkbox .cr .cr-icon,
.radio .cr .cr-icon {
    position: absolute;
    font-size: .8em;
    line-height: 0;
    top: 50%;
    left: 20%;
}

.radio .cr .cr-icon {
    margin-left: 0.04em;
}

.checkbox label input[type="checkbox"],
.radio label input[type="radio"] {
    display: none;
}

.checkbox label input[type="checkbox"] + .cr > .cr-icon,
.radio label input[type="radio"] + .cr > .cr-icon {
    transform: scale(3) rotateZ(-20deg);
    opacity: 0;
    transition: all .3s ease-in;
}

.checkbox label input[type="checkbox"]:checked + .cr > .cr-icon,
.radio label input[type="radio"]:checked + .cr > .cr-icon {
    transform: scale(1) rotateZ(0deg);
    opacity: 1;
}

.checkbox label input[type="checkbox"]:disabled + .cr,
.radio label input[type="radio"]:disabled + .cr {
    opacity: .5;
}
</style>
<div class="content-section-a">
	<div class="container">
		<h1>
			Send
		</h1>
		<form class="col-md-12 well" action="/message/send" method="post">
             <div class="row">
                 <div class="col-md-6">
                     <div class="form-group">
                         <label for="sender">Sender</label>
                         <input type="text" class="form-control" name="sender" value='<c:out value="${id }"/>' readonly="readonly">
                     </div>
                     <div class="form-group">                     	
                         <label for="receiver">Receiver</label>
                        <div class="input-group" style="width:100%;">
                         <input type="text" class="form-control" name="receiver" placeholder="Receiver" required="required" style="width:75%;">
                         <i class="fa fa-users" aria-hidden="true"></i>
                        </div>
                         <div class="checkbox">
				            <label style="font-size: 1.5em">
				                <input type="checkbox" value="" name="self">
				                <span class="cr"><i class="cr-icon fa fa-check"></i></span>
				                Send to me
				            </label>
				        </div>
				        
                     </div>
                     <div class="form-group">
                         <label for="subject">Subject</label>
                         <input type="text" class="form-control" name="subject" placeholder="Subject" required="required">
                     </div>                        
                 </div>
         
                 <div class="col-md-6">
                     <div class="form-group">
                         <label for="message">Message</label>
                         <textarea class="form-control" name="content" rows="11" placeholder="Enter Message" required="required"></textarea>
                     </div>
                     <div class="form-group">
                        <button class="btn btn-primary pull-right" type="submit">Send</button>
                     </div>
                 </div>
             </div>
		</form>
	</div>
</div>