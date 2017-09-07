package com.ingee.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.menu.model.MemberDAO;
import com.menu.model.MemberDTO;

@Controller
public class AdminInterceptor extends HandlerInterceptorAdapter {
	@Autowired
	MemberDAO memberDAO;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
		String loggedInID = (String) session.getAttribute("loggedInID");

		MemberDTO memberDTO = memberDAO.get(loggedInID);

		if (session.getAttribute("isLogin") == null || memberDTO.getAuthority() < 5) {
			response.sendRedirect("/");
			return false;
		}
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub
		super.postHandle(request, response, handler, modelAndView);
	}
}
