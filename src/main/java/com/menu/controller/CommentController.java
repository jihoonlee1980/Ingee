package com.menu.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

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

	final int ZERO_COMMENT = 0;

	@RequestMapping(value = "/{b_category}/insert")
	public String insertComment(@PathVariable String b_category, CommentDTO commentDTO,
			@RequestParam(value = "page", defaultValue = "1") int page) {
		commentDAO.insert(commentDTO);

		return "redirect:/board/" + b_category + "/" + commentDTO.getBoard_num() + "?page=" + page;
	}

	@RequestMapping(value = "/{b_category}/update")
	public String updateComment(@PathVariable String b_category, CommentDTO commentDTO,
			@RequestParam(value = "page", defaultValue = "1") int page) {
		commentDAO.update(commentDTO);

		return "redirect:/board/" + b_category + "/" + commentDTO.getBoard_num() + "?page=" + page;
	}

	@RequestMapping(value = "/{b_category}/delete")
	public String deleteComment(@PathVariable String b_category, int num, int board_num,
			@RequestParam(value = "page", defaultValue = "1") int page) {
		commentDAO.delete(num, board_num);

		return "redirect:/board/" + b_category + "/" + board_num + "?page=" + page;
	}

	@RequestMapping(value = "/{b_category}/reply/delete")
	public String deleteReply(@PathVariable String b_category, int num, int board_num, int comment_num,
			@RequestParam(value = "page", defaultValue = "1") int page) {
		commentDAO.deleteReply(num, comment_num);

		return "redirect:/board/" + b_category + "/" + board_num + "?page=" + page;
	}

	@RequestMapping(value = "/{b_category}/reply/list")
	public @ResponseBody Map<String, Object> replyList(@PathVariable String b_category,
			@RequestParam(value = "comment_num", required = true) int comment_num) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<CommentDTO> commentDTOs = commentDAO.list(ZERO_COMMENT, comment_num);
		List<String> profile_files = new ArrayList<String>();

		for (CommentDTO commentDTO : commentDTOs) {
			profile_files
					.add(memberDAO.get(memberDAO.find("nick", commentDTO.getWriter()).getId()).getSaved_filename());
		}

		map.put("profile_files", profile_files);
		map.put("commentDTO", commentDTOs);

		ModelAndView modelAndView = new ModelAndView("jsonView", map);

		return map;
	}

	@RequestMapping(value = "/{b_category}/{s_category}/insert")
	public String insertComment(@PathVariable String b_category, @PathVariable String s_category, CommentDTO commentDTO,
			@RequestParam(value = "page", defaultValue = "1") int page) {
		commentDAO.insert(commentDTO);

		return "redirect:/board/" + b_category + "/" + s_category + "/" + commentDTO.getBoard_num() + "?page=" + page;
	}

	@RequestMapping(value = "/{b_category}/{s_category}/update")
	public String updateComment(@PathVariable String b_category, @PathVariable String s_category, CommentDTO commentDTO,
			@RequestParam(value = "page", defaultValue = "1") int page) {
		commentDAO.update(commentDTO);

		return "redirect:/board/" + b_category + "/" + s_category + "/" + commentDTO.getBoard_num() + "?page=" + page;
	}

	@RequestMapping(value = "/{b_category}/{s_category}/delete")
	public String deleteComment(@PathVariable String b_category, @PathVariable String s_category, int num,
			int board_num, @RequestParam(value = "page", defaultValue = "1") int page) {
		commentDAO.delete(num, board_num);

		return "redirect:/board/" + b_category + "/" + s_category + "/" + board_num + "?page=" + page;
	}

	@RequestMapping(value = "/{b_category}/{s_category}/reply/delete")
	public String deleteReply(@PathVariable String b_category, @PathVariable String s_category, int num, int board_num,
			int comment_num, @RequestParam(value = "page", defaultValue = "1") int page) {
		commentDAO.deleteReply(num, comment_num);

		return "redirect:/board/" + b_category + "/" + board_num + "?page=" + page;
	}

	@RequestMapping(value = "/{b_category}/{s_category}/reply/list")
	public @ResponseBody Map<String, Object> replyList(@PathVariable String b_category, @PathVariable String s_category,
			@RequestParam(value = "comment_num", required = true) int comment_num) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<CommentDTO> commentDTOs = commentDAO.list(ZERO_COMMENT, comment_num);
		List<String> profile_files = new ArrayList<String>();

		for (CommentDTO commentDTO : commentDTOs) {
			profile_files
					.add(memberDAO.get(memberDAO.find("nick", commentDTO.getWriter()).getId()).getSaved_filename());
		}

		map.put("profile_files", profile_files);
		map.put("commentDTO", commentDTOs);

		ModelAndView modelAndView = new ModelAndView("jsonView", map);

		return map;
	}
}
