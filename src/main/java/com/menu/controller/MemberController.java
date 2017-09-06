package com.menu.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.ingee.util.UploadFileWriter;
import com.menu.model.MemberDAO;
import com.menu.model.MemberDTO;

@RequestMapping("/member")
@Controller
public class MemberController {
	@Autowired
	MemberDAO memberDAO;
	//test

	final String path = "C:\\Users\\jihyun\\Desktop\\egov\\eGovFrameDev-3.6.0-64bit\\workspace\\InGeeFanClub\\src\\main\\webapp\\resources";

	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login() {
		return "/1/member/login";
	}

	@RequestMapping(value = "/join", method = RequestMethod.GET)
	public String joinForm() {
		return "/1/member/join";
	}
	
	@RequestMapping(value = "/join/checkID")
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

		modelAndView.addObject("result", 4);
		modelAndView.addObject("/1/member/login");

		return modelAndView;
	}
}