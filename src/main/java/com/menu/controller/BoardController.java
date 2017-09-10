package com.menu.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.ingee.util.UploadFileWriter;
import com.menu.model.BoardDAO;
import com.menu.model.BoardDTO;
import com.menu.model.CommentDAO;
import com.menu.model.CommentDTO;
import com.menu.model.MemberDAO;
import com.menu.model.MemberDTO;
import com.nhncorp.lucy.security.xss.XssFilter;
import com.nhncorp.lucy.security.xss.XssPreventer;

@Controller
@RequestMapping("/board")
public class BoardController {
	@Autowired
	BoardDAO boardDAO;
	@Autowired
	MemberDAO memberDAO;
	@Autowired
	CommentDAO commentDAO;

	final String CATEGORY_NULL = "";
	final String path = "C:\\Users\\jihyun\\Desktop\\egov\\eGovFrameDev-3.6.0-64bit\\workspace\\InGeeFanClub\\src\\main\\webapp\\resources";
	final int ZERO_COMMENT = 0;

	@RequestMapping(value = "/{b_category}/list")
	public ModelAndView boardList(@PathVariable String b_category,
			@RequestParam(value = "search_type", required = false) String search_type,
			@RequestParam(value = "keyword", required = false) String keyword,
			@RequestParam(defaultValue = "1") int page) {
		int perPage = 5;
		int totalCount;
		List<BoardDTO> boardDTOs;
		
		if (search_type == null || keyword == null) {
			totalCount = boardDAO.getCount(b_category, CATEGORY_NULL);
			boardDTOs = boardDAO.list((page - 1) * perPage, perPage, b_category, CATEGORY_NULL);
		} else {
			totalCount = boardDAO.getCount(b_category, CATEGORY_NULL, search_type, keyword);
			boardDTOs = boardDAO.list((page - 1) * perPage, perPage, b_category, CATEGORY_NULL, search_type, keyword);
		}

		int perBlock = 5;
		int totalPage = totalCount % perPage > 0 ? totalCount / perPage + 1 : totalCount / perPage;
		int startPage;
		int endPage;
		ModelAndView modelAndView = new ModelAndView();

		startPage = (page - 1) / perBlock * perBlock + 1;
		endPage = startPage + perBlock - 1;

		if (endPage > totalPage)
			endPage = totalPage;

		modelAndView.addObject("currentPage", page);
		modelAndView.addObject("totalCount", totalCount);
		modelAndView.addObject("totalPage", totalPage);
		modelAndView.addObject("startPage", startPage);
		modelAndView.addObject("endPage", endPage);
		modelAndView.addObject("boardList", boardDTOs);
		modelAndView.setViewName("/1/" + b_category + "/list");

		return modelAndView;
	}

	@RequestMapping(value = "/{b_category}/insert", method = RequestMethod.POST)
	public String boardInsert(@PathVariable String b_category, BoardDTO boardDTO) {
		MultipartFile upload_file = boardDTO.getUpload_file();
		boardDTO.setB_category(b_category);
		boardDTO.setS_category(CATEGORY_NULL);
		boardDTO.setSubject(XssPreventer.escape(boardDTO.getSubject()));
		boardDTO.setContent(XssPreventer.escape(boardDTO.getContent()));

		if (!"".equals(upload_file.getOriginalFilename())) {
			String originFileName = upload_file.getOriginalFilename();
			String extension = originFileName.substring(originFileName.lastIndexOf("."));
			String boardPath = path + "\\board";
			String saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000
					+ extension;

			while (boardDAO.find("saved_filename", saved_filename)) {
				saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000;
			}

			boardDTO.setOrigin_filename(originFileName);
			boardDTO.setSaved_filename(saved_filename);

			UploadFileWriter uploadFileWriter = new UploadFileWriter();
			uploadFileWriter.writeFile(upload_file, boardPath, saved_filename);
		} else {
			boardDTO.setSaved_filename("NO");
		}

		boardDAO.insert(boardDTO);

		return "redirect:/board/" + b_category + "/list";
	}

