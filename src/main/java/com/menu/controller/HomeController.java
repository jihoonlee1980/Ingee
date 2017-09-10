package com.menu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.menu.model.BoardDAO;

@Controller
public class HomeController {
	@Autowired
	BoardDAO boardDAO;

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView main() {
		ModelAndView modelAndView = new ModelAndView();

		modelAndView.addObject("boardList", boardDAO.mainList());
		modelAndView.setViewName("tempLayout");

		return modelAndView;
	}
}