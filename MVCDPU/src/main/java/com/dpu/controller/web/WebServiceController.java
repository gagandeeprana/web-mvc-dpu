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

import com.dpu.model.DPUService;
import com.dpu.service.ServiceService;

@Controller
public class WebServiceController {

	@Autowired
	ServiceService serviceService;
	
	Logger logger = Logger.getLogger(WebServiceController.class);
	
	@RequestMapping(value = "/showservice", method = RequestMethod.GET)
	public ModelAndView showServiceScreen() {
		ModelAndView modelAndView = new ModelAndView();
		List<DPUService> lstServices = serviceService.getAll();
		modelAndView.addObject("LIST_SERVICE", lstServices);
		modelAndView.setViewName("service");
		return modelAndView;
	}
	
	@RequestMapping(value = "/service/getopenadd" , method = RequestMethod.GET)
	@ResponseBody public DPUService getOpenAdd() {
		DPUService dPUService = null;
		try {
			dPUService = serviceService.getOpenAdd();
		} catch (Exception e) {
			System.out.println(e);
		}
		return dPUService;
	}
	
	@RequestMapping(value = "/saveservice" , method = RequestMethod.POST)
	public ModelAndView saveTerminal(@ModelAttribute("service") DPUService dpuService, HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		HttpSession session = request.getSession();
		String createdBy = "";
		if(session != null) {
			createdBy = session.getAttribute("un").toString();
		}
//		divisionReq.setCreatedBy(createdBy);
//		divisionReq.setCreatedOn(new Date());
		serviceService.add(dpuService);
		modelAndView.setViewName("redirect:showservice");
		return modelAndView;
	}
	
	@RequestMapping(value = "/getservice/serviceId" , method = RequestMethod.GET)
	@ResponseBody  public DPUService getShipper(@RequestParam("shipperId") Long shipperId) {
		DPUService dpuService = null;
		try {
			dpuService = serviceService.get(shipperId);
		} catch (Exception e) {
			System.out.println(e);
			logger.info("Exception in getCategory is: " + e);
		}
		return dpuService;
	}
	
	/*@RequestMapping(value = "/saveCat" , method = RequestMethod.POST)
	public ModelAndView saveCategory(@RequestParam("uploadFile") MultipartFile multipart, @RequestParam("title") String title, @RequestParam("status") int status, HttpServletRequest request) {
		ModelAndView modelAndView = null;
		try {
			modelAndView = new ModelAndView();
			CategoryBean categoryBean = new CategoryBean();
			categoryBean.setTitle(title);
			categoryBean.setStatus(status);
			HttpSession session = request.getSession();
			String createdBy = "";
			if(session != null) {
				createdBy = session.getAttribute("un").toString();
			}
			categoryBean.setCreatedBy(createdBy);
			categoryBean.setCreatedOn(new Date());
			categoryBean.setImageName(multipart.getOriginalFilename());
			categoryService.addCategory(categoryBean);
			uploadUtil.processRequest(multipart, title);
			modelAndView.setViewName("redirect:/showcat");
		} catch (Exception e) {
			System.out.println("CategoryController: Exception is: " + e);
		}
		return modelAndView;
	}
	
	@RequestMapping(value = "/updateCat" , method = RequestMethod.POST)
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