	@RequestMapping(value = "/{b_category}/{board_num}")
	public ModelAndView boardContent(@PathVariable String b_category, @PathVariable int board_num,
			@RequestParam(defaultValue = "1") int page, HttpSession session) {
		String loginID = (String) session.getAttribute("loggedInID");
		String loginNick = (String) session.getAttribute("loginNick");
		BoardDTO boardDTO = boardDAO.get(board_num);
		List<CommentDTO> commentDTOs = commentDAO.list(board_num, ZERO_COMMENT);
		List<String> profile_files = new ArrayList<String>();

		for (CommentDTO commentDTO : commentDTOs) {
			profile_files
					.add(memberDAO.get(memberDAO.find("nick", commentDTO.getWriter()).getId()).getSaved_filename());
		}

		if (!boardDTO.getWriter().equals(loginNick))
			boardDTO = boardDAO.updateReadCount(board_num);

		ModelAndView modelAndView = new ModelAndView();

		if (loginID != null) {
			modelAndView.addObject("loggedInProfile", memberDAO.get(loginID).getSaved_filename());
		}

		modelAndView.addObject("commentList", commentDTOs);
		modelAndView.addObject("profile_file", profile_files);
		modelAndView.addObject("boardDTO", boardDTO);
		modelAndView.setViewName("/1/" + b_category + "/content");

		return modelAndView;
	}

