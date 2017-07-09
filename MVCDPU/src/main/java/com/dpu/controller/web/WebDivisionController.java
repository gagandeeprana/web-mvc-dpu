package com.dpu.controller.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.dpu.entity.Status;
import com.dpu.model.DivisionReq;
import com.dpu.service.DivisionService;
import com.dpu.service.StatusService;

@Controller
public class WebDivisionController {

	@Autowired
	DivisionService divisionService;
	
	@Autowired
	StatusService statusService;
	
	Logger logger = Logger.getLogger(WebDivisionController.class);
	
	@RequestMapping(value = "/showdivision", method = RequestMethod.GET)
	public ModelAndView showDivisionScreen() {
		ModelAndView modelAndView = new ModelAndView();
		List<DivisionReq> lstDivisions = divisionService.getAll("");
		modelAndView.addObject("LIST_DIVISION", lstDivisions);
		modelAndView.setViewName("division");
		return modelAndView;
	}
	
	@RequestMapping(value = "/getStatus" , method = RequestMethod.GET)
	@ResponseBody public List<Status> getStatus() {
		List<Status> status = null;
		try {
			status = statusService.getAll();
		} catch (Exception e) {
			System.out.println(e);
		}
		return status;
	}
	
	@RequestMapping(value = "/savedivision" , method = RequestMethod.POST)
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
	}
	
	@RequestMapping(value = "/getdivision/divisionId" , method = RequestMethod.GET)
	@ResponseBody  public DivisionReq getDivision(@RequestParam("divisionId") Long divisionId) {
		DivisionReq divisionReq = null;
		try {
			divisionReq = divisionService.get(divisionId);
		} catch (Exception e) {
			System.out.println(e);
			logger.info("Exception in getCategory is: " + e);
		}
		return divisionReq;
	}
	
	@RequestMapping(value = "/updatedivision" , method = RequestMethod.POST)
	public ModelAndView updateDivision(@ModelAttribute("division") DivisionReq divisionReq, @RequestParam("divisionid") Long divisionId) {
		ModelAndView modelAndView = new ModelAndView();
		divisionService.update(divisionId, divisionReq);
		modelAndView.setViewName("redirect:showdivision");
		return modelAndView;
	}
	
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
