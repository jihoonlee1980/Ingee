package com.ingee.interceptor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

public class ChatInterceptor extends HttpSessionHandshakeInterceptor {
	@Override
	public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler,
			Map<String, Object> attributes) throws Exception {
		ServletServerHttpRequest ssHttpRequest = (ServletServerHttpRequest) request;
		HttpServletRequest hsRequest = ssHttpRequest.getServletRequest();
		String nick = (String) hsRequest.getSession().getAttribute("loginNick");
		String id = (String) hsRequest.getSession().getAttribute("loggedInID");
		String profile = (String) hsRequest.getSession().getAttribute("profile");
		attributes.put("userID", id);
		attributes.put("userNick", nick);
		attributes.put("userProfile", profile);
		return super.beforeHandshake(request, response, wsHandler, attributes);
	}
}
