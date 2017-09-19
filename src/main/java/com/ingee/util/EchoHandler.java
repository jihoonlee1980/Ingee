package com.ingee.util;

import java.io.ByteArrayOutputStream;
import java.io.ObjectOutput;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.socket.BinaryMessage;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.springframework.web.socket.sockjs.transport.TransportType;

import com.nhncorp.lucy.security.xss.XssFilter;
import com.nhncorp.lucy.security.xss.XssPreventer;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class EchoHandler extends TextWebSocketHandler {
	// private static Logger logger =
	// LoggerFactory.getLogger(EchoHandler.class);
	private List<WebSocketSession> sessionList;	
	
	public EchoHandler() {
		sessionList = new ArrayList<WebSocketSession>();		
	}
	public String userList(List<WebSocketSession> sessionList) {
		JSONArray Jarray = new JSONArray();
		JSONArray Jarray1 = new JSONArray();
		JSONArray Jarray2 = new JSONArray();
		JSONObject Jobj = new JSONObject();
		for (WebSocketSession sess : sessionList) {			
			Jarray.add(sess.getAttributes().get("userNick"));		
			Jarray2.add(sess.getAttributes().get("userID"));
			Jarray1.add(sess.getAttributes().get("userProfile"));
			
		}		
		Jobj.put("nick", Jarray);
		Jobj.put("id", Jarray2);
		Jobj.put("profile", Jarray1);		
		return Jobj.toString();
	}
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		JSONArray Jarray = new JSONArray();
		JSONArray Jarray1 = new JSONArray();
		JSONArray Jarray2 = new JSONArray();
		JSONObject Jobj = new JSONObject();
		boolean isChat = false;
		TextMessage textMessage;
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
			for (WebSocketSession sess : sessionList) {
				if (session.getAttributes().get("userID").equals(sess.getAttributes().get("userID"))) {
					session.sendMessage(new TextMessage("ConnectionMe|Chat Reconnection succeeded"));
				} else {
					sess.sendMessage(new TextMessage("ConnectionUser|"+ session.getAttributes().get("userNick") + "("
							+ session.getAttributes().get("userID") + ") Reconnected"));
				}
				sess.sendMessage(new TextMessage("userList|"+userList(sessionList)));
			}
		} else {
			for (WebSocketSession sess : sessionList) {
				if (session.getAttributes().get("userID").equals(sess.getAttributes().get("userID"))) {
					// String[] messageArr = {"OK" , "Chat connection
					// succeeded"};
					session.sendMessage(new TextMessage("ConnectionMe|Chat connection succeeded"));
				} else {
					// sess.sendMessage(new TextMessage("ConnectionUser|" +
					// session.getAttributes().get("userNick") + "("
					// + session.getAttributes().get("userID") + ") signed
					// in."));
					sess.sendMessage(new TextMessage("ConnectionUser|"+ session.getAttributes().get("userNick") + "("
							+ session.getAttributes().get("userID") + ") signed in."));
				}
				sess.sendMessage(new TextMessage("userList|"+userList(sessionList)));
			}
		}
		// logger.info("{} 연결됨", session.getAttributes().get("userID"));
	}

	@Override
	public boolean supportsPartialMessages() {
		// TODO Auto-generated method stub
		return super.supportsPartialMessages();
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		// logger.info("{}로 부터 {} 받음", session.getAttributes().get("userID"),
		// message.getPayload());		
		String filterMsg = XssPreventer.escape(message.getPayload());
		for (WebSocketSession sess : sessionList) {
			String msg = session.getAttributes().get("userID").equals(sess.getAttributes().get("userID"))
					? "MsgMe|" + session.getAttributes().get("userNick") + "|" + session.getAttributes().get("userID")
							+ "|" + session.getAttributes().get("userProfile") + "|" + filterMsg
					: "MsgUser|" + session.getAttributes().get("userNick") + "|" + session.getAttributes().get("userID")
							+ "|" + session.getAttributes().get("userProfile") + "|" + filterMsg;
			sess.sendMessage(new TextMessage(msg));
		}
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		for (WebSocketSession sess : sessionList) {
			if (!session.getAttributes().get("userID").equals(sess.getAttributes().get("userID"))) {
				sess.sendMessage(new TextMessage("Off|" + session.getAttributes().get("userID") + " was sent off."));
			}
			//sess.sendMessage(new TextMessage("userList|"+userList(sessionList)));
		}		
		sessionList.remove(session);
		
		for (WebSocketSession sess : sessionList) {			
			sess.sendMessage(new TextMessage("userList|"+userList(sessionList)));
		}		
		
		// logger.info("{} 연결 끊김", session.getAttributes().get("userID"));
	}
}
