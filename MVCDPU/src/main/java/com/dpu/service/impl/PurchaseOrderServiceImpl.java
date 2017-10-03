package com.dpu.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.dpu.constants.Iconstants;
import com.dpu.dao.PurchaseOrderDao;
import com.dpu.entity.Category;
import com.dpu.entity.Issue;
import com.dpu.entity.PurchaseOrder;
import com.dpu.entity.PurchaseOrderInvoice;
import com.dpu.entity.PurchaseOrderIssue;
import com.dpu.entity.Type;
import com.dpu.entity.Vendor;
import com.dpu.model.Failed;
import com.dpu.model.IssueModel;
import com.dpu.model.PurchaseOrderModel;
import com.dpu.model.Success;
import com.dpu.model.TypeResponse;
import com.dpu.model.VendorModel;
import com.dpu.service.CategoryService;
import com.dpu.service.IssueService;
import com.dpu.service.PurchaseOrderService;
import com.dpu.service.TypeService;
import com.dpu.service.VendorService;
import com.dpu.util.DateUtil;

@Component
public class PurchaseOrderServiceImpl implements PurchaseOrderService  {

	Logger logger = Logger.getLogger(PurchaseOrderServiceImpl.class);
	
	@Autowired
	IssueService issueService;

	@Autowired
	CategoryService categoryService;
	
	@Autowired
	VendorService vendorService;
	
	@Autowired
	SessionFactory sessionFactory;
	
	@Autowired
	TypeService typeService;
	
	@Autowired
	PurchaseOrderDao poDao;

	@Value("${po_added_message}")
	private String po_added_message;

	@Value("${po_unable_to_add_message}")
	private String po_unable_to_add_message;

	@Value("${po_deleted_message}")
	private String po_deleted_message;

	@Value("${po_unable_to_delete_message}")
	private String po_unable_to_delete_message;

	@Value("${po_updated_message}")
	private String po_updated_message;

	@Value("${po_unable_to_update_message}")
	private String po_unable_to_update_message;

	@Value("${po_already_used_message}")
	private String po_already_used_message;
	
	@Value("${po_status_update}")
	private String po_status_update;

	@Value("${po_status_unable_to_update}")
	private String po_status_unable_to_update;

	@Override
	public List<PurchaseOrderModel> getAll() {

		logger.info("PurchaseOrderServiceImpl getAll() starts ");
		Session session = null;
		List<PurchaseOrderModel> poList = new ArrayList<PurchaseOrderModel>();
		try {
			session = sessionFactory.openSession();
			List<PurchaseOrder> pos = poDao.findAll(session);
			// poList = setPOData(pos, poList);
			
		} finally {
			if (session != null) {
				session.close();
			}
		}

		logger.info("PurchaseOrderServiceImpl getAll() ends ");
		return poList;
	}
	
	@Override
	public List<PurchaseOrderModel> getStatusPOs(String statusVal) {
		
		logger.info("PurchaseOrderServiceImpl getAll() starts ");
		Session session = null;
		List<PurchaseOrderModel> poList = new ArrayList<PurchaseOrderModel>();
		try {
			session = sessionFactory.openSession();
			List<PurchaseOrder> pos = poDao.getStatusPOs(session, statusVal);
			poList = setPOData(pos, poList, statusVal);
			
		} finally {
			if (session != null) {
				session.close();
			}
		}

		logger.info("PurchaseOrderServiceImpl getAll() ends ");
		return poList;
	}

	private List<PurchaseOrderModel> setPOData(List<PurchaseOrder> pos, List<PurchaseOrderModel> poList,
			String statusVal) {
		
		if(pos != null && !pos.isEmpty()) {
			for (PurchaseOrder purchaseOrder : pos) {
				PurchaseOrderModel poModel = new PurchaseOrderModel();
				poModel.setId(purchaseOrder.getId());
				poModel.setPoNo(purchaseOrder.getPoNo());
				poModel.setMessage(purchaseOrder.getMessage());
				
				poModel.setCategoryName(purchaseOrder.getCategory().getName());
				String status = purchaseOrder.getStatus().getTypeName();
				poModel.setStatusName(status);
				
				if(status.equals("Invoiced")){
					poModel.setInvoiceNo(purchaseOrder.getInvoiceNo());
				}
				
				poModel.setUnitTypeName(purchaseOrder.getUnitType().getTypeName());
				poModel.setVendorName(purchaseOrder.getVendor().getName());
				poList.add(poModel);
				
				if (statusVal.equals("Active")) {
					List<PurchaseOrderIssue> poIssues = purchaseOrder.getPoIssues();

					if (poIssues != null && !poIssues.isEmpty()) {
						Boolean isSuccess = true;
						for (PurchaseOrderIssue purchaseOrderIssue : poIssues) {
							Issue issue = purchaseOrderIssue.getIssue();
							if (!"Complete".equals(issue.getStatus().getTypeName())
									&& !"Incomplete".equals(issue.getStatus().getTypeName())) {
								isSuccess = false;
								break;
							}
						}

						poModel.setIsComplete(isSuccess);
						poModel.setCompleteStatusId(109l);
					}
				}

				if (statusVal.equals("Complete")) {
					poModel.setInvoiceStatusId(110l);
				}

			}
		}
		
		return poList;
	}


