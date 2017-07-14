package com.dpu.controller.web;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
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
	public ModelAndView showDivisionScreen(@RequestParam(value = "msg", required = false) String msg) {
		ModelAndView modelAndView = new ModelAndView();
		List<DivisionReq> lstDivisions = divisionService.getAll("");
		modelAndView.addObject("LIST_DIVISION", lstDivisions);
		if(msg != null && msg.length() > 0) {
			modelAndView.addObject("msg", msg);
		}
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

	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value = "/deletedivision" , method = RequestMethod.GET)
	public ModelAndView deleteDivision(HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		Long divisionId = Long.parseLong(String.valueOf(request.getParameter("divisionid")));

		Object response = divisionService.delete(divisionId);
		String msg = null;
		if(response instanceof Failed) {
			msg = ((Failed) response).getMessage();
		} else {
			try {
				msg = ((Success) response).getMessage();
				Success success = (Success) response;
				List<DivisionReq> divisionList = (List<DivisionReq>) success.getResultList();
				modelAndView.addObject("LIST_DIVISION", divisionList);
			} catch (Exception e) {
				System.out.println(e);
			}
		}
		//modelAndView.setViewName("redirect:/showdivision?msg=" + msg);
		modelAndView.setViewName("division");
		return modelAndView;
	}
	
	/*@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value = "/deletedivision1" , method = RequestMethod.GET)
	public String deletedivision1(HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		String dataval = request.getParameter("delId");
		
		modelAndView.addObject("msg", "sdfsdf");
		//modelAndView.setViewName("division");
		return "sdfsdfsdsd";
	}*/
	
	
}
