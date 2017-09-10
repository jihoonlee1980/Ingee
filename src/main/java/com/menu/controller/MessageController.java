package com.menu.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.menu.model.MessageDAO;
import com.menu.model.MessageDTO;
import com.nhncorp.lucy.security.xss.XssPreventer;


@Controller
@RequestMapping("/message")
public class MessageController {
	
	@Autowired
	MessageDAO messageDAO;
	
	@RequestMapping(value="/" , method = {RequestMethod.POST , RequestMethod.GET})
	public ModelAndView Message(HttpSession session ,
			@RequestParam(defaultValue = "1") int page ,
			@RequestParam(defaultValue = "recv") String DISC ,
			@RequestParam(defaultValue = "") String keyword ,
			@RequestParam(defaultValue = "") String searchType) {
		ModelAndView modelAndView = new ModelAndView();
		keyword = XssPreventer.escape(keyword);
		String id = (String)session.getAttribute("loggedInID");
		int perPage = 5;
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		map.put("DISC", DISC);
		map.put("keyword", keyword);
		map.put("searchType", searchType);
		int totalCount = messageDAO.getRecvMessageCount(map);
		int perBlock = 5;
		int totalPage = totalCount % perPage > 0 ? totalCount / perPage + 1 : totalCount / perPage;
		int startPage;
		int endPage;
		startPage = (page - 1) / perBlock * perBlock + 1;
		endPage = startPage + perBlock - 1;
		if (endPage > totalPage)
			endPage = totalPage;		
		
		map = new HashMap<String, Object>();
		map.put("id", id);
		map.put("startPage", (page - 1) * perPage);
		map.put("perPage", perPage);
		map.put("DISC", DISC);
		map.put("keyword", keyword);
		map.put("searchType", searchType);
		List<MessageDTO> messageDTOs = messageDAO.getRecvMessageList(map);	
		if (page > totalPage)
			page = totalPage;
		modelAndView.addObject("id", id);
		modelAndView.addObject("totalCount", totalCount);
		modelAndView.addObject("currentPage", page);
		modelAndView.addObject("totalPage", totalPage);
		modelAndView.addObject("startPage", startPage);
		modelAndView.addObject("endPage", endPage);
		modelAndView.addObject("messageDTOs" , messageDTOs);
		modelAndView.addObject("DISC" , DISC);
		modelAndView.addObject("keyword",keyword);
		modelAndView.addObject("searchType",searchType);
		modelAndView.setViewName("/1/message/list");
		return modelAndView;
	}
	
	@RequestMapping(value="/send" , method = {RequestMethod.POST , RequestMethod.GET})
	public ModelAndView MessageSend (HttpSession session , @RequestParam Map<String,Object> map , RedirectAttributes redirectAttributes) {		
		ModelAndView modelAndView = new ModelAndView();
		String id = (String)session.getAttribute("loggedInID");
		modelAndView.addObject("id",id);		
		String setViewName = "/1/message/send";
		if(!map.isEmpty()){			
			if(map.get("recvlist").toString().equals(""))
				map.put("DISC", "single");
			else if(map.get("recvlist").toString().equals("all")){
				map.put("DISC", "all");	
				map.put("id",id);
			}
			else
				map.put("DISC", "multi");	
			int result = messageDAO.sendMessage(map);
			if(result > 0){
				modelAndView.clear();
				setViewName = "redirect:/message/";
			}
			else
				redirectAttributes.addFlashAttribute("failed", "insert");
		}
		
		
		modelAndView.setViewName(setViewName);
		return modelAndView;
	}
	
	@RequestMapping(value="/content")
	public ModelAndView MessageContent (@RequestParam Map<String, Object> map) {
		ModelAndView modelAndView = new ModelAndView();
		String setViewName = "/1/message/content";
		HashMap<String, Object> resultMap = messageDAO.getMessageContent(Integer.parseInt(map.get("num").toString()));
		modelAndView.addObject("resultMap", resultMap);
		modelAndView.setViewName(setViewName);
		return modelAndView;
	};
	
	@RequestMapping(value="/delete")
	public @ResponseBody Map<String, Object> MessageDelete (@RequestParam List<Integer> arrData) {
				
		int result = messageDAO.delteMessage(arrData);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("resultCheck", result);
		
		ModelAndView modelAndView = new ModelAndView("jsonView", map);

		return map;
	}
	
	@RequestMapping(value = "/check/id")
	public @ResponseBody Map<String, Object> checkID(@RequestParam List<String> arrData) {
		List<String> resultList = messageDAO.checkId(arrData);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("resultList", resultList);

		ModelAndView modelAndView = new ModelAndView("jsonView", map);

		return map;
	}
	@RequestMapping(value = "/check/id/single")
	public @ResponseBody Map<String, Object> checkID(@RequestParam String id) {
		boolean check = messageDAO.checkIdSingle(id);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		map.put("resultCheck", check);
		ModelAndView modelAndView = new ModelAndView("jsonView", map);

		return map;
	}
}