	@RequestMapping(value = "/{b_category}/update")
	public String boardUpdate(@PathVariable String b_category, BoardDTO boardDTO,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "remove_file", required = false) String remove_file) {
		String boardPath = path + "\\board";
		BoardDTO dbDTO = boardDAO.get(boardDTO.getNum());
		boardDTO.setSubject(XssPreventer.escape(boardDTO.getSubject()));
		boardDTO.setContent(XssPreventer.escape(boardDTO.getContent()));
		if (remove_file != null) {
			StringTokenizer remove_files = new StringTokenizer(remove_file, ",");

			while (remove_files.hasMoreTokens()) {
				String filename = remove_files.nextToken();
				File file = new File(boardPath + "\\" + filename);
				if (file.exists())
					file.delete();
				dbDTO.setSaved_filename(dbDTO.getSaved_filename().replaceAll(filename, ""));
				dbDTO.setSaved_filename(dbDTO.getSaved_filename().replaceAll(",,", ","));
			}
		}

		if (boardDTO.getUpload_file().getOriginalFilename().equals("")) {
			boardDTO.setSaved_filename(dbDTO.getSaved_filename().equals("") ? "NO" : dbDTO.getSaved_filename());
			boardDTO.setOrigin_filename(dbDTO.getSaved_filename().equals("") ? "" : dbDTO.getOrigin_filename());
			// boardDTO.setOrigin_filename(boardDAO.get(boardDTO.getNum()).getOrigin_filename());
			// boardDTO.setSaved_filename(boardDAO.get(boardDTO.getNum()).getSaved_filename());
		} else {
			MultipartFile upload_file = boardDTO.getUpload_file();
			File file = new File(boardPath + "\\" + boardDAO.get(boardDTO.getNum()).getSaved_filename());

			if (file.exists())
				file.delete();

			if (!"".equals(upload_file.getOriginalFilename())) {
				String originFileName = upload_file.getOriginalFilename();
				String extension = originFileName.substring(originFileName.lastIndexOf("."));
				String saved_filename = UUID.randomUUID().toString().split("-")[0]
						+ System.currentTimeMillis() % 10000000 + extension;

				while (boardDAO.find("saved_filename", saved_filename)) {
					saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000;
				}

				boardDTO.setOrigin_filename(originFileName);
				boardDTO.setSaved_filename(saved_filename);

				UploadFileWriter uploadFileWriter = new UploadFileWriter();
				uploadFileWriter.writeFile(upload_file, boardPath, saved_filename);
			}
		}
		boardDAO.update(boardDTO);

		return "redirect:/board/" + b_category + "/" + boardDTO.getNum() + "?page=" + page;
	}

	@RequestMapping(value = "/{b_category}/delete")
	public String boardDelete(@PathVariable String b_category, @RequestParam(value = "num", required = true) int num,
			@RequestParam(value = "page", defaultValue = "1") int page) {
		String savedFileName = boardDAO.get(num).getSaved_filename();
		File file = new File(path + "\\board\\" + savedFileName);

		if (file.exists())
			file.delete();

		boardDAO.delete(num);

		return "redirect:/board/" + b_category + "/list?page=" + page;
	}

	@RequestMapping(value = "/{b_category}/{s_category}/list")
	public ModelAndView boardList(@PathVariable String b_category, @PathVariable String s_category,
			@RequestParam(value = "search_type", required = false) String search_type,
			@RequestParam(value = "keyword", required = false) String keyword,
			@RequestParam(defaultValue = "1") int page) {
		int perPage = 5;
		int totalCount;
		List<BoardDTO> boardDTOs;
		
		if (search_type == null || keyword == null) {
			totalCount = boardDAO.getCount(b_category, s_category);
			boardDTOs = boardDAO.list((page - 1) * perPage, perPage, b_category, s_category);
		} else {
			totalCount = boardDAO.getCount(b_category, s_category, search_type, keyword);
			boardDTOs = boardDAO.list((page - 1) * perPage, perPage, b_category, s_category, search_type, keyword);
		}

		int perBlock = 5;
		int totalPage = totalCount % perPage > 0 ? totalCount / perPage + 1 : totalCount / perPage;
		int startPage;
		int endPage;
		ModelAndView modelAndView = new ModelAndView();

		startPage = (page - 1) / perBlock * perBlock + 1;
		endPage = startPage + perBlock - 1;

		if (endPage > totalPage)
			endPage = totalPage;

		modelAndView.addObject("currentPage", page);
		modelAndView.addObject("totalCount", totalCount);
		modelAndView.addObject("totalPage", totalPage);
		modelAndView.addObject("startPage", startPage);
		modelAndView.addObject("endPage", endPage);
		modelAndView.addObject("boardList", boardDTOs);
		modelAndView.setViewName("/2/" + b_category + "/" + s_category + "/list");

		return modelAndView;
	}

	@RequestMapping(value = "/{b_category}/{s_category}/insert", method = RequestMethod.POST)
	public String boardInsert(@PathVariable String b_category, @PathVariable String s_category, BoardDTO boardDTO) {
		MultipartFile upload_file = boardDTO.getUpload_file();
		boardDTO.setB_category(b_category);
		boardDTO.setS_category(s_category);
		boardDTO.setSubject(XssPreventer.escape(boardDTO.getSubject()));
		boardDTO.setContent(XssPreventer.escape(boardDTO.getContent()));

		if (!"".equals(upload_file.getOriginalFilename())) {
			String originFileName = upload_file.getOriginalFilename();
			String extension = originFileName.substring(originFileName.lastIndexOf("."));
			String boardPath = path + "\\board";
			String saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000
					+ extension;

			while (boardDAO.find("saved_filename", saved_filename)) {
				saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000;
			}

			boardDTO.setOrigin_filename(originFileName);
			boardDTO.setSaved_filename(saved_filename);

			UploadFileWriter uploadFileWriter = new UploadFileWriter();
			uploadFileWriter.writeFile(upload_file, boardPath, saved_filename);
		} else {
			boardDTO.setSaved_filename("NO");
		}

		boardDAO.insert(boardDTO);

		return "redirect:/board/" + b_category + "/" + s_category + "/list";
	}

	@RequestMapping(value = "/{b_category}/{s_category}/{board_num}")
	public ModelAndView boardContent(@PathVariable String b_category, @PathVariable String s_category,
			@PathVariable int board_num, @RequestParam(defaultValue = "1") int page, HttpSession session) {
		String loginID = (String) session.getAttribute("loggedInID");
		String loginNick = (String) session.getAttribute("loginNick");
		BoardDTO boardDTO = boardDAO.get(board_num);
		List<CommentDTO> commentDTOs = commentDAO.list(board_num, ZERO_COMMENT);
		List<String> profile_files = new ArrayList<String>();

		for (CommentDTO commentDTO : commentDTOs) {
			profile_files
					.add(memberDAO.get(memberDAO.find("nick", commentDTO.getWriter()).getId()).getSaved_filename());
		}

		if (!boardDTO.getWriter().equals(loginNick))
			boardDTO = boardDAO.updateReadCount(board_num);

		ModelAndView modelAndView = new ModelAndView();

		if (loginID != null) {
			modelAndView.addObject("loggedInProfile", memberDAO.get(loginID).getSaved_filename());
		}

		modelAndView.addObject("commentList", commentDTOs);
		modelAndView.addObject("profile_file", profile_files);
		modelAndView.addObject("boardDTO", boardDTO);
		modelAndView.setViewName("/2/" + b_category + "/" + s_category + "/content");

		return modelAndView;
	}

	@RequestMapping(value = "/{b_category}/{s_category}/update")
	public String boardUpdate(@PathVariable String b_category, @PathVariable String s_category, BoardDTO boardDTO,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "remove_file", required = false) String remove_file) {
		String boardPath = path + "\\board";
		boardDTO.setSubject(XssPreventer.escape(boardDTO.getSubject()));
		boardDTO.setContent(XssPreventer.escape(boardDTO.getContent()));
		BoardDTO dbDTO = boardDAO.get(boardDTO.getNum());
		if (remove_file != null) {
			StringTokenizer remove_files = new StringTokenizer(remove_file, ",");

			while (remove_files.hasMoreTokens()) {
				String filename = remove_files.nextToken();
				File file = new File(boardPath + "\\" + filename);
				if (file.exists())
					file.delete();
				dbDTO.setSaved_filename(dbDTO.getSaved_filename().replaceAll(filename, ""));
				dbDTO.setSaved_filename(dbDTO.getSaved_filename().replaceAll(",,", ","));
			}
		}

		if (boardDTO.getUpload_file().getOriginalFilename().equals("")) {
			boardDTO.setSaved_filename(dbDTO.getSaved_filename().equals("") ? "NO" : dbDTO.getSaved_filename());
			boardDTO.setOrigin_filename(dbDTO.getSaved_filename().equals("") ? "" : dbDTO.getOrigin_filename());
			// boardDTO.setOrigin_filename(boardDAO.get(boardDTO.getNum()).getOrigin_filename());
			// boardDTO.setSaved_filename(boardDAO.get(boardDTO.getNum()).getSaved_filename());
		} else {
			MultipartFile upload_file = boardDTO.getUpload_file();
			File file = new File(boardPath + "\\" + boardDAO.get(boardDTO.getNum()).getSaved_filename());

			if (file.exists())
				file.delete();

			if (!"".equals(upload_file.getOriginalFilename())) {
				String originFileName = upload_file.getOriginalFilename();
				String extension = originFileName.substring(originFileName.lastIndexOf("."));
				String saved_filename = UUID.randomUUID().toString().split("-")[0]
						+ System.currentTimeMillis() % 10000000 + extension;

				while (boardDAO.find("saved_filename", saved_filename)) {
					saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000;
				}

				boardDTO.setOrigin_filename(originFileName);
				boardDTO.setSaved_filename(saved_filename);

				UploadFileWriter uploadFileWriter = new UploadFileWriter();
				uploadFileWriter.writeFile(upload_file, boardPath, saved_filename);
			}
		}
		boardDAO.update(boardDTO);

		return "redirect:/board/" + b_category + "/" + s_category + "/" + boardDTO.getNum() + "?page=" + page;
	}

	@RequestMapping(value = "/{b_category}/{s_category}/delete")
	public String boardDelete(@PathVariable String b_category, @PathVariable String s_category,
			@RequestParam(value = "num", required = true) int num,
			@RequestParam(value = "page", defaultValue = "1") int page) {
		String savedFileName = boardDAO.get(num).getSaved_filename();
		File file = new File(path + "\\board\\" + savedFileName);

		if (file.exists())
			file.delete();

		boardDAO.delete(num);

		return "redirect:/board/" + b_category + "/" + s_category + "/list?page=" + page;
	}
}
