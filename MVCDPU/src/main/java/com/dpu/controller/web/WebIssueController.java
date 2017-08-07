package com.dpu.controller.web;

import java.util.HashSet;
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

import com.dpu.model.IssueModel;
import com.dpu.service.IssueService;

@Controller
public class WebIssueController {

	@Autowired
	IssueService issueService;
	
	Logger logger = Logger.getLogger(WebIssueController.class);
	
	@RequestMapping(value = "/showissue", method = RequestMethod.GET)
	public ModelAndView showIssueScreen() {
		ModelAndView modelAndView = new ModelAndView();
		List<IssueModel> lstIssues = issueService.getAll();
		modelAndView.addObject("LIST_ISSUE", lstIssues);
		modelAndView.setViewName("issue");
		return modelAndView;
	}
	
	@RequestMapping(value = "/issue/getopenadd" , method = RequestMethod.GET)
	@ResponseBody public IssueModel getOpenAdd() {
		IssueModel issueModel = null;
		try {
			issueModel = issueService.getOpenAdd();
		} catch (Exception e) {
			System.out.println(e);
		}
		return issueModel;
	}
	
	@RequestMapping(value = "/issue/getunitno/category/{category}/unittype/{unittype}" , method = RequestMethod.GET)
	@ResponseBody public IssueModel getUnitNo(@PathVariable("category") Long categoryId, @PathVariable("unittype") Long unitTypeId) {
		IssueModel issueModel = null;
		try {
			issueModel = issueService.getUnitNo(categoryId, unitTypeId);
		} catch (Exception e) {
			System.out.println(e);
		}
		return issueModel;
	}
	
	@RequestMapping(value = "/saveissue" , method = RequestMethod.POST)
	public ModelAndView saveIssue(@ModelAttribute("issue") IssueModel issueModel, HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		HttpSession session = request.getSession();
		String createdBy = "";
		if(session != null) {
			createdBy = session.getAttribute("un").toString();
		}
//		divisionReq.setCreatedBy(createdBy);
//		divisionReq.setCreatedOn(new Date());
		issueService.addIssue(issueModel);
		modelAndView.setViewName("redirect:showissue");
		return modelAndView;
	}
	
	@RequestMapping(value = "/getissue/issueId" , method = RequestMethod.GET)
	@ResponseBody  public IssueModel getIssue(@RequestParam("issueId") Long issueId) {
		IssueModel issueModel = null;
		try {
			issueModel = issueService.get(issueId);
		} catch (Exception e) {
			System.out.println(e);
			logger.info("Exception in getCategory is: " + e);
		}
		return issueModel;
	}
	
	@RequestMapping(value = "/updateissue" , method = RequestMethod.POST)
	public ModelAndView updateIssue(@ModelAttribute("issue") IssueModel issueModel, @RequestParam("issueid") Long issueId) {
		ModelAndView modelAndView = new ModelAndView();
		issueService.update(issueId, issueModel);
		modelAndView.setViewName("redirect:showissue");
		return modelAndView;
	}
	
	@RequestMapping(value = "/deleteissue/{issueid}" , method = RequestMethod.GET)
	public ModelAndView deleteTerminal(@PathVariable("issueid") Long issueId) {
		ModelAndView modelAndView = new ModelAndView();
		issueService.delete(issueId);
		modelAndView.setViewName("redirect:/showissue");
		return modelAndView;
	}
}
