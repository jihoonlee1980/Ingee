package com.menu.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.UUID;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ingee.util.MailSender;
import com.ingee.util.UploadFileWriter;
import com.menu.model.BoardDAO;
import com.menu.model.BoardDTO;
import com.menu.model.CommentDAO;
import com.menu.model.MemberDAO;
import com.menu.model.MemberDTO;
import com.nhncorp.lucy.security.xss.XssPreventer;

@Controller
@RequestMapping("/member")
public class MemberController {
	@Autowired
	MemberDAO memberDAO;
	@Autowired
	CommentDAO commentDAO;
	@Autowired
	BoardDAO boardDAO;
	@Autowired
	JavaMailSenderImpl mailSender;

	// final String path =
	// "/home/hosting_users/ingeefanclub/tomcat/webapps/ROOT/resources";
	// final String path =
	// "/home/ubuntu/apache-tomcat-8.0.46/webapps/ROOT/resources";
	final String path = "C:\\Users\\jihyun\\Desktop\\egov\\eGovFrameDev-3.6.0-64bit\\workspace\\InGeeFanClub\\src\\main\\webapp\\resources";
	// final String path =
	// "C:\\Users\\뢰후니\\git\\Ingee\\src\\main\\webapp\\resources";

	@RequestMapping(value = "/login", method = RequestMethod.GET)

	public ModelAndView loginForm(HttpSession session,
			@RequestParam(value = "result", required = false) Integer result) {
		ModelAndView modelAndView = new ModelAndView();
		String returnURL = "/1/member/login";

		if (result != null) {
			modelAndView.addObject("result", result);
		}

		if (session.getAttribute("isLogin") != null)
			returnURL = "redirect:/";

		modelAndView.setViewName(returnURL);
		return modelAndView;
	}

	@RequestMapping(value = "/join", method = RequestMethod.GET)
	public String joinForm() {
		return "/1/member/join";
	}

	@RequestMapping(value = "/check/id")
	public @ResponseBody Map<String, Object> checkID(@RequestParam(value = "id", required = true) String id) {
		Map<String, Object> map = new HashMap<String, Object>();
		boolean isValid = memberDAO.find("id", id) != null;

		map.put("isValid", !isValid);

		ModelAndView modelAndView = new ModelAndView("jsonView", map);

		return map;
	}

	@RequestMapping(value = "/check/nick")
	public @ResponseBody Map<String, Object> checkNick(@RequestParam(value = "nick", required = true) String nick) {
		Map<String, Object> map = new HashMap<String, Object>();
		boolean isValid = memberDAO.find("nick", nick) != null;

		map.put("isValid", !isValid);

		ModelAndView modelAndView = new ModelAndView("jsonView", map);

		return map;
	}

	@RequestMapping(value = "/check/pass", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> checkPss(@RequestParam(value = "num", required = true) int num,
			@RequestParam(value = "pass", required = true) String pass) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("result", memberDAO.checkPass(num, pass.toLowerCase()));

		ModelAndView modelAndView = new ModelAndView("jsonView", map);

		return map;
	}

	@RequestMapping(value = "/join/proc", method = RequestMethod.POST)
	public String joinProc(MemberDTO memberDTO, RedirectAttributes redirectAttributes) {
		MultipartFile profile_file = memberDTO.getProfile_file();

		if (!"".equals(profile_file.getOriginalFilename())) {
			String originFileName = profile_file.getOriginalFilename();
			String extension = originFileName.substring(originFileName.lastIndexOf("."));
			String profilePath = path + "/profile";
			String saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000
					+ extension;

			while (memberDAO.find("saved_filename", saved_filename) != null) {
				saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000
						+ extension;
			}

			memberDTO.setOrigin_filename(originFileName);
			memberDTO.setSaved_filename(saved_filename);

			UploadFileWriter uploadFileWriter = new UploadFileWriter();
			uploadFileWriter.writeFile(profile_file, profilePath, saved_filename);
		} else {
			memberDTO.setSaved_filename("NO");
		}
		memberDTO.setPass(memberDTO.getPass().toLowerCase());

		memberDAO.insert(memberDTO);

		redirectAttributes.addFlashAttribute("result", 2);

		return "redirect:/member/login";
	}

