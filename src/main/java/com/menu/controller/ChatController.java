package com.menu.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

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
	/*
	 * @RequestMapping(value = "/echo", method = RequestMethod.GET) public
	 * String home(HttpSession session) { return "chat"; }
	 * 
	 * @RequestMapping(value = "/loginForm") public String loginForm(HttpSession
	 * session) { String returnURL = "login";
	 * 
	 * if (session.getAttribute("isLogin") != null) returnURL =
	 * "redirect:/echo";
	 * 
	 * return returnURL; }
	 * 
	 * @RequestMapping(value = "/login") public String login(String id, String
	 * pass, HttpSession session) { String returnURL = "redirect:/echo";
	 * String[] info1 = { "qweqwe", "123123" }; String[] info2 = { "asdasd",
	 * "123123" };
	 * 
	 * if (id.equals(info1[0]) && pass.equals(info1[1])) {
	 * session.setAttribute("id", id); session.setAttribute("isLogin", "zzz"); }
	 * else if (id.equals(info2[0]) && pass.equals(info2[1])) {
	 * session.setAttribute("id", id); session.setAttribute("isLogin", "zzz"); }
	 * else { returnURL = "login"; }
	 * 
	 * return returnURL; }
	 */
}
