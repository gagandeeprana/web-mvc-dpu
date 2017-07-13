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

import com.dpu.model.TerminalResponse;
import com.dpu.service.TerminalService;

@Controller
public class WebTerminalController {

	@Autowired
	TerminalService terminalService;
	
	Logger logger = Logger.getLogger(WebTerminalController.class);
	
	@RequestMapping(value = "/showterminal", method = RequestMethod.GET)
	public ModelAndView showTerminalScreen() {
		ModelAndView modelAndView = new ModelAndView();
		List<TerminalResponse> lstTerminals = terminalService.getAllTerminals();
		modelAndView.addObject("LIST_TERMINAL", lstTerminals);
		modelAndView.setViewName("terminal");
		return modelAndView;
	}
	
	@RequestMapping(value = "/terminal/getopenadd" , method = RequestMethod.GET)
	@ResponseBody public TerminalResponse getOpenAdd() {
		TerminalResponse terminalResponse = null;
		try {
			terminalResponse = terminalService.getOpenAdd();
		} catch (Exception e) {
			System.out.println(e);
		}
		return terminalResponse;
	}
	
	@RequestMapping(value = "/saveterminal" , method = RequestMethod.POST)
	public ModelAndView saveTerminal(@ModelAttribute("terminal") TerminalResponse terminalResponse, HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		HttpSession session = request.getSession();
		String createdBy = "";
		if(session != null) {
			createdBy = session.getAttribute("un").toString();
		}
//		divisionReq.setCreatedBy(createdBy);
//		divisionReq.setCreatedOn(new Date());
		terminalResponse.setStatusId(1l);
		terminalService.addTerminal(terminalResponse);
		modelAndView.setViewName("redirect:showterminal");
		return modelAndView;
	}
	
	@RequestMapping(value = "/getterminal/terminalId" , method = RequestMethod.GET)
	@ResponseBody  public TerminalResponse getTerminal(@RequestParam("terminalId") Long terminalId) {
		TerminalResponse terminalResponse = null;
		try {
			terminalResponse = terminalService.getTerminal(terminalId);
		} catch (Exception e) {
			System.out.println(e);
			logger.info("Exception in getCategory is: " + e);
		}
		return terminalResponse;
	}
	
	@RequestMapping(value = "/updateterminal" , method = RequestMethod.POST)
	public ModelAndView updateTerminal(@ModelAttribute("terminal") TerminalResponse terminalResponse, @RequestParam("terminalid") Long terminalId) {
		ModelAndView modelAndView = new ModelAndView();
		terminalService.updateTerminal(terminalId, terminalResponse);
		modelAndView.setViewName("redirect:showterminal");
		return modelAndView;
	}
	
	@RequestMapping(value = "/deleteterminal/{terminalid}" , method = RequestMethod.GET)
	public ModelAndView deleteTerminal(@PathVariable("terminalid") Long terminalId) {
		ModelAndView modelAndView = new ModelAndView();
		terminalService.deleteTerminal(terminalId);
		modelAndView.setViewName("redirect:/showterminal");
		return modelAndView;
	}
}