	private Object createSuccessObject(String msg, String statusVal) {

		Success success = new Success();
		success.setMessage(msg);
		success.setResultList(getStatusPOs(statusVal));
		return success;
	}

	private Object createFailedObject(String msg) {

		Failed failed = new Failed();
		failed.setMessage(msg);
		return failed;
	}

	@Override
	public Object update(Long id, PurchaseOrderModel poModel) {

		logger.info("PurchaseOrderServiceImpl update() starts.");
		Session session = null;
		Transaction tx = null;
		
		try {
			session = sessionFactory.openSession();
			tx = session.beginTransaction();
			PurchaseOrder po = (PurchaseOrder) session.get(PurchaseOrder.class, id);
			List<PurchaseOrderIssue> poIssues = new ArrayList<PurchaseOrderIssue>();
			List<Issue> issues = new ArrayList<Issue>();
			if (po != null) {
				setPoValues(poModel, po, poIssues, issues, session, Iconstants.UPDATE_PO);
				poDao.update(po, poIssues, issues, session);
				tx.commit();
			} else {
				return createFailedObject(po_unable_to_update_message);
			}

		} catch (Exception e) {
			if (tx != null) {
				tx.rollback();
			}
			logger.info("Exception inside PurchaseOrderServiceImpl update() :"+ e.getMessage());
			return createFailedObject(po_unable_to_update_message);
		} finally {
			if(session != null) {
				session.close();
			}
		}

		logger.info("PurchaseOrderServiceImpl update() ends.");
		return createSuccessObject(po_updated_message, "Active");
	}

	@Override
	public Object delete(Long id) {

		logger.info("PurchaseOrderServiceImpl delete() starts.");
		Session session = null;
		Transaction tx = null;

		try {
			session = sessionFactory.openSession();
			tx = session.beginTransaction();
			PurchaseOrder purchaseOrder = (PurchaseOrder) session.get(PurchaseOrder.class, id);
			
			if (purchaseOrder != null) {
				
				List<PurchaseOrderIssue> poIssues = purchaseOrder.getPoIssues();
				if(poIssues != null && ! poIssues.isEmpty()) {
					for (PurchaseOrderIssue purchaseOrderIssue : poIssues) {
						session.delete(purchaseOrderIssue);
					}
				}
				
				session.delete(purchaseOrder);
				tx.commit();
			} else {
				return createFailedObject(po_unable_to_delete_message);
			}

		} catch (Exception e) {
			logger.info("Exception inside PurchaseOrderServiceImpl delete() : " + e.getMessage());
			if (tx != null) {
				tx.rollback();
			}
			if (e instanceof ConstraintViolationException) {
				return createFailedObject(po_already_used_message);
			}
			return createFailedObject(po_unable_to_delete_message);
		} finally {
			if (session != null) {
				session.close();
			}
		}

		logger.info("PurchaseOrderServiceImpl delete() ends.");
		return createSuccessObject(po_deleted_message, "Active");
	}

