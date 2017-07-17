package com.dpu.controller.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.dpu.model.EmployeeModel;
import com.dpu.model.Success;
import com.dpu.service.EmployeeService;

@Controller
public class LoginController {

	@Autowired
	private EmployeeService employeeService;
	
	@RequestMapping(value = "/authUser", method = RequestMethod.POST)
	public ModelAndView authenticateUser(@RequestParam("username") String username,@RequestParam("password") String password, HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		if(username != null && username.length() > 0 && password != null && password.length() > 0) {
			EmployeeModel employeeModel = new EmployeeModel();
			employeeModel.setUsername(username);
			employeeModel.setPassword(password);
			Object response = employeeService.getUserByLoginCredentials(employeeModel);
			if(response instanceof Success) {
				Success success = (Success) response;
				HttpSession session = request.getSession();
				session.setAttribute("un", username);
				modelAndView.setViewName("homepage");
			} else {
				modelAndView.addObject("error", "Invalid Username/Password");
				modelAndView.setViewName("redirect:login");
			}
		}
		return modelAndView;
	}
	
	@RequestMapping(value = {"/login" , "/"})
	public ModelAndView showLoginScreen() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("index");
		return modelAndView;
	}
	
	@RequestMapping(value = {"/logout"})
	public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView modelAndView = new ModelAndView();
		if(request != null) {
			request.getSession().invalidate();
			response.setHeader("Cache-Control","no-cache"); 
			response.setHeader("Pragma","no-cache"); 
			response.setDateHeader ("Expires", 0);
		}
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
