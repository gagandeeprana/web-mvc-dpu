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

import com.dpu.model.ShipperModel;
import com.dpu.service.ShipperService;

@Controller
public class WebLocationController {

	@Autowired
	ShipperService shipperService;
	
	Logger logger = Logger.getLogger(WebLocationController.class);
	
	@RequestMapping(value = "/showshipper", method = RequestMethod.GET)
	public ModelAndView showShipperScreen() {
		ModelAndView modelAndView = new ModelAndView();
		List<ShipperModel> lstLocations = shipperService.getAll();
		modelAndView.addObject("LIST_LOCATION", lstLocations);
		modelAndView.setViewName("shipper");
		return modelAndView;
	}
	
	@RequestMapping(value = "/shipper/getopenadd" , method = RequestMethod.GET)
	@ResponseBody public ShipperModel getOpenAdd() {
		ShipperModel ShipperModel = null;
		try {
			ShipperModel = shipperService.getMasterData();
		} catch (Exception e) {
			System.out.println(e);
		}
		return ShipperModel;
	}
	
	@RequestMapping(value = "/saveshipper" , method = RequestMethod.POST)
	public ModelAndView saveShipper(@ModelAttribute("shipper") ShipperModel ShipperModel, HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		HttpSession session = request.getSession();
		String createdBy = "";
		if(session != null) {
			createdBy = session.getAttribute("un").toString();
		}
//		divisionReq.setCreatedBy(createdBy);
//		divisionReq.setCreatedOn(new Date());
		shipperService.add(ShipperModel);
		modelAndView.setViewName("redirect:showshipper");
		return modelAndView;
	}
	
	@RequestMapping(value = "/getshipper/shipperId" , method = RequestMethod.GET)
	@ResponseBody  public ShipperModel getShipper(@RequestParam("shipperId") Long shipperId) {
		ShipperModel ShipperModel = null;
		try {
			ShipperModel = (ShipperModel) shipperService.get(shipperId);
		} catch (Exception e) {
			System.out.println(e);
			logger.info("Exception in getCategory is: " + e);
		}
		return ShipperModel;
	}
	
	@RequestMapping(value = "/updateshipper" , method = RequestMethod.POST)
	public ModelAndView updateShipper(@ModelAttribute("shipper") ShipperModel ShipperModel, @RequestParam("shipperid") Long shipperId) {
		ModelAndView modelAndView = new ModelAndView();
		shipperService.update(shipperId, ShipperModel);
		modelAndView.setViewName("redirect:showshipper");
		return modelAndView;
	}
	
	@RequestMapping(value = "/deleteshipper/{shipperid}" , method = RequestMethod.GET)
	public ModelAndView deleteShipper(@PathVariable("shipperid") Long shipperId) {
		ModelAndView modelAndView = new ModelAndView();
		shipperService.delete(shipperId);
		modelAndView.setViewName("redirect:/showshipper");
		return modelAndView;
	}
}
