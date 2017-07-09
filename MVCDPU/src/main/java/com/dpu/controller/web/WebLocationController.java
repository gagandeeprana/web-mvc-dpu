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

import com.dpu.model.ShipperResponse;
import com.dpu.service.ShipperService;

@Controller
public class WebLocationController {

	@Autowired
	ShipperService shipperService;
	
	Logger logger = Logger.getLogger(WebLocationController.class);
	
	@RequestMapping(value = "/showshipper", method = RequestMethod.GET)
	public ModelAndView showShipperScreen() {
		ModelAndView modelAndView = new ModelAndView();
		List<ShipperResponse> lstLocations = shipperService.getAll();
		modelAndView.addObject("LIST_LOCATION", lstLocations);
		modelAndView.setViewName("shipper");
		return modelAndView;
	}
	
	@RequestMapping(value = "/shipper/getopenadd" , method = RequestMethod.GET)
	@ResponseBody public ShipperResponse getOpenAdd() {
		ShipperResponse shipperResponse = null;
		try {
			shipperResponse = shipperService.getMasterData();
		} catch (Exception e) {
			System.out.println(e);
		}
		return shipperResponse;
	}
	
	@RequestMapping(value = "/saveshipper" , method = RequestMethod.POST)
	public ModelAndView saveShipper(@ModelAttribute("shipper") ShipperResponse shipperResponse, HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		HttpSession session = request.getSession();
		String createdBy = "";
		if(session != null) {
			createdBy = session.getAttribute("un").toString();
		}
//		divisionReq.setCreatedBy(createdBy);
//		divisionReq.setCreatedOn(new Date());
		shipperService.add(shipperResponse);
		modelAndView.setViewName("redirect:showshipper");
		return modelAndView;
	}
	
	@RequestMapping(value = "/getshipper/shipperId" , method = RequestMethod.GET)
	@ResponseBody  public ShipperResponse getShipper(@RequestParam("shipperId") Long shipperId) {
		ShipperResponse shipperResponse = null;
		try {
			shipperResponse = (ShipperResponse) shipperService.get(shipperId);
		} catch (Exception e) {
			System.out.println(e);
			logger.info("Exception in getCategory is: " + e);
		}
		return shipperResponse;
	}
	
	@RequestMapping(value = "/updateshipper" , method = RequestMethod.POST)
	public ModelAndView updateShipper(@ModelAttribute("shipper") ShipperResponse shipperResponse, @RequestParam("shipperid") Long shipperId) {
		ModelAndView modelAndView = new ModelAndView();
		shipperService.update(shipperId, shipperResponse);
		modelAndView.setViewName("redirect:showshipper");
		return modelAndView;
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
