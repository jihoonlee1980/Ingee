package com.menu.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.menu.model.BoardDAO;
import com.menu.model.BoardDTO;
import com.menu.model.MemberDAO;

@Controller
@RequestMapping("/board")
public class BoardController {
	@Autowired
	BoardDAO boardDAO;
	@Autowired
	MemberDAO memberDAO;

	// final String CATEGORY_INGEE = "ingee";
	// final String CATEGORY_NOTICE = "notice";
	// final String CATEGORY_PHOTO = "photo";
	// final String CATEGORY_VIDEO = "video";
	// final String CATEGORY_TOUR = "tour";
	// final String CATEGORY_NETWORK = "network";
	// final String CATEGORY_WEST = "west";
	// final String CATEGORY_MIDWEST = "midwest";
	// final String CATEGORY_NORTHEAST = "northeast";
	// final String CATEGORY_SOUTH = "south";
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

	@RequestMapping(value = "/{b_category}/{board_num}")
	public ModelAndView boardContent(@PathVariable String b_category, @PathVariable int board_num,
			@RequestParam(defaultValue = "1") int page, HttpSession session) {
		String loginID = (String) session.getAttribute("loggedInID");
		String loginNick = (String) session.getAttribute("loginNick");
		BoardDTO boardDTO = boardDAO.get(board_num);
		// List<CommentTO> commentDTOs = commentDAO.commentList(num);
		// List<String> profile_files = new ArrayList<String>();

		// for (CommentDTO commentDTO : commentDTOs) {
		// profile_files.add(memberDAO.get(commentDTO.getWriter()).getSaved_filename());
		// }

		if (!boardDTO.getWriter().equals(loginNick))
			boardDTO = boardDAO.updateReadCount(board_num);

		ModelAndView modelAndView = new ModelAndView();

		if (loginID != null) {
			modelAndView.addObject("loggedInProfile", memberDAO.get(loginID).getSaved_filename());
		}

		// modelAndView.addObject("commentList", commentDTOs);
		// modelAndView.addObject("profile_file", profile_files);
		modelAndView.addObject("boardDTO", boardDTO);
		modelAndView.setViewName("/1/menu/eventContent");

		modelAndView.setViewName("/1/" + b_category + "/content");

		return modelAndView;
	}

	@RequestMapping(value = "/{b_category}/{s_category}/list")
	public ModelAndView boardList(@PathVariable String b_category, @PathVariable String s_category,
			@RequestParam(defaultValue = "1") int page) {
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
		modeAndView.setViewName("/2/" + b_category + "/" + s_category + "/list");

		return modeAndView;
	}
}
