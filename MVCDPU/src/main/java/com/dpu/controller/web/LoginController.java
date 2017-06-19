package com.dpu.controller.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class LoginController {

	@RequestMapping(value = "/authUser", method = RequestMethod.POST)
	public ModelAndView authenticateUser(@RequestParam("username") String username,@RequestParam("password") String password, HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		if(username.equals("admin") && password.equals("admin")) {
			HttpSession session = request.getSession();
			if(session != null) {
				session.setAttribute("un", username);
			}
			modelAndView.setViewName("homepage");
		} else {
			modelAndView.addObject("error", "Invalid Username/Password");
			modelAndView.setViewName("redirect:login");
		}
		return modelAndView;
	}
	
	@RequestMapping(value = {"/login" , "/"})
	public ModelAndView showLoginScreen() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("index");
		return modelAndView;
	}
	
	@RequestMapping(value = {"/home"})
	public ModelAndView showHomepageScreen() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("homepage");
		return modelAndView;
	}
}
