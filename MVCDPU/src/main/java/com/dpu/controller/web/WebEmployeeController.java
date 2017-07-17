package com.dpu.controller.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.dpu.model.EmployeeModel;
import com.dpu.service.EmployeeService;
import com.dpu.util.DateUtil;

@Controller
public class WebEmployeeController {

	@Autowired
	EmployeeService employeeService;
	
	Logger logger = Logger.getLogger(WebEmployeeController.class);
	
	@RequestMapping(value = "/showuser", method = RequestMethod.GET)
	public ModelAndView showUsers() {
		ModelAndView modelAndView = new ModelAndView();
		List<EmployeeModel> lstEmployees = employeeService.getAll();
		modelAndView.addObject("LIST_EMPLOYEE", lstEmployees);
		modelAndView.setViewName("employee");
		return modelAndView;
	}
	
	@RequestMapping(value = "/saveuser" , method = RequestMethod.POST)
	public ModelAndView saveUser(@ModelAttribute("user") EmployeeModel employeeModel, HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		HttpSession session = request.getSession();
		String createdBy = "";
		if(session != null) {
			createdBy = session.getAttribute("un").toString();
		}
//		divisionReq.setCreatedBy(createdBy);
//		divisionReq.setCreatedOn(new Date());
		String hiring = DateUtil.rearrangeDate(employeeModel.getHiringdate());
		String termination = DateUtil.rearrangeDate(employeeModel.getTerminationdate());
		employeeModel.setHiringdate(hiring);
		employeeModel.setTerminationdate(termination);
		employeeService.add(employeeModel);
		modelAndView.setViewName("redirect:showuser");
		return modelAndView;
	}
	
	@RequestMapping(value = "/getuser/userId" , method = RequestMethod.GET)
	@ResponseBody  public EmployeeModel getUser(@RequestParam("userId") Long userId) {
		EmployeeModel employeeModel = null;
		try {
			employeeModel = (EmployeeModel) employeeService.getUserById(userId);
		} catch (Exception e) {
			System.out.println(e);
			logger.info("Exception in getCategory is: " + e);
		}
		return employeeModel;
	}
	
	@RequestMapping(value = "/updateuser" , method = RequestMethod.POST)
	public ModelAndView updateUser(@ModelAttribute("user") EmployeeModel employeeModel, @RequestParam("employeeid") Long employeeId) {
		ModelAndView modelAndView = new ModelAndView();
		String hiring = DateUtil.rearrangeDate(employeeModel.getHiringdate());
		String termination = DateUtil.rearrangeDate(employeeModel.getTerminationdate());
		employeeModel.setHiringdate(hiring);
		employeeModel.setTerminationdate(termination);
		employeeService.update(employeeId, employeeModel);
		modelAndView.setViewName("redirect:showuser");
		return modelAndView;
	}
	
	@RequestMapping(value = "/deleteuser/{userid}" , method = RequestMethod.GET)
	public ModelAndView deleteUser(@PathVariable("userid") Long employeeId) {
		ModelAndView modelAndView = new ModelAndView();
		employeeService.delete(employeeId);
		modelAndView.setViewName("redirect:/showuser");
		return modelAndView;
	}
}
