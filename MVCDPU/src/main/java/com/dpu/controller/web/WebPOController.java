package com.dpu.controller.web;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.dpu.model.IssueModel;
import com.dpu.model.PurchaseOrderModel;
import com.dpu.service.PurchaseOrderService;

@Controller
public class WebPOController {

	@Autowired
	PurchaseOrderService purchaseOrderService;
	
	Logger logger = Logger.getLogger(WebPOController.class);
	
	@RequestMapping(value = "/showpo", method = RequestMethod.GET)
	public ModelAndView showPOScreen() {
		ModelAndView modelAndView = new ModelAndView();
		List<PurchaseOrderModel> lstPOs = purchaseOrderService.getAll();
		modelAndView.addObject("LIST_PO", lstPOs);
		modelAndView.setViewName("po");
		return modelAndView;
	}
	
	@RequestMapping(value = "/po/getopenadd" , method = RequestMethod.GET)
	@ResponseBody public PurchaseOrderModel getOpenAdd() {
		PurchaseOrderModel purchaseOrderModel = null;
		try {
			purchaseOrderModel = purchaseOrderService.getOpenAdd();
		} catch (Exception e) {
			System.out.println(e);
		}
		return purchaseOrderModel;
	}
	
	@RequestMapping(value = "/po/getissues/category/{category}/unittype/{unittype}" , method = RequestMethod.GET)
	@ResponseBody public List<IssueModel> getCategoryAndUnitTypeIssues(@PathVariable("category") Long categoryId, @PathVariable("unittype") Long unitTypeId) {
		List<IssueModel> issueModelList = null;
		try {
			issueModelList = purchaseOrderService.getCategoryAndUnitTypeIssues(categoryId, unitTypeId);
		} catch (Exception e) {
			System.out.println(e);
		}
		return issueModelList;
	}
	
	/*@RequestMapping(value = "/saveissue" , method = RequestMethod.POST)
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
	}*/
}
