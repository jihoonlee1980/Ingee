package com.menu.model;

import java.sql.Timestamp;

public class MessageDTO {
	int num , recv_read ;
	String sender , receiver , subject , content , sender_nick , receiver_nick , receiver_profile , sender_profile;
	Timestamp date_sent , date_recv ;
	
	public String getSender_nick() {
		return sender_nick;
	}
	public void setSender_nick(String sender_nick) {
		this.sender_nick = sender_nick;
	}
	public String getReceiver_nick() {
		return receiver_nick;
	}
	public void setReceiver_nick(String receiver_nick) {
		this.receiver_nick = receiver_nick;
	}
	public String getReceiver_profile() {
		return receiver_profile;
	}
	public void setReceiver_profile(String receiver_profile) {
		this.receiver_profile = receiver_profile;
	}
	public String getSender_profile() {
		return sender_profile;
	}
	public void setSender_profile(String sender_profile) {
		this.sender_profile = sender_profile;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public int getRecv_read() {
		return recv_read;
	}
	public void setRecv_read(int recv_read) {
		this.recv_read = recv_read;
	}
	public String getSender() {
		return sender;
	}
	public void setSender(String sender) {
		this.sender = sender;
	}
	public String getReceiver() {
		return receiver;
	}
	public void setReceiver(String receiver) {
		this.receiver = receiver;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}	
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Timestamp getDate_sent() {
		return date_sent;
	}
	public void setDate_sent(Timestamp date_sent) {
		this.date_sent = date_sent;
	}
	public Timestamp getDate_recv() {
		return date_recv;
	}
	public void setDate_recv(Timestamp date_recv) {
		this.date_recv = date_recv;
	}
	
}
