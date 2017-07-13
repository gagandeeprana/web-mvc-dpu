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

import com.dpu.model.TrailerRequest;
import com.dpu.service.TrailerService;

@Controller
public class WebTrailerController {

	@Autowired
	TrailerService trailerService;
	
	Logger logger = Logger.getLogger(WebTrailerController.class);
	
	@RequestMapping(value = "/showtrailer", method = RequestMethod.GET)
	public ModelAndView showTrailerScreen() {
		ModelAndView modelAndView = new ModelAndView();
		List<TrailerRequest> lstTrailers = trailerService.getAll();
		modelAndView.addObject("LIST_TRAILER", lstTrailers);
		modelAndView.setViewName("trailer");
		return modelAndView;
	}
	
	@RequestMapping(value = "/trailer/getopenadd" , method = RequestMethod.GET)
	@ResponseBody public TrailerRequest getOpenAdd() {
		TrailerRequest trailerRequest = null;
		try {
			trailerRequest = trailerService.getOpenAdd();
		} catch (Exception e) {
			System.out.println(e);
		}
		return trailerRequest;
	}
	
	
	@RequestMapping(value = "/savetrailer" , method = RequestMethod.POST)
	public ModelAndView saveTrailer(@ModelAttribute("trailer") TrailerRequest trailerRequest, HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		HttpSession session = request.getSession();
		String createdBy = "";
		if(session != null) {
			createdBy = session.getAttribute("un").toString();
		}
//		divisionReq.setCreatedBy(createdBy);
//		divisionReq.setCreatedOn(new Date());
		trailerService.add(trailerRequest);
		modelAndView.setViewName("redirect:showtrailer");
		return modelAndView;
	}
	
	@RequestMapping(value = "/gettrailer/trailerId" , method = RequestMethod.GET)
	@ResponseBody  public TrailerRequest getTrailer(@RequestParam("trailerId") Long trailerId) {
		TrailerRequest trailerRequest = null;
		try {
			trailerRequest = trailerService.get(trailerId);
		} catch (Exception e) {
			System.out.println(e);
			logger.info("Exception in getCategory is: " + e);
		}
		return trailerRequest;
	}
	
	@RequestMapping(value = "/updatetrailer" , method = RequestMethod.POST)
	public ModelAndView updateTrailer(@ModelAttribute("trailer") TrailerRequest trailerRequest, @RequestParam("trailerid") Long trailerId) {
		ModelAndView modelAndView = new ModelAndView();
		trailerService.update(trailerId, trailerRequest);
		modelAndView.setViewName("redirect:showtrailer");
		return modelAndView;
	}
	
	@RequestMapping(value = "/deletetrailer/{trailerid}" , method = RequestMethod.GET)
	public ModelAndView deleteTrailer(@PathVariable("trailerid") Long trailerId) {
		ModelAndView modelAndView = new ModelAndView();
		trailerService.delete(trailerId);
		modelAndView.setViewName("redirect:/showtrailer");
		return modelAndView;
	}
}
