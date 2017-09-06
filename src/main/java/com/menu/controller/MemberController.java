package com.menu.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ingee.util.UploadFileWriter;
import com.menu.model.MemberDAO;
import com.menu.model.MemberDTO;

@RequestMapping("/member")
@Controller
public class MemberController {
	@Autowired
	MemberDAO memberDAO;
	// test

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
		boolean isValid = true;

		if (memberDAO.checkMemberUsername(id) > 0)
			isValid = false;

		map.put("isValid", isValid);

		ModelAndView modelAndView = new ModelAndView("jsonView", map);

		return map;
	}

	@RequestMapping(value = "/join/proc", method = RequestMethod.POST)
	public ModelAndView joinProc(MemberDTO memberDTO) {
		MultipartFile profile_file = memberDTO.getProfile_file();

		if (!"".equals(profile_file.getOriginalFilename())) {
			String originFileName = profile_file.getOriginalFilename();
			String extension = originFileName.substring(originFileName.lastIndexOf("."));
			String profilePath = path + "/profile";
			String saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000
					+ extension;

			while (memberDAO.checkMemberFilename(saved_filename) > 0) {
				saved_filename = UUID.randomUUID().toString().split("-")[0] + System.currentTimeMillis() % 10000000;
			}

			memberDTO.setOrigin_filename(originFileName);
			memberDTO.setSaved_filename(saved_filename);

			UploadFileWriter uploadFileWriter = new UploadFileWriter();
			uploadFileWriter.writeFile(profile_file, profilePath, saved_filename);
		}
		memberDTO.setPass(memberDTO.getPass().toLowerCase());

		memberDAO.insert(memberDTO);

		ModelAndView modelAndView = new ModelAndView();

		modelAndView.addObject("result", 2);
		modelAndView.addObject("/1/member/login");

		return modelAndView;
	}

	@RequestMapping(value = "/login/proc", method = RequestMethod.POST)
	public String loginProc(HttpSession session, MemberDTO loginInfo, RedirectAttributes redirectAttributes,
			@RequestParam(value = "saveID", required = false) String saveID) {
		String returnURL = "";
		// 0일때 성공, 1일때 실패(아이디나 비밀번호가 틀림), 2일때 최초 회원가입
		int loginResult = 0;

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
			session.setAttribute("loggedInID", memberDTO.getId());

			if (memberDAO.get(memberDTO.getId()).getAuthority() >= 5)
				session.setAttribute("isAdmin", "YES");

			if ("YES".equals(saveID)) {
				session.setAttribute("isSave", saveID);
			} else {
				session.removeAttribute("isSave");
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
	public String logout(HttpSession session) {
		// 세션 전체를 날려버림
		// session.invalidate();
		session.removeAttribute("isLogin");

		if (!"YES".equals(session.getAttribute("isSave"))) {
			session.removeAttribute("loggedInID");
		}
		if (session.getAttribute("loginID") != null)
			session.removeAttribute("loginID");

		return "redirect:/";
	}
}