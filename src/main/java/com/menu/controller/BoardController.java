package com.menu.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.menu.model.BoardDAO;
import com.menu.model.BoardDTO;

@Controller
@RequestMapping("/board")
public class BoardController {
	@Autowired
	BoardDAO boardDAO;

//	final String CATEGORY_INGEE = "ingee";
//	final String CATEGORY_NOTICE = "notice";
//	final String CATEGORY_PHOTO = "photo";
//	final String CATEGORY_VIDEO = "video";
//	final String CATEGORY_TOUR = "tour";
//	final String CATEGORY_NETWORK = "network";
//	final String CATEGORY_WEST = "west";
//	final String CATEGORY_MIDWEST = "midwest";
//	final String CATEGORY_NORTHEAST = "northeast";
//	final String CATEGORY_SOUTH = "south";
	final String CATEGORY_NULL = "";

	@RequestMapping(value = "/{b_category}/list")
	public ModelAndView boardList(@PathVariable String b_category, @RequestParam(defaultValue = "1") int page) {
		int perPage = 5;
		int totalCount = boardDAO.getCount(b_category, CATEGORY_NULL);
		int perBlock = 5;
		int totalPage = totalCount % perPage > 0 ? totalCount / perPage + 1 : totalCount / perPage;
		int startPage;
		int endPage;
		ModelAndView modeAndView = new ModelAndView();
		List<BoardDTO> boardDTOs = boardDAO.list((page - 1) * perPage, perPage, b_category, CATEGORY_NULL);

		startPage = (page - 1) / perBlock * perBlock + 1;
		endPage = startPage + perBlock - 1;

		if (endPage > totalPage)
			endPage = totalPage;

		modeAndView.addObject("currentPage", page);
		modeAndView.addObject("totalCount", totalCount);
		modeAndView.addObject("totalPage", totalPage);
		modeAndView.addObject("startPage", startPage);
		modeAndView.addObject("endPage", endPage);
		modeAndView.addObject("boardList", boardDTOs);
		modeAndView.setViewName("/1/" + b_category + "/list");

		return modeAndView;
	}
	
	@RequestMapping(value = "/{b_category}/{s_category}/list")
	public ModelAndView boardList(@PathVariable String b_category, @PathVariable String s_category, @RequestParam(defaultValue = "1") int page) {
		int perPage = 5;
		int totalCount = boardDAO.getCount(b_category, s_category);
		int perBlock = 5;
		int totalPage = totalCount % perPage > 0 ? totalCount / perPage + 1 : totalCount / perPage;
		int startPage;
		int endPage;
		ModelAndView modeAndView = new ModelAndView();
		List<BoardDTO> boardDTOs = boardDAO.list((page - 1) * perPage, perPage, b_category, s_category);

		startPage = (page - 1) / perBlock * perBlock + 1;
		endPage = startPage + perBlock - 1;

		if (endPage > totalPage)
			endPage = totalPage;

		modeAndView.addObject("currentPage", page);
		modeAndView.addObject("totalCount", totalCount);
		modeAndView.addObject("totalPage", totalPage);
		modeAndView.addObject("startPage", startPage);
		modeAndView.addObject("endPage", endPage);
		modeAndView.addObject("boardList", boardDTOs);
		//modeAndView.setViewName("/1/" + b_category + "/list");

		return modeAndView;
	}
}
