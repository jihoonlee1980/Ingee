function popupOpen(id){	
	var popUrl = "/member/profile?id="+id;
	var pop_title = "popupOpener" ;
	var windowW = 370;
    var windowH = 548;
    var popupX = (window.screen.width / 2) - (windowW / 2);
    var popupY= (window.screen.height /2) - (windowH / 2);
    window.open(popUrl, pop_title, 'status=no, height='+windowH+', width='+windowW+', left='+ popupX + ', top='+ popupY + ', screenX='+ popupX + ', screenY= '+ popupY);
}

function popSendToMessage(id){
	parent.window.opener.document.location.href='/message/send?sendto='+id;
	window.close();
}