	@RequestMapping(value = "/login/proc", method = RequestMethod.POST)
	public String loginProc(HttpSession session, MemberDTO loginInfo, RedirectAttributes redirectAttributes,
			@RequestParam(value = "saveID", required = false) String saveID, HttpServletResponse response,
			HttpServletRequest request) {
		String returnURL = "";
		// 0일때 성공, 1일때 실패(아이디나 비밀번호가 틀림), 2일때 최초 회원가입
		int loginResult = 0;
		Cookie cookie1;
		Cookie cookie2;

		loginInfo.setPass(loginInfo.getPass().toLowerCase());

		if (session.getAttribute("isLogin") != null) {
			session.removeAttribute("isLogin");

			if (!"YES".equals(session.getAttribute("isSave"))) {
				session.removeAttribute("loggedInID");
			}
		}

		MemberDTO memberDTO = memberDAO.login(loginInfo);

		if (memberDTO != null) {
			session.setAttribute("isLogin", "YES");
			session.setAttribute("loginNick", memberDTO.getNick());
			session.setAttribute("loggedInID", memberDTO.getId());
			session.setAttribute("profile",
					(memberDTO.getSaved_filename() == null || "NO".equals(memberDTO.getSaved_filename())) ? "NO"
							: memberDTO.getSaved_filename());

			if (memberDAO.get(memberDTO.getId()).getAuthority() == 10)
				session.setAttribute("isAdmin", "YES");

			if (memberDAO.get(memberDTO.getId()).getAuthority() == 5)
				session.setAttribute("isIngee", "YES");

			if ("YES".equals(saveID)) {
				cookie1 = new Cookie("isSave", "YES");
				cookie2 = new Cookie("saveID", memberDTO.getId());
				cookie1.setMaxAge(60 * 60 * 24 * 365);
				cookie2.setMaxAge(60 * 60 * 24 * 365);
				response.addCookie(cookie1);
				response.addCookie(cookie2);
			} else {
				Cookie[] cookies = request.getCookies();
				for (int i = 0; i < cookies.length; i++) {
					if ("isSave".equals(cookies[i].getName())) {
						cookie1 = new Cookie("isSave", null);
						cookie2 = new Cookie("saveID", null);
						cookie1.setMaxAge(0);
						cookie2.setMaxAge(0);
						response.addCookie(cookie1);
						response.addCookie(cookie2);
					}
				}
			}

			returnURL = "redirect:/";
		} else {
			loginResult = 1;
			session.setAttribute("loginID", loginInfo.getId());
			returnURL = "redirect:/member/login";
		}

		redirectAttributes.addFlashAttribute("result", loginResult);

		return returnURL;
	}

	@RequestMapping(value = "/logout")
	public String logout(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		// 세션 전체를 날려버림
		// session.invalidate();
		session.removeAttribute("isLogin");

		Cookie[] cookies = request.getCookies();
		for (int i = 0; i < cookies.length; i++) {
			if ("isSave".equals(cookies[i].getName()) && "YES".equals(cookies[i].getValue())) {
				Cookie cookie1 = new Cookie("isSave", null);
				Cookie cookie2 = new Cookie("saveID", null);
				cookie1.setMaxAge(0);
				cookie2.setMaxAge(0);
				response.addCookie(cookie1);
				response.addCookie(cookie2);
			}
		}

		if (session.getAttribute("loginID") != null)
			session.removeAttribute("loginID");

		if (session.getAttribute("loginNick") != null)
			session.removeAttribute("loginNick");

		if (session.getAttribute("isAdmin") != null)
			session.removeAttribute("isAdmin");

		if (session.getAttribute("profile") != null)
			session.removeAttribute("profile");

		if (session.getAttribute("isIngee") != null)
			session.removeAttribute("isIngee");

		return "redirect:/";
	}

