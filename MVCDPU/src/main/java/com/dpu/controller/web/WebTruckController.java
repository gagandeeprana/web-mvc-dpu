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

import com.dpu.model.TruckResponse;
import com.dpu.service.TruckService;

@Controller
public class WebTruckController {

	@Autowired
	TruckService truckService;
	
	Logger logger = Logger.getLogger(WebTruckController.class);
	
	@RequestMapping(value = "/showtruck", method = RequestMethod.GET)
	public ModelAndView showTruckScreen() {
		ModelAndView modelAndView = new ModelAndView();
		List<TruckResponse> lstTrucks = truckService.getAllTrucks("");
		modelAndView.addObject("LIST_TRUCK", lstTrucks);
		modelAndView.setViewName("truck");
		return modelAndView;
	}
	
	@RequestMapping(value = "/truck/getopenadd" , method = RequestMethod.GET)
	@ResponseBody public TruckResponse getOpenAdd() {
		TruckResponse truckResponse = null;
		try {
			truckResponse = truckService.getOpenAdd();
		} catch (Exception e) {
			System.out.println(e);
		}
		return truckResponse;
	}
	
	@RequestMapping(value = "/savetruck" , method = RequestMethod.POST)
	public ModelAndView saveTruck(@ModelAttribute("truck") TruckResponse truckResponse, HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		HttpSession session = request.getSession();
		String createdBy = "";
		if(session != null) {
			createdBy = session.getAttribute("un").toString();
		}
//		divisionReq.setCreatedBy(createdBy);
//		divisionReq.setCreatedOn(new Date());
		truckService.add(truckResponse);
		modelAndView.setViewName("redirect:showtruck");
		return modelAndView;
	}
	
	@RequestMapping(value = "/gettruck/truckId" , method = RequestMethod.GET)
	@ResponseBody  public TruckResponse getTruck(@RequestParam("truckId") Long truckId) {
		TruckResponse truckRequest = null;
		try {
			truckRequest = truckService.get(truckId);
		} catch (Exception e) {
			System.out.println(e);
			logger.info("Exception in getCategory is: " + e);
		}
		return truckRequest;
	}
	
	@RequestMapping(value = "/updatetruck" , method = RequestMethod.POST)
	public ModelAndView updateTruck(@ModelAttribute("truck") TruckResponse truckResponse, @RequestParam("truckid") Long truckId) {
		ModelAndView modelAndView = new ModelAndView();
		truckService.update(truckId, truckResponse);
		modelAndView.setViewName("redirect:showtruck");
		return modelAndView;
	}
	
	@RequestMapping(value = "/deletetruck/{truckid}" , method = RequestMethod.GET)
	public ModelAndView deleteTruck(@PathVariable("truckid") Long truckId) {
		ModelAndView modelAndView = new ModelAndView();
		truckService.delete(truckId);
		modelAndView.setViewName("redirect:/showtruck");
		return modelAndView;
	}
}
