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

import com.dpu.dao.PurchaseOrderDao;
import com.dpu.entity.Category;
import com.dpu.entity.Issue;
import com.dpu.entity.PurchaseOrder;
import com.dpu.entity.PurchaseOrderIssue;
import com.dpu.entity.Type;
import com.dpu.entity.Vendor;
import com.dpu.model.CategoryReq;
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
			poList = setPOData(pos, poList);
			
		} finally {
			if (session != null) {
				session.close();
			}
		}

		logger.info("PurchaseOrderServiceImpl getAll() ends ");
		return poList;
	}

	private List<PurchaseOrderModel> setPOData(List<PurchaseOrder> pos,List<PurchaseOrderModel> poList) {
		
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
			}
		}
		
		return poList;
	}


	private Object createSuccessObject(String msg) {

		Success success = new Success();
		success.setMessage(msg);
		success.setResultList(getAll());
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
			if (po != null) {
				Type assignStatus = typeService.get(106l);
				Type openStatus = typeService.get(103l);
				setPoValues(poModel, po, poIssues, session, "update");
				poDao.update(po, poIssues, assignStatus, openStatus, session);
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
		return createSuccessObject(po_updated_message);
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
		return createSuccessObject(po_deleted_message);
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
				
				if(po.getStatus().getTypeName().equals("Invoiced")) {
					poModel.setInvoiceNo(po.getInvoiceNo());
				}
				
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
		
		List<CategoryReq> categoryList = categoryService.getSpecificData();
		poModel.setCategoryList(categoryList);
		
		List<TypeResponse> unitTypeList = typeService.getAll(25l);
		poModel.setUnitTypeList(unitTypeList);
		
		List<TypeResponse> statusList = typeService.getAll(24l);
		poModel.setStatusList(statusList);
		
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
			setPoValues(poModel, po, poIssues, session, "add");
			Type assignStatus = typeService.get(106l);
			poDao.addPurchaseOrder(po, poIssues, assignStatus, session);
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
		return createSuccessObject(po_added_message);
	}

	private void setPoValues(PurchaseOrderModel poModel, PurchaseOrder po, List<PurchaseOrderIssue> poIssues, Session session, String type) {
		
		List<Long> issueIds = poModel.getIssueIds();
		Type status = (Type) session.get(Type.class, poModel.getStatusId());
		Type unitType = (Type) session.get(Type.class, poModel.getUnitTypeId());
		Category category = (Category) session.get(Category.class, poModel.getCategoryId());
		Vendor vendor = (Vendor) session.get(Vendor.class, poModel.getVendorId());
		
		if("add".equals(type)) {
			Long poNo = poDao.getMaxPoNO(session);
			po.setPoNo(poNo+1);
		}
		
		po.setCategory(category);
		po.setMessage(poModel.getMessage());
		po.setStatus(status);
		po.setUnitType(unitType);
		po.setVendor(vendor);
	
		if(status.getTypeName().equals("Invoiced")){
			po.setInvoiceNo(poModel.getInvoiceNo());
		}
		
		if(issueIds != null){
			
			for (Long issueId : issueIds) {
				PurchaseOrderIssue poIssue = new PurchaseOrderIssue();
				Issue issue = (Issue) session.get(Issue.class, issueId);
				poIssue.setIssue(issue);
				poIssues.add(poIssue);
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
	public Object updateStatus(Long poId, Long statusId) {
		logger.info("PurchaseOrderServiceImpl updateStatus() starts.");
		Session session = null;
		Transaction tx = null;
		
		try {
			session = sessionFactory.openSession();
			tx = session.beginTransaction();
			PurchaseOrder po = (PurchaseOrder) session.get(PurchaseOrder.class, poId);
			if (po != null) {
				Type status = typeService.get(statusId);
				poDao.updateStatus(po, status, session);
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
		return createSuccessObject(po_status_update);
	}

	

}
