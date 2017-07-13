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
import com.dpu.model.Failed;
import com.dpu.model.Success;
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

	@RequestMapping(value = "/deletedivision/{divisionid}" , method = RequestMethod.GET)
	public ModelAndView deleteDivision(@RequestParam("divisionid") Long divisionId) {
		ModelAndView modelAndView = new ModelAndView();
		Object response = divisionService.delete(divisionId);
		String msg = null;
		if(response instanceof Failed) {
			msg = ((Failed) response).getMessage();
		} else {
			msg = ((Success) response).getMessage();
			modelAndView.addObject("LIST_DIVISION", ((Success) response).getResultList());
		}
		if(msg != null && msg.length() > 0) {
			modelAndView.addObject("msg", msg);
		}
		modelAndView.setViewName("division");
		return modelAndView;
	}
}
