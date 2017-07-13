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

import com.dpu.model.CategoryReq;
import com.dpu.service.CategoryService;

@Controller
public class WebCategoryController {

	@Autowired
	CategoryService categoryService;
	
	Logger logger = Logger.getLogger(WebCategoryController.class);
	
	@RequestMapping(value = "/showcategory", method = RequestMethod.GET)
	public ModelAndView showCategoryScreen() {
		ModelAndView modelAndView = new ModelAndView();
		List<CategoryReq> lstCategories = categoryService.getAll();
		modelAndView.addObject("LIST_CATEGORY", lstCategories);
		modelAndView.setViewName("category");
		return modelAndView;
	}
	
	@RequestMapping(value = "/getopenadd" , method = RequestMethod.GET)
	@ResponseBody public CategoryReq getOpenAdd() {
		CategoryReq categoryReq = null;
		try {
			categoryReq = categoryService.getOpenAdd();
		} catch (Exception e) {
			System.out.println(e);
		}
		return categoryReq;
	}
	
	@RequestMapping(value = "/savecategory" , method = RequestMethod.POST)
	public ModelAndView saveCategory(@ModelAttribute("cat") CategoryReq categoryReq, HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		HttpSession session = request.getSession();
		String createdBy = "";
		if(session != null) {
			createdBy = session.getAttribute("un").toString();
		}
//		divisionReq.setCreatedBy(createdBy);
//		divisionReq.setCreatedOn(new Date());
		categoryService.addCategory(categoryReq);
		modelAndView.setViewName("redirect:showcategory");
		return modelAndView;
	}
	
	@RequestMapping(value = "/getcategory/categoryId" , method = RequestMethod.GET)
	@ResponseBody  public CategoryReq getCategory(@RequestParam("categoryId") Long categoryId) {
		CategoryReq categoryReq = null;
		try {
			categoryReq = categoryService.get(categoryId);
		} catch (Exception e) {
			System.out.println(e);
			logger.info("Exception in getCategory is: " + e);
		}
		return categoryReq;
	}
	
	@RequestMapping(value = "/updatecategory" , method = RequestMethod.POST)
	public ModelAndView updateCategory(@ModelAttribute("cat") CategoryReq categoryReq, @RequestParam("categoryid") Long categoryId) {
		ModelAndView modelAndView = new ModelAndView();
		categoryService.update(categoryId, categoryReq);
		modelAndView.setViewName("redirect:showcategory");
		return modelAndView;
	}
	
	@RequestMapping(value = "/deletecategory/{categoryid}" , method = RequestMethod.GET)
	public ModelAndView deleteCategory(@PathVariable("categoryid") Long categoryId) {
		ModelAndView modelAndView = new ModelAndView();
		categoryService.delete(categoryId);
		modelAndView.setViewName("redirect:/showcategory");
		return modelAndView;
	}
}