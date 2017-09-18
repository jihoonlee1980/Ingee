package com.menu.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/chat")
@Controller
public class ChatController {

	@RequestMapping("/")
	public String Chat(HttpSession session) {
		String returnURL = new String();
		if (session.getAttribute("isLogin") != null)
			returnURL = "/1/chat/chat";

		else
			returnURL = "redirect:/";

		return returnURL;
	}
}