	@Override
	public PurchaseOrderModel get(Long id) {

		logger.info("PurchaseOrderServiceImpl get() starts.");
		Session session = null;
		PurchaseOrderModel poModel = new PurchaseOrderModel();

		try {

			session = sessionFactory.openSession();
			PurchaseOrder po = poDao.findById(id, session);

			if (po != null) {

				poModel.setId(po.getId());
				poModel.setCategoryId(po.getCategory().getCategoryId());
				poModel.setMessage(po.getMessage());
				poModel.setUnitTypeId(po.getUnitType().getTypeId());
				poModel.setVendorId(po.getVendor().getVendorId());
				poModel.setStatusId(po.getStatus().getTypeId());
				
				/*if(po.getStatus().getTypeName().equals("Invoiced")) {
					poModel.setInvoiceNo(po.getInvoiceNo());
				}*/
				
				List<IssueModel> issueModels = new ArrayList<IssueModel>();
				List<PurchaseOrderIssue> poIssues = po.getPoIssues();
				
				if(poIssues != null && !poIssues.isEmpty()) {
					for (PurchaseOrderIssue purchaseOrderIssue : poIssues) {
						Issue issue = purchaseOrderIssue.getIssue();
						IssueModel issueObj = new IssueModel();
						issueObj.setId(issue.getId());
						issueObj.setTitle(issue.getIssueName());
						issueObj.setVmcName(issue.getVmc().getName());
						issueObj.setReportedByName(issue.getReportedBy().getFirstName());
						issueObj.setUnitTypeName(issue.getUnitType().getTypeName());
						issueObj.setCategoryName(issue.getCategory().getName());
						issueObj.setUnitNo(issue.getUnitNo());
						issueObj.setStatusName(issue.getStatus().getTypeName());
						issueObj.setStatusId(issue.getStatus().getTypeId());
						issueModels.add(issueObj);

					}
					
					poModel.setIssueList(issueModels);
				}
				
				getOpenAddData(poModel);
			}
		} finally {
			if (session != null) {
				session.close();
			}
		}

		logger.info("PurchaseOrderServiceImpl get() ends.");
		return poModel;
	}

	@Override
	public PurchaseOrderModel getOpenAdd() {

		logger.info("PurchaseOrderServiceImpl getOpenAdd() starts ");
		PurchaseOrderModel poModel = new PurchaseOrderModel();
		
		getOpenAddData(poModel);
		logger.info("PurchaseOrderServiceImpl getOpenAdd() ends ");
		return poModel;
	}

	private void getOpenAddData(PurchaseOrderModel poModel) {
		
		List<VendorModel> vendorList = vendorService.getSpecificData();
		poModel.setVendorList(vendorList);
		
	/*	List<CategoryModel> categoryList = categoryService.getSpecificData();
		poModel.setCategoryList(categoryList);*/
		
		List<TypeResponse> unitTypeList = typeService.getAll(25l);
		poModel.setUnitTypeList(unitTypeList);
		
		List<TypeResponse> issueStatusList = typeService.getAll(23l);
		poModel.setIssueStatusList(issueStatusList);
		
	}

	@Override
	public List<PurchaseOrderModel> getPoByPoNo(Long issueName) {

		logger.info("PurchaseOrderServiceImpl getPoByPoNo() starts ");
		Session session = null;
		List<PurchaseOrderModel> issueList = new ArrayList<PurchaseOrderModel>();

		try {
			session = sessionFactory.openSession();
			//List<Issue> issues = issueDao.getIssueByIssueName(session, issueName);
			//issueList = setIssueData(issues, issueList);
		} finally {
			if (session != null) {
				session.close();
			}
		}

		logger.info("PurchaseOrderServiceImpl getPoByPoNo() ends ");
		return issueList;
	}
	
	@Override
	public Object addPO(PurchaseOrderModel poModel) {

		logger.info("PurchaseOrderServiceImpl addPO() starts ");
		Session session = null;
		Transaction tx = null;
		
		try {
			session = sessionFactory.openSession();
			tx = session.beginTransaction();
			PurchaseOrder po = new PurchaseOrder();
			List<PurchaseOrderIssue> poIssues = new ArrayList<PurchaseOrderIssue>();
			List<Issue> issues = new ArrayList<Issue>();
			setPoValues(poModel, po, poIssues, issues, session, Iconstants.ADD_PO);
			Type assignStatus = typeService.get(106l);
			poDao.addPurchaseOrder(po, poIssues, issues, assignStatus, session);
			tx.commit();
		} catch (Exception e) {
			if(tx != null){
				tx.rollback();
			}
			logger.info("Exception inside PurchaseOrderServiceImpl addPO() :" + e.getMessage());
			return createFailedObject(po_unable_to_add_message);

		} finally {
			if(session != null){
				session.close();
			}
		}

		logger.info("PurchaseOrderServiceImpl addPO() ends ");
		return createSuccessObject(po_added_message, "Active");
	}

