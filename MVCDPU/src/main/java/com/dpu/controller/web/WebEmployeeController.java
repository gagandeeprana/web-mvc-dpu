package com.dpu.controller.web;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.dpu.model.EmployeeModel;
import com.dpu.service.EmployeeService;

@Controller
public class WebEmployeeController {

	@Autowired
	EmployeeService employeeService;
	
	Logger logger = Logger.getLogger(WebEmployeeController.class);
	
	@RequestMapping(value = "/showuser", method = RequestMethod.GET)
	public ModelAndView showEmployeeScreen() {
		ModelAndView modelAndView = new ModelAndView();
		List<EmployeeModel> lstEmployees = employeeService.getAll();
		modelAndView.addObject("LIST_EMPLOYEE", lstEmployees);
		modelAndView.setViewName("employee");
		return modelAndView;
	}
	
	/*@RequestMapping(value = "/savedivision" , method = RequestMethod.POST)
	public ModelAndView saveDivision(@ModelAttribute("division") DivisionReq divisionReq, HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		HttpSession session = request.getSession();
		String createdBy = "";
		if(session != null) {
			createdBy = session.getAttribute("un").toString();
		}
//		divisionReq.setCreatedBy(createdBy);
//		divisionReq.setCreatedOn(new Date());
		divisionService.add(divisionReq);
		modelAndView.setViewName("redirect:showdivision");
		return modelAndView;
	}*/
	
	/*@RequestMapping(value = "/updateCat" , method = RequestMethod.POST)
	public ModelAndView updateCategory(@ModelAttribute("cat") CategoryBean categoryBean, @RequestParam("categoryid") int categoryId) {
		ModelAndView modelAndView = new ModelAndView();
		categoryBean.setCategoryId(categoryId);
		categoryService.updateCategory(categoryBean);
		modelAndView.setViewName("redirect:showcat");
		return modelAndView;
	}
	
	@RequestMapping(value = "/deleteCat/sta/{sta}/catId/{catId}" , method = RequestMethod.GET)
	public ModelAndView deleteCategory(@PathVariable("catId") int categoryId,@PathVariable("sta") int status) {
		ModelAndView modelAndView = new ModelAndView();
		categoryService.softDeleteCategory(status, categoryId);
		modelAndView.setViewName("redirect:/showcat");
		return modelAndView;
	}
	
	@RequestMapping(value = "/getCat/catId" , method = RequestMethod.GET)
	@ResponseBody  public CategoryBean getCategory(@RequestParam("catId") int categoryId) {
		CategoryBean categoryBean = null;
		try {
			categoryBean = categoryService.getCategoryInfoById(categoryId);
		} catch (Exception e) {
			System.out.println(e);
			logger.info("Exception in getCategory is: " + e);
		}
		return categoryBean;
	}*/
	
	
	
}