	@RequestMapping(value = "/search", method = RequestMethod.GET)
	public ModelAndView searchMembers(@RequestParam(value = "search_type", required = true) String search_type,
			@RequestParam(value = "keyword", required = true) String keyword,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "region", defaultValue = "all") String region,
			@RequestParam(value = "sort", defaultValue = "name") String sort) {
		int perPage = 15;
		int totalCount = memberDAO.getCount(search_type, keyword, region);
		int perBlock = 5;
		int totalPage = totalCount % perPage > 0 ? totalCount / perPage + 1 : totalCount / perPage;
		int startPage;
		int endPage;
		List<MemberDTO> memberDTOs = memberDAO.searchList((page - 1) * perPage, perPage, sort, search_type, keyword,
				region);
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
		modelAndView.addObject("memberList", memberDTOs);
		modelAndView.setViewName("/1/member/admin");
		return modelAndView;
	}

	@RequestMapping(value = "/admin")
	public ModelAndView admin(@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "region", defaultValue = "all") String region,
			@RequestParam(value = "sort", defaultValue = "name") String sort) {
		int perPage = 20;
		int totalCount = memberDAO.getCount(region);
		int perBlock = 10;
		int totalPage = totalCount % perPage > 0 ? totalCount / perPage + 1 : totalCount / perPage;
		int startPage;
		int endPage;
		List<MemberDTO> memberDTOs = memberDAO.list((page - 1) * perPage, perPage, sort, region);
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
		modelAndView.addObject("memberList", memberDTOs);
		modelAndView.setViewName("/1/member/admin");
		return modelAndView;
	}

	@RequestMapping(value = "/mypage")
	public ModelAndView mypage(HttpSession session) {
		ModelAndView modelAndView = new ModelAndView();
		MemberDTO memberDTO = memberDAO.get((String) session.getAttribute("loggedInID"));

		modelAndView.addObject("memberDTO", memberDTO);
		modelAndView.setViewName("/1/member/mypage");

		return modelAndView;
	}

	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public ModelAndView profileUpdate(MemberDTO memberDTO, HttpSession session,
			@RequestParam(value = "remove_file", required = false) String remove_file) {
		String profilePath = path + "/profile";
		MultipartFile profile_file = memberDTO.getProfile_file();
		MemberDTO currentDTO = memberDAO.get(memberDTO.getNum());

		MemberDTO dbDTO = memberDAO.get(memberDTO.getNum());

		if (remove_file != null) {
			StringTokenizer remove_files = new StringTokenizer(remove_file, ",");

			while (remove_files.hasMoreTokens()) {
				String filename = remove_files.nextToken();
				File file = new File(profilePath + "/" + filename);
				if (file.exists())
					file.delete();
				dbDTO.setSaved_filename(dbDTO.getSaved_filename().replaceAll(filename, ""));
				dbDTO.setSaved_filename(dbDTO.getSaved_filename().replaceAll(",,", ","));
			}
		}

		if (!currentDTO.getNick().equals(memberDTO.getNick())) {
			memberDAO.updateNick(currentDTO.getNick(), memberDTO.getNick());
			session.setAttribute("loginNick", memberDTO.getNick());
		}

		if (!"".equals(profile_file.getOriginalFilename())) {
			File file = new File(profilePath + "/" + memberDAO.get(memberDTO.getNum()).getSaved_filename());

			if (file != null)
				file.delete();

			String originFileName = profile_file.getOriginalFilename();
			String extension = originFileName.substring(originFileName.lastIndexOf("."));
			String saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000
					+ extension;

			while (memberDAO.find("saved_filename", saved_filename) != null) {
				saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000
						+ extension;
			}

			memberDTO.setOrigin_filename(originFileName);
			memberDTO.setSaved_filename(saved_filename);

			UploadFileWriter uploadFileWriter = new UploadFileWriter();
			uploadFileWriter.writeFile(profile_file, profilePath, saved_filename);
		} else {
			memberDTO.setSaved_filename(dbDTO.getSaved_filename().equals("") ? "NO" : dbDTO.getSaved_filename());
			memberDTO.setOrigin_filename(dbDTO.getSaved_filename().equals("") ? "" : dbDTO.getOrigin_filename());
			// memberDTO.setSaved_filename(memberDAO.get(memberDTO.getNum()).getSaved_filename());
			// memberDTO.setOrigin_filename(memberDAO.get(memberDTO.getNum()).getOrigin_filename());
		}

		ModelAndView modelAndView = new ModelAndView();

		memberDTO = memberDAO.update(memberDTO, "profile");
		modelAndView.addObject("memberDTO", memberDTO);
		modelAndView.setViewName("redirect:/member/mypage");

		return modelAndView;
	}

	@RequestMapping(value = "/update/pass", method = RequestMethod.POST)
	public ModelAndView updatePass(MemberDTO memberDTO, HttpSession session) {
		ModelAndView modelAndView = new ModelAndView();

		session.removeAttribute("isLogin");

		if (!"YES".equals(session.getAttribute("isSave")))
			session.removeAttribute("loggedInID");

		if (session.getAttribute("loginID") != null)
			session.removeAttribute("loginID");

		if (session.getAttribute("loginNick") != null)
			session.removeAttribute("loginNick");

		if (session.getAttribute("isAdmin") != null)
			session.removeAttribute("isAdmin");

		if (session.getAttribute("profile") != null)
			session.removeAttribute("profile");

		if (session.getAttribute("isIngee") != null)
			session.removeAttribute("isIngee");

		memberDTO.setPass(memberDTO.getPass().toLowerCase());

		memberDTO = memberDAO.update(memberDTO, "pass");
		modelAndView.addObject("memberDTO", memberDTO);
		modelAndView.setViewName("redirect:/member/mypage");

		return modelAndView;
	}

	@RequestMapping(value = "/delete", method = RequestMethod.GET)
	public String deleteMember(@RequestParam(value = "num", required = true) int num,
			@RequestParam(value = "nick", required = true) String nick, HttpSession session) {

		List<HashMap<String, Object>> list1 = commentDAO.getCommentCountOnDeleteMember(nick);
		List<HashMap<String, Object>> list2 = commentDAO.getReplyCountOnDeleteMember(nick);

		for (HashMap<String, Object> hashMap : list1) {
			Integer board_num = (Integer) hashMap.get("board_num");
			Long countValue = (Long) hashMap.get("count");
			boardDAO.updateCommentCount(board_num, (-1) * countValue.intValue());
		}

		for (HashMap<String, Object> hashMap : list2) {
			Integer comment_num = (Integer) hashMap.get("comment_num");
			Long countValue = (Long) hashMap.get("count");
			commentDAO.updateReplyCount(comment_num.intValue(), (-1) * countValue.intValue());
		}

		String profilePath = path + "/profile";
		File file = new File(profilePath + "/" + memberDAO.get(num).getSaved_filename());

		if (file.exists())
			file.delete();

		memberDAO.delete(num, nick);

		session.removeAttribute("isLogin");
		session.removeAttribute("loginID");
		session.removeAttribute("loginNick");
		session.removeAttribute("loggedInID");

		return "redirect:/";
	}

	@RequestMapping(value = "/initpass")
	public @ResponseBody Map<String, Object> sendMail(@RequestParam(value = "id", required = true) String id) {
		Map<String, Object> map = new HashMap<String, Object>();
		boolean isValid = true;

		if (memberDAO.find("id", id) != null) {
			isValid = false;

			MemberDTO memberDTO = memberDAO.get(id);
			MailSender mailController = new MailSender();
			String receiver = memberDTO.getId();
			String subject = "[InGee Fan Club]" + id + ", this is a password search email.";
			String pass = UUID.randomUUID().toString().split("-")[0];
			String content = "We have just issued a new password.\n\nNew password is " + pass
					+ ".\n\nAfter login, please change your password.";

			try {
				mailController.sendEmail(mailSender, subject, content, receiver);

				memberDTO.setPass(pass);
				memberDAO.update(memberDTO, "pass");

				map.put("email", memberDTO.getId());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				isValid = true;
				e.printStackTrace();
			}
		}
		map.put("isValid", isValid);

		ModelAndView modelAndView = new ModelAndView("jsonView", map);

		return map;
	}

	@RequestMapping(value = "/profile")
	public ModelAndView popupProfile(@RequestParam String id, HttpSession session,
			RedirectAttributes redirectAttributes) {
		ModelAndView modelAndView = new ModelAndView();
		String returnURL = "/member/profile";
		boolean loginCheck = false;
		if (session.getAttribute("isLogin") != null && "YES".equals((String) session.getAttribute("isLogin"))) {
			loginCheck = true;
			MemberDTO memberDTO = memberDAO.get(id);
			modelAndView.addObject("memberDTO", memberDTO);
			modelAndView.setViewName(returnURL);
		}
		modelAndView.addObject("loginCheck", loginCheck);

		return modelAndView;
	}
}