package com.menu.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/message")
@Controller
public class MessageController {
	
	@RequestMapping("/")
	public String Message() {
		return "/1/message/list";
	}
}
