package com.menu.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.menu.model.MessageDAO;
import com.menu.model.MessageDTO;

@RequestMapping("/message")
@Controller
public class MessageController {
	
	@Autowired
	MessageDAO messageDAO;
	
	@RequestMapping("/")
	public ModelAndView Message(HttpSession session ,
			@RequestParam(defaultValue = "1") int page ,
			@RequestParam(defaultValue = "recv") String DISC) {
		ModelAndView modelAndView = new ModelAndView();
		String id = (String)session.getAttribute("loggedInID");
		int perPage = 5;
		int totalCount = messageDAO.getRecvMessageCount(id);
		int perBlock = 5;
		int totalPage = totalCount % perPage > 0 ? totalCount / perPage + 1 : totalCount / perPage;
		int startPage;
		int endPage;
		startPage = (page - 1) / perBlock * perBlock + 1;
		endPage = startPage + perBlock - 1;
		if (endPage > totalPage)
			endPage = totalPage;
		
		if (page > totalPage)
			page = totalPage;
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		map.put("startPage", (page - 1) * perPage);
		map.put("perPage", perPage);
		map.put("DISC", DISC);
		
		List<MessageDTO> messageDTOs = messageDAO.getRecvMessageList(map);
		
		
		modelAndView.addObject("id", id);
		modelAndView.addObject("totalCount", totalCount);
		modelAndView.addObject("currentPage", page);
		modelAndView.addObject("totalPage", totalPage);
		modelAndView.addObject("startPage", startPage);
		modelAndView.addObject("endPage", endPage);
		modelAndView.addObject("messageDTOs" , messageDTOs);
		
		modelAndView.setViewName("/1/message/list");
		return modelAndView;
	}
}
