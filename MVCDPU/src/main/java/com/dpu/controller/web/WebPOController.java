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
	
	@RequestMapping(value = "/savepo" , method = RequestMethod.POST)
	public ModelAndView savePO(@ModelAttribute("po") PurchaseOrderModel purchaseOrderModel, HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		HttpSession session = request.getSession();
		String createdBy = "";
		if(session != null) {
			createdBy = session.getAttribute("un").toString();
		}
//		divisionReq.setCreatedBy(createdBy);
//		divisionReq.setCreatedOn(new Date());
		purchaseOrderService.addPO(purchaseOrderModel);
		modelAndView.setViewName("redirect:showpo");
		return modelAndView;
	}
	
	@RequestMapping(value = "/getpo/poId" , method = RequestMethod.GET)
	@ResponseBody  public PurchaseOrderModel getPO(@RequestParam("poId") Long poId) {
		PurchaseOrderModel purchaseOrderModel = null;
		try {
			purchaseOrderModel = purchaseOrderService.get(poId);
			List<IssueModel> issueModelList = purchaseOrderService.getCategoryAndUnitTypeIssues(purchaseOrderModel.getCategoryId(), purchaseOrderModel.getUnitTypeId());
			purchaseOrderModel.getIssueList().addAll(issueModelList);
		} catch (Exception e) {
			System.out.println(e);
			logger.info("Exception in getCategory is: " + e);
		}
		return purchaseOrderModel;
	}
	
	@RequestMapping(value = "/updatepo" , method = RequestMethod.POST)
	public ModelAndView updatePO(@ModelAttribute("po") PurchaseOrderModel purchaseOrderModel, @RequestParam("poid") Long poId) {
		ModelAndView modelAndView = new ModelAndView();
		purchaseOrderService.update(poId, purchaseOrderModel);
		modelAndView.setViewName("redirect:showpo");
		return modelAndView;
	}
	
	@RequestMapping(value = "/deletepo/{poid}" , method = RequestMethod.GET)
	public ModelAndView deletePO(@PathVariable("poid") Long poId) {
		ModelAndView modelAndView = new ModelAndView();
		purchaseOrderService.delete(poId);
		modelAndView.setViewName("redirect:/showpo");
		return modelAndView;
	}
}
