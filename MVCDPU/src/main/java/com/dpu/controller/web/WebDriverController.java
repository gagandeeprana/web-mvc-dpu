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

import com.dpu.model.DriverReq;
import com.dpu.model.Success;
import com.dpu.service.DriverService;

@Controller
public class WebDriverController {

	@Autowired
	DriverService driverService;
	
	Logger logger = Logger.getLogger(WebDriverController.class);
	
	@RequestMapping(value = "/showdriver", method = RequestMethod.GET)
	public ModelAndView showDriverScreen() {
		ModelAndView modelAndView = new ModelAndView();
		List<DriverReq> lstDrivers = driverService.getAllDriver();
		modelAndView.addObject("LIST_DRIVER", lstDrivers);
		modelAndView.setViewName("driver");
		return modelAndView;
	}
	
	@RequestMapping(value = "/driver/getopenadd" , method = RequestMethod.GET)
	@ResponseBody public DriverReq getOpenAdd() {
		DriverReq driverReq = null;
		try {
			driverReq = driverService.getOpenAdd();
		} catch (Exception e) {
			System.out.println(e);
		}
		return driverReq;
	}
	
	@RequestMapping(value = "/savedriver" , method = RequestMethod.POST)
	public ModelAndView saveTruck(@ModelAttribute("driver") DriverReq driverReq, HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		HttpSession session = request.getSession();
		String createdBy = "";
		if(session != null) {
			createdBy = session.getAttribute("un").toString();
		}
//		divisionReq.setCreatedBy(createdBy);
//		divisionReq.setCreatedOn(new Date());
		driverService.addDriver(driverReq);
		modelAndView.setViewName("redirect:showdriver");
		return modelAndView;
	}
	
	@RequestMapping(value = "/getdriver/driverId" , method = RequestMethod.GET)
	@ResponseBody  public Success getDriver(@RequestParam("driverId") Long driverId) {
		Success driverReq = null;
		try {
			driverReq = (Success) driverService.getDriverByDriverId(driverId);
		} catch (Exception e) {
			System.out.println(e);
			logger.info("Exception in getCategory is: " + e);
		}
		return driverReq;
	}
	
	@RequestMapping(value = "/updatedriver" , method = RequestMethod.POST)
	public ModelAndView updateDriver(@ModelAttribute("driver") DriverReq driverReq, @RequestParam("driverid") Long driverId) {
		ModelAndView modelAndView = new ModelAndView();
		driverService.updateDriver(driverId, driverReq);
		modelAndView.setViewName("redirect:showdriver");
		return modelAndView;
	}
	
	@RequestMapping(value = "/deletedriver/{driverid}" , method = RequestMethod.GET)
	public ModelAndView deleteDriver(@PathVariable("driverid") Long driverId) {
		ModelAndView modelAndView = new ModelAndView();
		driverService.deleteDriver(driverId);
		modelAndView.setViewName("redirect:/showdriver");
		return modelAndView;
	}
}
