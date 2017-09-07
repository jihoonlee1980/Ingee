package com.menu.model;

import java.sql.Timestamp;

public class MessageDTO {
	int num , recv_read ;
	String sender , receiver , subject , content ;
	Timestamp date_sent , date_recv ;
	
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
