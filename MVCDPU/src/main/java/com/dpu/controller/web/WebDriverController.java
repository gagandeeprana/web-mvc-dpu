package com.dpu.controller.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.dpu.model.DriverModel;
import com.dpu.model.Failed;
import com.dpu.service.DriverService;

@Controller
public class WebDriverController {

	@Autowired
	DriverService driverService;
	
	Logger logger = Logger.getLogger(WebDriverController.class);
	
	@RequestMapping(value = "/showdriver", method = RequestMethod.GET)
	public ModelAndView showDriverScreen() {
		ModelAndView modelAndView = new ModelAndView();
		List<DriverModel> lstDrivers = driverService.getAllDriver();
		modelAndView.addObject("LIST_DRIVER", lstDrivers);
		modelAndView.setViewName("driver");
		return modelAndView;
	}
	
	@RequestMapping(value = "/driver/getopenadd" , method = RequestMethod.GET)
	@ResponseBody public DriverModel getOpenAdd() {
		DriverModel DriverModel = null;
		try {
			DriverModel = driverService.getOpenAdd();
		} catch (Exception e) {
			System.out.println(e);
		}
		return DriverModel;
	}
	
	@RequestMapping(value = "/savedriver" , method = RequestMethod.POST)
	public @ResponseBody Object saveTruck(@ModelAttribute("driver") DriverModel DriverModel, HttpServletRequest request) {
		HttpSession session = request.getSession();
		String createdBy = "";
		if(session != null) {
			createdBy = session.getAttribute("un").toString();
		}
//		divisionReq.setCreatedBy(createdBy);
//		divisionReq.setCreatedOn(new Date());
		Object response = driverService.addDriver(DriverModel);
		if(response instanceof Failed) {
			return new ResponseEntity<Object>(response, HttpStatus.BAD_REQUEST);
		} else {
			return new ResponseEntity<Object>(response, HttpStatus.OK);
		}
	}
	
	@RequestMapping(value = "/getdriver/driverId" , method = RequestMethod.GET)
	@ResponseBody  public DriverModel getDriver(@RequestParam("driverId") Long driverId) {
		DriverModel DriverModel = null;
		try {
			DriverModel = (DriverModel) driverService.getDriverByDriverId(driverId);
		} catch (Exception e) {
			System.out.println(e);
			logger.info("Exception in getCategory is: " + e);
		}
		return DriverModel;
	}
	
	@RequestMapping(value = "/updatedriver" , method = RequestMethod.POST)
	public ModelAndView updateDriver(@ModelAttribute("driver") DriverModel DriverModel, @RequestParam("driverid") Long driverId) {
		ModelAndView modelAndView = new ModelAndView();
		driverService.updateDriver(driverId, DriverModel);
		modelAndView.setViewName("redirect:showdriver");
		return modelAndView;
	}
	
	@RequestMapping(value = "/deletedriver/{driverid}" , method = RequestMethod.GET)
	@ResponseBody public Object deleteDriver(@PathVariable("driverid") Long driverId) {
		Object response = driverService.deleteDriver(driverId);
		if(response instanceof Failed) {
			return new ResponseEntity<Object>(response, HttpStatus.BAD_REQUEST);
		} else {
			return new ResponseEntity<Object>(response, HttpStatus.OK);
		}
	}
}
