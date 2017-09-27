<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ page session="false" %>
<c:set var="root_" value="<%=request.getContextPath() %>"/>
<c:set var="root" value="${root_ }/resources"/>
<!-- <section id="slide"  style="padding: 0;"> -->
<!-- 	<ul id="slippry-slider"> -->
<!-- 		<li> -->
<!-- 			<a href="#slide1"><img src="/assets/img/slide/1.jpg"></a> -->
<!-- 		</li> -->
<!-- 		<li> -->
<!-- 			<a href="#slide2"><img src="/assets/img/slide/2.jpg"></a> -->
<!-- 		</li> -->
<!-- 		<li> -->
<!-- 			<a href="#slide3"><img src="/assets/img/slide/3.jpg"></a> -->
<!-- 		</li> -->
<!-- 	</ul> -->
<!-- </section> -->
<section id="Intro" class="section">
<div class="container">
	<div class="row">
		<div class="col-md-8 col-md-offset-2">
			<div class="heading">
				<h3>
					<span>Intro</span>
				</h3>
			</div>
			<br>
			<center>
				<br>
				<p>
					We welcome you to visit the In Gee Fan Club Website where 
					fans of InGee gather to share stories and photos and encourage
					her with our support.<br> It's a fun site full of In Gee's
					smiles and comments with room reserved for your participation. <br>
					In Gee is a wonderful humanitarian with world-class talent who is
					dedicated to improving every day. <br> Let's show her she
					has a huge US fan base ready to cheer for her whenever and
					wherever she plays!<br> <span class='red'>♥</span>
				</p>
				<img class="img-responsive"
					src="${root}/img/main/ingee810.jpg" alt=""></a><br>
			</center>
		</div>
	</div>
</div>
</section>
<!-- end section about -->
<!-- section works -->
<section id="Photo" class="section gray">
<div class="container">
	<div class="row">
		<div class="col-md-8 col-md-offset-2">
			<div class="heading">
				<h3>
					<span>Photo</span>
				</h3>
			</div>
			<div class="sub-heading">
				<p>
					<a href="/board/photo/list">Recent!</a><br>
					<img src="${root}/img/main/new1.png" width="50" height="50" alt="">
				</p>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<ul class="grid effect" id="grid">
				<c:forEach var="boardDTO" items="${boardList}">
					<li>
						<a class="fancybox" data-fancybox-group="gallery" href="/board/photo/${boardDTO.num }">
						<img src="${root}/board/${boardDTO.saved_filename}" alt="" />
					</a></li>
				</c:forEach>
			</ul>
		</div>
	</div>
</div>
</section>
<!-- section works -->
<!-- section contact -->
<section id="Network" class="section">
	<div class="container">
		<div class="row">
			<div class="col-md-8 col-md-offset-2">
				<div class="heading">
					<h3>
						<span>Network</span>
					</h3>
				</div>
				<div class="sub-heading">
					<p>
						<a href="/board/network/list">Recent!</a>
					</p>
					<img src="${root}/img/main/new2.png" width="50" height="50"
						alt=""><br> <br>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-3">
				<div class="team-box">
					<a href="/board/network/west/list"> <img src="${root}/img/main/ingee.png" alt="" class="img-responsive" />
						<div class="roles">
							<h5>
								<strong>West</strong>
							</h5>
						</div>
					</a>
				</div>
			</div>
			<div class="col-md-3">
				<div class="team-box">
					<a href="/board/network/midwest/list"> <img src="${root}/img/main/ingee1.png" alt="" class="img-responsive" />
						<div class="roles">
							<h5>
								<strong>MidWest</strong>
							</h5>
						</div>
					</a>
				</div>
			</div>
			<div class="col-md-3">
				<div class="team-box">
					<a href="/board/network/northeast/list"> <img src="${root}/img/main/ingee2.png" alt="" class="img-responsive" />
						<div class="roles">
							<h5>
								<strong>East</strong>
							</h5>
						</div>
					</a>
				</div>
			</div>
			<div class="col-md-3">
				<div class="team-box">
					<a href="/board/network/south/list"> <img src="${root}/img/main/ingee3.png" alt="" class="img-responsive" />
						<div class="roles">
							<h5>
								<strong>South</strong>
							</h5>
						</div>
					</a>
				</div>
			</div>
		</div>
	</div>
</section>
<section id="Tour" class="section">
	<div class="container">
		<div class="row">
			<div class="col-md-8 col-md-offset-2">
				<div class="heading">
					<h3>
						<span>Tour</span>
					</h3>
				</div>
				<div class="sub-heading">
					<p>
						<a href="/board/tour/list">Recent! 
					</p>
					<img src="${root}/img/main/new3.png" width="50" height="50"
						alt=""> <br> <br>
					<p>2017 LPGA Tournaments</p>
					<br>
					<center>
						<img class="img-responsive" src="${root}/img/main/ingeeintro1.jpg" alt="">
					</center>
					</a><br> <a target="_blank" href="http://www.lpga.com/tournaments">lpga.com</a>
				</div>
			</div>
		</div>
	</div>
</section>
