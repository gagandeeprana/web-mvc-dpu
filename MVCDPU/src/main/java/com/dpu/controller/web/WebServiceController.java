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
	@ResponseBody  public DPUService getService(@RequestParam("serviceId") Long shipperId) {
		DPUService dpuService = null;
		try {
			dpuService = serviceService.get(shipperId);
		} catch (Exception e) {
			System.out.println(e);
			logger.info("Exception in getCategory is: " + e);
		}
		return dpuService;
	}
	
	@RequestMapping(value = "/updateservice" , method = RequestMethod.POST)
	public ModelAndView updateService(@ModelAttribute("service") DPUService dpuService, @RequestParam("serviceid") Long serviceId) {
		ModelAndView modelAndView = new ModelAndView();
		serviceService.update(serviceId, dpuService);
		modelAndView.setViewName("redirect:showservice");
		return modelAndView;
	}
	
	@RequestMapping(value = "/deleteservice/{serviceid}" , method = RequestMethod.GET)
	public ModelAndView deleteService(@PathVariable("serviceid") Long serviceId) {
		ModelAndView modelAndView = new ModelAndView();
		serviceService.delete(serviceId);
		modelAndView.setViewName("redirect:/showservice");
		return modelAndView;
	}
}
