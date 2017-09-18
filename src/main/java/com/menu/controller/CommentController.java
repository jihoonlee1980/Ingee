package com.menu.controller;

import java.awt.image.BufferedImage;
import java.awt.image.BufferedImageOp;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.imgscalr.Scalr;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.ingee.util.UploadFileWriter;
import com.menu.model.BoardDAO;
import com.menu.model.CommentDAO;
import com.menu.model.CommentDTO;
import com.menu.model.MemberDAO;
import com.nhncorp.lucy.security.xss.XssPreventer;

@Controller
@RequestMapping("/comment")
public class CommentController {
	@Autowired
	CommentDAO commentDAO;
	@Autowired
	MemberDAO memberDAO;
	@Autowired
	BoardDAO boardDAO;

	final String path = "/home/hosting_users/ingeefanclub/tomcat/webapps/ROOT/resources";
	// final String path =
	// "/home/ubuntu/apache-tomcat-8.0.46/webapps/Ingee/resources";
	//final String path = "C:\\Users\\jihyun\\Desktop\\egov\\eGovFrameDev-3.6.0-64bit\\workspace\\InGeeFanClub\\src\\main\\webapp\\resources";
	final int ZERO_COMMENT = 0;

	@RequestMapping(value = "/{b_category}/insert", method = RequestMethod.POST)
	public String insertComment(@PathVariable String b_category, CommentDTO commentDTO,
			@RequestParam(value = "page", defaultValue = "1") int page) throws IOException {
		commentDTO.setContent(XssPreventer.escape(commentDTO.getContent()));
		MultipartFile upload_file = commentDTO.getUpload_file();

		if (!"".equals(upload_file.getOriginalFilename())) {
			String originFileName = upload_file.getOriginalFilename();
			String extension = originFileName.substring(originFileName.lastIndexOf("."));
			String commentPath = path + "/comment";
			String saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000
					+ extension;

			while (commentDAO.find("saved_filename", saved_filename)) {
				saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000
						+ extension;
			}

			commentDTO.setOrigin_filename(originFileName);
			commentDTO.setSaved_filename(saved_filename);

			UploadFileWriter uploadFileWriter = new UploadFileWriter();
			uploadFileWriter.writeFile(upload_file, commentPath, originFileName);

			File img_file = new File(commentPath + "/" + originFileName);
			BufferedImage img = ImageIO.read(img_file);

			if (img.getWidth() > 300) {
				int newWidth = 300;

				BufferedImage newImg = Scalr.resize(img, newWidth);
				ImageIO.write(newImg, extension.replace(".", ""), new File(commentPath + "/" + saved_filename));

				if (img_file.exists())
					img_file.delete();
			} else {
				img_file.renameTo(new File(commentPath + "/" + saved_filename));
			}
		} else {
			commentDTO.setSaved_filename("NO");
		}

		commentDAO.insert(commentDTO);

		return "redirect:/board/" + b_category + "/" + commentDTO.getBoard_num() + "?page=" + page;
	}

