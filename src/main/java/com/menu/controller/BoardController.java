package com.menu.controller;

import java.io.File;
import java.util.List;
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
	final String path = "C:\\Users\\jihyun\\Desktop\\egov\\eGovFrameDev-3.6.0-64bit\\workspace\\InGeeFanClub\\src\\main\\webapp\\resources";

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

	@RequestMapping(value = "/{b_category}/insert", method = RequestMethod.POST)
	public String boardInsert(@PathVariable String b_category, BoardDTO boardDTO) {
		MultipartFile attacehd_file = boardDTO.getUpload_file();
		boardDTO.setB_category(b_category);
		boardDTO.setS_category(CATEGORY_NULL);

		if (!"".equals(attacehd_file.getOriginalFilename())) {
			String originFileName = attacehd_file.getOriginalFilename();
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
			uploadFileWriter.writeFile(attacehd_file, boardPath, saved_filename);
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

	@RequestMapping(value = "/{b_category}/update")
	public String boardUpdate(@PathVariable String b_category, BoardDTO boardDTO,
			@RequestParam(value = "page", defaultValue = "1") int page) {
		if (boardDTO.getUpload_file().getOriginalFilename().equals("")) {
			boardDTO.setOrigin_filename(boardDAO.get(boardDTO.getNum()).getOrigin_filename());
			boardDTO.setSaved_filename(boardDAO.get(boardDTO.getNum()).getSaved_filename());
		} else {
			String boardPath = path + "\\board";
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
