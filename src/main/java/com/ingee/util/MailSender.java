package com.ingee.util;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.mail.javamail.JavaMailSenderImpl;

public class MailSender {
	public void sendEmail(JavaMailSenderImpl mailSender, String subject, String content, String receiver)
			throws Exception {
		MimeMessage msg = mailSender.createMimeMessage();

		msg.setSubject(subject);
		msg.setText(content);
		msg.setRecipients(MimeMessage.RecipientType.TO, InternetAddress.parse(receiver));

		mailSender.send(msg);
	}
}