	@RequestMapping(value = "/{b_category}/update", method = RequestMethod.POST)
	public String updateComment(@PathVariable String b_category, CommentDTO commentDTO,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "remove_file", required = false) String remove_file) throws IOException {
		commentDTO.setContent(XssPreventer.escape(commentDTO.getContent()));
		String commentPath = path + "/comment";
		CommentDTO dbDTO = commentDAO.get(commentDTO.getNum());

		if (remove_file != null) {
			StringTokenizer remove_files = new StringTokenizer(remove_file, ",");

			while (remove_files.hasMoreTokens()) {
				String filename = remove_files.nextToken();
				File file = new File(commentPath + "/" + filename);
				if (file.exists())
					file.delete();
				dbDTO.setSaved_filename(dbDTO.getSaved_filename().replaceAll(filename, ""));
				dbDTO.setSaved_filename(dbDTO.getSaved_filename().replaceAll(",,", ","));
			}
		}

		if (commentDTO.getUpload_file().getOriginalFilename().equals("")) {
			commentDTO.setSaved_filename(dbDTO.getSaved_filename().equals("") ? "NO" : dbDTO.getSaved_filename());
			commentDTO.setOrigin_filename(dbDTO.getSaved_filename().equals("") ? "" : dbDTO.getOrigin_filename());
		} else {
			MultipartFile upload_file = commentDTO.getUpload_file();
			File file = new File(commentPath + "/" + commentDAO.get(commentDTO.getNum()).getSaved_filename());

			if (file.exists())
				file.delete();

			if (!"".equals(upload_file.getOriginalFilename())) {
				String originFileName = upload_file.getOriginalFilename();
				String extension = originFileName.substring(originFileName.lastIndexOf("."));
				String saved_filename = UUID.randomUUID().toString().split("-")[0]
						+ System.currentTimeMillis() % 10000000 + extension;

				while (commentDAO.find("saved_filename", saved_filename)) {
					saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000
							+ extension;
				}

				commentDTO.setOrigin_filename(originFileName);
				commentDTO.setSaved_filename(saved_filename);

				UploadFileWriter uploadFileWriter = new UploadFileWriter();
				uploadFileWriter.writeFile(upload_file, commentPath, originFileName);

				File img_file = new File(commentPath + "/" + originFileName);
				BufferedImage img = ImageIO.read(img_file);

				if (img.getWidth() > 300) {
					int newWidth = 300;

					BufferedImage newImg = Scalr.resize(img, newWidth);
					ImageIO.write(newImg, extension.replace(".", ""), new File(commentPath + "/" + saved_filename));

					if (img_file.exists())
						img_file.delete();
				} else {
					img_file.renameTo(new File(commentPath + "/" + saved_filename));
				}
			}
		}
		commentDAO.update(commentDTO);

		return "redirect:/board/" + b_category + "/" + commentDTO.getBoard_num() + "?page=" + page;
	}

	@RequestMapping(value = "/{b_category}/delete")
	public String deleteComment(@PathVariable String b_category, int num, int board_num,
			@RequestParam(value = "page", defaultValue = "1") int page) {
		String savedFileName = commentDAO.get(num).getSaved_filename();
		File file = new File(path + "/comment/" + savedFileName);

		if (file.exists())
			file.delete();

		commentDAO.delete(num, board_num);

		return "redirect:/board/" + b_category + "/" + board_num + "?page=" + page;
	}

	@RequestMapping(value = "/{b_category}/reply/delete")
	public String deleteReply(@PathVariable String b_category, int num, int board_num, int comment_num,
			@RequestParam(value = "page", defaultValue = "1") int page) {
		String savedFileName = commentDAO.get(num).getSaved_filename();
		File file = new File(path + "/comment/" + savedFileName);

		if (file.exists())
			file.delete();

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
			@RequestParam(value = "page", defaultValue = "1") int page) throws IOException {
		commentDTO.setContent(XssPreventer.escape(commentDTO.getContent()));

		MultipartFile upload_file = commentDTO.getUpload_file();

		if (!"".equals(upload_file.getOriginalFilename())) {
			String originFileName = upload_file.getOriginalFilename();
			String extension = originFileName.substring(originFileName.lastIndexOf("."));
			String commentPath = path + "/comment";
			String saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000
					+ extension;

			while (commentDAO.find("saved_filename", saved_filename)) {
				saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000
						+ extension;
			}

			commentDTO.setOrigin_filename(originFileName);
			commentDTO.setSaved_filename(saved_filename);

			UploadFileWriter uploadFileWriter = new UploadFileWriter();
			uploadFileWriter.writeFile(upload_file, commentPath, originFileName);

			File img_file = new File(commentPath + "/" + originFileName);
			BufferedImage img = ImageIO.read(img_file);

			if (img.getWidth() > 300) {
				int newWidth = 300;

				BufferedImage newImg = Scalr.resize(img, newWidth);
				ImageIO.write(newImg, extension.replace(".", ""), new File(commentPath + "/" + saved_filename));

				if (img_file.exists())
					img_file.delete();
			} else {
				img_file.renameTo(new File(commentPath + "/" + saved_filename));
			}
		} else {
			commentDTO.setSaved_filename("NO");
		}

		commentDAO.insert(commentDTO);

		return "redirect:/board/" + b_category + "/" + s_category + "/" + commentDTO.getBoard_num() + "?page=" + page;
	}

	@RequestMapping(value = "/{b_category}/{s_category}/update")
	public String updateComment(@PathVariable String b_category, @PathVariable String s_category, CommentDTO commentDTO,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "remove_file", required = false) String remove_file) throws IOException {
		commentDTO.setContent(XssPreventer.escape(commentDTO.getContent()));
		String commentPath = path + "/comment";
		CommentDTO dbDTO = commentDAO.get(commentDTO.getNum());

		if (remove_file != null) {
			StringTokenizer remove_files = new StringTokenizer(remove_file, ",");

			while (remove_files.hasMoreTokens()) {
				String filename = remove_files.nextToken();
				File file = new File(commentPath + "/" + filename);
				if (file.exists())
					file.delete();
				dbDTO.setSaved_filename(dbDTO.getSaved_filename().replaceAll(filename, ""));
				dbDTO.setSaved_filename(dbDTO.getSaved_filename().replaceAll(",,", ","));
			}
		}

		if (commentDTO.getUpload_file().getOriginalFilename().equals("")) {
			commentDTO.setSaved_filename(dbDTO.getSaved_filename().equals("") ? "NO" : dbDTO.getSaved_filename());
			commentDTO.setOrigin_filename(dbDTO.getSaved_filename().equals("") ? "" : dbDTO.getOrigin_filename());
		} else {
			MultipartFile upload_file = commentDTO.getUpload_file();
			File file = new File(commentPath + "/" + commentDAO.get(commentDTO.getNum()).getSaved_filename());

			if (file.exists())
				file.delete();

			if (!"".equals(upload_file.getOriginalFilename())) {
				String originFileName = upload_file.getOriginalFilename();
				String extension = originFileName.substring(originFileName.lastIndexOf("."));
				String saved_filename = UUID.randomUUID().toString().split("-")[0]
						+ System.currentTimeMillis() % 10000000 + extension;

				while (commentDAO.find("saved_filename", saved_filename)) {
					saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000
							+ extension;
				}

				commentDTO.setOrigin_filename(originFileName);
				commentDTO.setSaved_filename(saved_filename);

				UploadFileWriter uploadFileWriter = new UploadFileWriter();
				uploadFileWriter.writeFile(upload_file, commentPath, originFileName);

				File img_file = new File(commentPath + "/" + originFileName);
				BufferedImage img = ImageIO.read(img_file);

				if (img.getWidth() > 300) {
					int newWidth = 300;

					BufferedImage newImg = Scalr.resize(img, newWidth);
					ImageIO.write(newImg, extension.replace(".", ""), new File(commentPath + "/" + saved_filename));

					if (img_file.exists())
						img_file.delete();
				} else {
					img_file.renameTo(new File(commentPath + "/" + saved_filename));
				}
			}
		}
		commentDAO.update(commentDTO);

		return "redirect:/board/" + b_category + "/" + s_category + "/" + commentDTO.getBoard_num() + "?page=" + page;
	}

	@RequestMapping(value = "/{b_category}/{s_category}/delete")
	public String deleteComment(@PathVariable String b_category, @PathVariable String s_category, int num,
			int board_num, @RequestParam(value = "page", defaultValue = "1") int page) {
		String savedFileName = commentDAO.get(num).getSaved_filename();
		File file = new File(path + "/comment/" + savedFileName);

		if (file.exists())
			file.delete();

		commentDAO.delete(num, board_num);

		return "redirect:/board/" + b_category + "/" + s_category + "/" + board_num + "?page=" + page;
	}

	@RequestMapping(value = "/{b_category}/{s_category}/reply/delete")
	public String deleteReply(@PathVariable String b_category, @PathVariable String s_category, int num, int board_num,
			int comment_num, @RequestParam(value = "page", defaultValue = "1") int page) {
		String savedFileName = commentDAO.get(num).getSaved_filename();
		File file = new File(path + "/comment/" + savedFileName);

		if (file.exists())
			file.delete();

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
