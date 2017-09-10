package com.ingee.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.nhncorp.lucy.security.xss.XssFilter;
import com.nhncorp.lucy.security.xss.XssPreventer;

public class EchoHandler extends TextWebSocketHandler {
	private static Logger logger = LoggerFactory.getLogger(EchoHandler.class);
	private List<WebSocketSession> sessionList;

	public EchoHandler() {
		sessionList = new ArrayList<WebSocketSession>();
	}

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		boolean isChat = false;
		
		for (WebSocketSession sess : sessionList) {
			if (session.getAttributes().get("userID").equals(sess.getAttributes().get("userID"))) {
				sess.sendMessage(new TextMessage("Overlap|Connection is terminated due to duplicate connection."));
				sess.close();
				sessionList.remove(sess);
				isChat = true;
				break;
			}
		}
		sessionList.add(session);

		if (isChat) {
			session.sendMessage(new TextMessage("채팅방에 접속하셨습니다."));
		} else {
			for (WebSocketSession sess : sessionList) {
				if (session.getAttributes().get("userID").equals(sess.getAttributes().get("userID"))){
					//String[] messageArr = {"OK" , "Chat connection succeeded"};					
					session.sendMessage(new TextMessage("ConnectionMe|Chat connection succeeded"));
				}
				else {
					sess.sendMessage(new TextMessage("ConnectionUser|" + session.getAttributes().get("userNick")+"("+session.getAttributes().get("userID") + ") signed in."));
				}
			}
		}

		logger.info("{} 연결됨", session.getAttributes().get("userID"));
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		logger.info("{}로 부터 {} 받음", session.getAttributes().get("userID"), message.getPayload());		
		String filterMsg = XssPreventer.escape(message.getPayload());
		for (WebSocketSession sess : sessionList) {
			String msg = session.getAttributes().get("userID").equals(sess.getAttributes().get("userID")) ?
					"MsgMe|"+session.getAttributes().get("userNick")+"|"+session.getAttributes().get("userID") + "|"
					+session.getAttributes().get("userProfile")+  "|" +filterMsg :
					"MsgUser|"+session.getAttributes().get("userNick")+"|"
					+session.getAttributes().get("userID") + "|" +session.getAttributes().get("userProfile") + "|" +filterMsg;		
					sess.sendMessage(new TextMessage(msg));
		}
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		for (WebSocketSession sess : sessionList) {
			if (!session.getAttributes().get("userID").equals(sess.getAttributes().get("userID"))) {
				sess.sendMessage(new TextMessage("Off|"+session.getAttributes().get("userID") + " was sent off."));
			}
		}
		sessionList.remove(session);
		logger.info("{} 연결 끊김", session.getAttributes().get("userID"));
	}
}
