package com.menu.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/chat")
@Controller
public class ChatController {
	
	@RequestMapping("/")
	public String Chat() {
		return "/1/chat/chat";
	}
}
