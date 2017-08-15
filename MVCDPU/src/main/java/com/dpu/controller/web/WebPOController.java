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

import com.dpu.model.Failed;
import com.dpu.model.IssueModel;
import com.dpu.model.PurchaseOrderModel;
import com.dpu.service.PurchaseOrderService;
import com.dpu.util.DateUtil;

@Controller
public class WebPOController {

	@Autowired
	PurchaseOrderService purchaseOrderService;
	
	Logger logger = Logger.getLogger(WebPOController.class);
	
	/*@RequestMapping(value = "/showpo", method = RequestMethod.GET)
	public ModelAndView showPOScreen() {
		ModelAndView modelAndView = new ModelAndView();
		List<PurchaseOrderModel> lstPOs = purchaseOrderService.getAll();
		modelAndView.addObject("LIST_PO", lstPOs);
		modelAndView.setViewName("po");
		return modelAndView;
	}*/
	
	@RequestMapping(value = "/showpo/status/Complete", method = RequestMethod.GET)
	@ResponseBody public Object showCompletePOs() {
		List<PurchaseOrderModel> lstPOs = purchaseOrderService.getStatusPOs("Complete");
		return lstPOs;
	}
	
	@RequestMapping(value = "/showpo/status/Active", method = RequestMethod.GET)
	@ResponseBody public Object showActivePOs() {
		List<PurchaseOrderModel> lstPOs = purchaseOrderService.getStatusPOs("Active");
		return lstPOs;
	}
	
	@RequestMapping(value = "/showpo/status/Invoiced", method = RequestMethod.GET)
	@ResponseBody public Object showInvoicedPOs() {
		List<PurchaseOrderModel> lstPOs = purchaseOrderService.getStatusPOs("Invoiced");
		return lstPOs;
	}
	
	@RequestMapping(value = "/showpo", method = RequestMethod.GET)
	public ModelAndView showPOScreenByStatus() {
		ModelAndView modelAndView = new ModelAndView();
		List<PurchaseOrderModel> lstPOs = purchaseOrderService.getStatusPOs("Active");
		modelAndView.addObject("LIST_PO", lstPOs);
		modelAndView.setViewName("po");
		return modelAndView;
	}
	
	@RequestMapping(value = "/{poId}/complete/{statusId}", method = RequestMethod.GET)
	@ResponseBody public Object changeToCompleteStatus(@PathVariable("poId") Long poId, @PathVariable("statusId") Long statusId) {
		PurchaseOrderModel purchaseOrderModel = new PurchaseOrderModel();
		purchaseOrderModel.setCurrentStatusVal("Active");
		Object response = purchaseOrderService.updateStatus(poId, statusId, purchaseOrderModel);
		if(response instanceof Failed) {
			return new ResponseEntity<Object>(response, HttpStatus.BAD_REQUEST);
		} else {
			return new ResponseEntity<Object>(response, HttpStatus.OK);
		}
	}
	
	@RequestMapping(value = "/{poId}/complete/{statusId}/invoiced", method = RequestMethod.GET)
	@ResponseBody public Object changeToInvoicedStatus(@PathVariable("poId") Long poId, @PathVariable("statusId") Long statusId, HttpServletRequest httpServletRequest) {
		PurchaseOrderModel purchaseOrderModel = new PurchaseOrderModel();
		String invoiceDate = httpServletRequest.getParameter("invoiceDate");
		String invoiceNo = httpServletRequest.getParameter("invoiceNo");
		String invoiceAmount = httpServletRequest.getParameter("invoiceAmount");
		purchaseOrderModel.setInvoiceNo(invoiceNo);
		purchaseOrderModel.setAmount(Double.parseDouble(invoiceAmount));
		purchaseOrderModel.setCurrentStatusVal("Complete");
		invoiceDate = DateUtil.rearrangeDate(invoiceDate);
		purchaseOrderModel.setInvoiceDate(invoiceDate);
		Object response = purchaseOrderService.updateStatus(poId, statusId, purchaseOrderModel);
		if(response instanceof Failed) {
			return new ResponseEntity<Object>(response, HttpStatus.BAD_REQUEST);
		} else {
			return new ResponseEntity<Object>(response, HttpStatus.OK);
		}
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
	@ResponseBody public Object savePO(@ModelAttribute("po") PurchaseOrderModel purchaseOrderModel, HttpServletRequest request) {
		HttpSession session = request.getSession();
		String createdBy = "";
		if(session != null) {
			createdBy = session.getAttribute("un").toString();
		}
//		divisionReq.setCreatedBy(createdBy);
//		divisionReq.setCreatedOn(new Date());
		Object response = purchaseOrderService.addPO(purchaseOrderModel);
		if(response instanceof Failed) {
			return new ResponseEntity<Object>(response, HttpStatus.BAD_REQUEST);
		} else {
			return new ResponseEntity<Object>(response, HttpStatus.OK);
		}
	}
	
	@RequestMapping(value = "/getpo/poId" , method = RequestMethod.GET)
	@ResponseBody public PurchaseOrderModel getPO(@RequestParam("poId") Long poId) {
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
	@ResponseBody public Object updatePO(@ModelAttribute("po") PurchaseOrderModel purchaseOrderModel, @RequestParam("poid") Long poId) {
		Object response = purchaseOrderService.update(poId, purchaseOrderModel);
		if(response instanceof Failed) {
			return new ResponseEntity<Object>(response, HttpStatus.BAD_REQUEST);
		} else {
			return new ResponseEntity<Object>(response, HttpStatus.OK);
		}
	}
	
	@RequestMapping(value = "/deletepo/{poid}" , method = RequestMethod.GET)
	@ResponseBody public Object deletePO(@PathVariable("poid") Long poId) {
		Object response = purchaseOrderService.delete(poId);
		if(response instanceof Failed) {
			return new ResponseEntity<Object>(response, HttpStatus.BAD_REQUEST);
		} else {
			return new ResponseEntity<Object>(response, HttpStatus.OK);
		}
	}
}
