package com.menu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.menu.model.BoardDAO;
import com.menu.model.CommentDAO;
import com.menu.model.CommentDTO;
import com.menu.model.MemberDAO;

@Controller
@RequestMapping("/comment")
public class CommentController {
	@Autowired
	CommentDAO commentDAO;
	@Autowired
	MemberDAO memberDAO;
	@Autowired
	BoardDAO boardDAO;

	@RequestMapping(value = "/{b_category}/insert")
	public String insertComment(@PathVariable String b_category, CommentDTO commentDTO,
			@RequestParam(value = "page", defaultValue = "1") int page) {
		commentDAO.insert(commentDTO);

		return "redirect:/board/" + b_category + "/" + commentDTO.getBoard_num() + "?page=" + page;
	}
}
