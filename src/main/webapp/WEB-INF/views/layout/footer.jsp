<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ page session="false" %>
<c:set var="root_" value="<%=request.getContextPath() %>"/>
<c:set var="root" value="${root_}/resources"/>
<div class="verybottom">
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<div class="aligncenter">
	                <ul class="social-network social-circle">
	                    <li><a target="_blank" href="https://www.instagram.com/ingeechun_dumbo/" class="icoInstagram" title="Instagram"><i class="fa fa-instagram"></i></a></li>
						<li><a target="_blank" href="https://www.facebook.com/profile.php?id=100009369141719&fref=ts" class="icoFacebook" title="Facebook"><i class="fa fa-facebook"></i></a></li>
						<li><a target="_blank" href="http://twitter.com/ingeechun_dumbo" class="icoTwitter" title="Twitter"><i class="fa fa-twitter"></i></a></li>
						<li><a target="_blank" href="http://www.lpga.com/players/in%20gee%20chun/98372/overview" class="icoGoogle" title="Google +"><i class="fa fa-google-plus"></i></a></li>
	                </ul>	
				</div>				
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="aligncenter">
					<p class="copyright">
						<b style="color: white;">&copy;</b> 2017 Developed by <a
							target="_blank" href="http://factorysunny.com"
							title="Sunnyfactory"> <b style="color: lime;">
								SunnyFactory</b></a> <br> & Powered by <a target="_blank"
							href="http://lnsglobalinc.com" title="LNS Global"> <b
							style="color: orange;">LNS Global Inc</b></a> <br> All Rights
						Reserved
					</p>
					<div class="credits">
						<a target="_blank" href="https://bootstrapmade.com/">Free
							Bootstrap Themes</a> by <a target="_blank"
							href="https://bootstrapmade.com/">BootstrapMade</a> <br>
						<div class="text-center">
							<a target="_blank" href="http://www.freepik.com"
								title="Freepik">Icons made by Freepik from</a> <a
								target="_blank" href="http://www.flaticon.com"
								title="Flaticon"> www.flaticon.com is licensed b</a> <a
								target="_blank"
								href="http://creativecommons.org/licenses/by/3.0/"
								title="Creative Commons BY 3.0" target="_blank"> CC 3.0 BY</a>
						</div>
						<br>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<a href="#" class="scrollup" style="background-color: #999"><i class="fa fa-angle-up fa-2x"></i></a>

	<script src="/assets/js/jquery-1.9.1.min.js?ver=4"></script>
	<script src="/assets/js/modernizr.custom.js"></script>
	<script src="/assets/js/jquery.easing.js"></script>
	<script src="/assets/js/classie.js"></script>
	<script src="/assets/js/bootstrap.js"></script>
	<script src="/assets/js/slippry.min.js"></script>
	<script src="/assets/js/nagging-menu.js"></script>
	<script src="/assets/js/jquery.nav.js"></script>
	<script src="/assets/js/jquery.scrollTo.js"></script>
	<script src="/assets/js/jquery.fancybox.pack.js"></script> 
	<script src="/assets/js/jquery.fancybox-media.js"></script> 
	<script src="/assets/js/masonry.pkgd.min.js"></script>
	<script src="/assets/js/imagesloaded.js"></script>
	<script src="/assets/js/jquery.nicescroll.min.js"></script>
<!-- 	<script src="https://maps.google.com/maps/api/js?sensor=true"></script> -->
	<script src="/assets/js/AnimOnScroll.js"></script>
	<script src="/assets/js/custom.js"></script>
	<script>
		new AnimOnScroll(document.getElementById('grid'), {
			minDuration : 0.4,
			maxDuration : 0.7,
			viewportFactor : 0.2
		});
	</script>
	<script>
		$(document).ready(function(){
		  $('#slippry-slider').slippry(
			defaults = {
				transition: 'vertical',
				useCSS: true,
				speed: 5000,
				pause: 3000,
				initSingle: false,
				auto: true,
				preload: 'visible',
				pager: false,		
			} 
		  
		  )
		});
	</script>