	private void setPoValues(PurchaseOrderModel poModel, PurchaseOrder po, List<PurchaseOrderIssue> poIssues,
			List<Issue> issues, Session session, String type) {
		
		List<IssueModel> issueData = poModel.getIssue();
		Type unitType = (Type) session.get(Type.class, poModel.getUnitTypeId());
		Category category = (Category) session.get(Category.class, poModel.getCategoryId());
		Vendor vendor = (Vendor) session.get(Vendor.class, poModel.getVendorId());
		
		if(Iconstants.ADD_PO.equals(type)) {
			Long poNo = poDao.getMaxPoNO(session);
			po.setPoNo(poNo+1);
			poModel.setStatusId(108l);
			Type status = (Type) session.get(Type.class, poModel.getStatusId());
			po.setStatus(status);
		} else {
			// existing issues
			List<PurchaseOrderIssue> existingPoIssues = po.getPoIssues();
			if (existingPoIssues != null && !existingPoIssues.isEmpty()) {
				Type openStatus = typeService.get(103l);
				for (PurchaseOrderIssue purchaseOrderIssue : existingPoIssues) {
					Issue issue = purchaseOrderIssue.getIssue();
					issue.setStatus(openStatus);
					session.update(issue);
					session.delete(purchaseOrderIssue);
				}
			}
		}
		
		po.setCategory(category);
		po.setMessage(poModel.getMessage());
		
		po.setUnitType(unitType);
		po.setVendor(vendor);

		if (issueData != null) {
			
			for (IssueModel issueModel : issueData) {
				Long issueId = issueModel.getId();
				PurchaseOrderIssue poIssue = new PurchaseOrderIssue();
				Issue issue = (Issue) session.get(Issue.class, issueId);
				poIssue.setIssue(issue);
				poIssues.add(poIssue);

				Type issueStatus = (Type) session.get(Type.class, issueModel.getStatusId());
				issue.setStatus(issueStatus);
				issues.add(issue);
			}
		}
		
	}

	@Override
	public List<IssueModel> getCategoryAndUnitTypeIssues(Long categoryId, Long unitTypeId) {

		Session session = null;
		List<IssueModel> issues = new ArrayList<IssueModel>();
		try {
			session = sessionFactory.openSession();
			issues = issueService.getIssueforCategoryAndUnitType(categoryId, unitTypeId, session);
		} finally {
			if(session != null){
				session.close();
			}
		}
		
		return issues;
	}

	@Override
	public List<IssueModel> getUnitNoIssues(Long unitTypeId, Long unitNo) {
		
		Session session = null;
		List<IssueModel> issues = new ArrayList<IssueModel>();
		try {
			session = sessionFactory.openSession();
			issues = issueService.getIssuesBasedOnUnitTypeAndNo(unitTypeId, unitNo, session);
		} finally {
			if(session != null){
				session.close();
			}
		}
		
		return issues;
	}

	@Override
	public List<IssueModel> getUnitNoIssues(Long unitTypeId, PurchaseOrderModel poModel) {
		Session session = null;
		List<IssueModel> issues = new ArrayList<IssueModel>();
		try {
			session = sessionFactory.openSession();
			issues = issueService.getIssuesBasedOnUnitTypeAndUnitNos(unitTypeId, poModel.getUnitNos(), session);
		} finally {
			if (session != null) {
				session.close();
			}
		}

		return issues;
	}

	@Override
	public Object updateStatus(Long poId, Long statusId, PurchaseOrderModel poModel) {
	
		logger.info("PurchaseOrderServiceImpl updateStatus() starts.");
		Session session = null;
		Transaction tx = null;
		Type status = null;
		try {
			session = sessionFactory.openSession();
			tx = session.beginTransaction();
			PurchaseOrder po = (PurchaseOrder) session.get(PurchaseOrder.class, poId);
			if (po != null) {
				status = (Type) session.get(Type.class, statusId);
				poDao.updateStatus(po, status, session);
				
				if(Iconstants.PO_INVOICE_STATUS.equals(status.getTypeName())) {
					PurchaseOrderInvoice invoice = createPOInvoice(po, poModel);
					poDao.createInvoice(invoice, session);
				}
				tx.commit();
			} else {
				return createFailedObject(po_status_unable_to_update);
			}

		} catch (Exception e) {
			if (tx != null) {
				tx.rollback();
			}
			logger.info("Exception inside PurchaseOrderServiceImpl updateStatus() :"+ e.getMessage());
			return createFailedObject(po_status_unable_to_update);
		} finally {
			if(session != null) {
				session.close();
			}
		}

		logger.info("PurchaseOrderServiceImpl updateStatus() ends.");
		return createSuccessObject(po_status_update, poModel.getCurrentStatusVal());
	}

	private PurchaseOrderInvoice createPOInvoice(PurchaseOrder po, PurchaseOrderModel poModel) {

		PurchaseOrderInvoice invoice = new PurchaseOrderInvoice();
		invoice.setAmount(poModel.getAmount());
		invoice.setInvoiceNo(poModel.getInvoiceNo());
		invoice.setInvoiceDate(DateUtil.changeStringToDate(poModel.getInvoiceDate()));
		invoice.setPurchaseOrder(po);
		return invoice;
	}

}
