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

import com.dpu.dao.HandlingDao;
import com.dpu.dao.IssueDao;
import com.dpu.dao.PurchaseOrderDao;
import com.dpu.entity.Category;
import com.dpu.entity.Driver;
import com.dpu.entity.Issue;
import com.dpu.entity.PurchaseOrder;
import com.dpu.entity.PurchaseOrderIssue;
import com.dpu.entity.Type;
import com.dpu.entity.VehicleMaintainanceCategory;
import com.dpu.entity.Vendor;
import com.dpu.model.CategoryReq;
import com.dpu.model.Failed;
import com.dpu.model.IssueModel;
import com.dpu.model.PurchaseOrderModel;
import com.dpu.model.Success;
import com.dpu.model.TypeResponse;
import com.dpu.model.VendorModel;
import com.dpu.service.CategoryService;
import com.dpu.service.DriverService;
import com.dpu.service.IssueService;
import com.dpu.service.PurchaseOrderService;
import com.dpu.service.StatusService;
import com.dpu.service.TypeService;
import com.dpu.service.VehicleMaintainanceCategoryService;
import com.dpu.service.VendorService;

@Component
public class PurchaseOrderServiceImpl implements PurchaseOrderService  {

	Logger logger = Logger.getLogger(PurchaseOrderServiceImpl.class);

	@Autowired
	HandlingDao handlingDao;
	
	@Autowired
	IssueDao issueDao;

	@Autowired
	StatusService statusService;
	
	@Autowired
	IssueService issueService;

	@Autowired
	VehicleMaintainanceCategoryService vehicleMaintainanceCategoryService;
	
	@Autowired
	DriverService driverService;
	
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
		// failed.setResultList(getAll());
		return failed;
	}

	@Override
	public Object update(Long id, PurchaseOrderModel poModel) {

		logger.info("IssueServiceImpl update() starts.");
		Session session = null;
		Transaction tx = null;
		
		try {
			session = sessionFactory.openSession();
			tx = session.beginTransaction();
			PurchaseOrder po = (PurchaseOrder) session.get(PurchaseOrder.class, id);
			List<PurchaseOrderIssue> poIssues = new ArrayList<PurchaseOrderIssue>();
			if (po != null) {
				setPoValues(poModel, po, poIssues, session, "update");
				poDao.update(po, poIssues, session);
				tx.commit();
			} else {
				return createFailedObject(po_unable_to_update_message);
			}

		} catch (Exception e) {
			if (tx != null) {
				tx.rollback();
			}
			logger.info("Exception inside IssueServiceImpl update() :"+ e.getMessage());
			return createFailedObject(po_unable_to_update_message);
		} finally {
			if(session != null) {
				session.close();
			}
		}

		logger.info("IssueServiceImpl update() ends.");
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
			logger.info("Exception inside IssueServiceImpl delete() : " + e.getMessage());
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

		logger.info("IssueServiceImpl delete() ends.");
		return createSuccessObject(po_deleted_message);
	}

	@Override
	public PurchaseOrderModel get(Long id) {

		logger.info("IssueServiceImpl get() starts.");
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

		logger.info("IssueServiceImpl get() ends.");
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
	public List<IssueModel> getIssueByIssueName(String issueName) {

		logger.info("IssueServiceImpl getIssueByIssueName() starts ");
		Session session = null;
		List<IssueModel> issueList = new ArrayList<IssueModel>();

		try {
			session = sessionFactory.openSession();
			List<Issue> issues = issueDao.getIssueByIssueName(session, issueName);
			//issueList = setIssueData(issues, issueList);
		} finally {
			if (session != null) {
				session.close();
			}
		}

		logger.info("IssueServiceImpl getHandlingByHandlingName() ends ");
		return issueList;
	}
	
	@Override
	public List<IssueModel> getSpecificData() {

		Session session = sessionFactory.openSession();
		List<IssueModel> issueList = new ArrayList<IssueModel>();
		
		try {
			List<Object[]> issueData = handlingDao.getSpecificData(session, "Issue", "id", "issueName");
			
			if (issueData != null && !issueData.isEmpty()) {
				for (Object[] row : issueData) {
					IssueModel issueObj = new IssueModel();
					issueObj.setId((Long) row[0]);
					issueObj.setTitle(String.valueOf(row[1]));
					issueList.add(issueObj);
				}
			}
		} finally {
			if (session != null) {
				session.close();
			}
		}
		return issueList;
	}

	@Override
	public IssueModel getUnitNo(Long categoryId) {
		
		Session session = null;
		IssueModel issueModel = new IssueModel();
		try {
			session = sessionFactory.openSession();
			List<String> getUnitNos = getUnitNosForCategory(categoryId, session);
			issueModel.setUnitNos(getUnitNos);
		} finally {
			if(session != null){
				session.close();
			}
		}
		
		return issueModel;
	}

	private List<String> getUnitNosForCategory(Long categoryId, Session session) {
		List<String> unitNo = new ArrayList<String>();
		/*List<Object> unitNos = issueDao.getUnitNos(categoryId, session);
		if(unitNos != null){
			unitNo = iterateUnitNos(unitNos);
		}*/
		
		return unitNo;
	}

	private List<String> iterateUnitNos(List<Object> unitNos) {
		
		List<String> unitNoList = new ArrayList<String>();
		for (Object obj : unitNos) {
			String unitNo = String.valueOf(obj);
			unitNoList.add(unitNo);
		}
		
		return unitNoList;
	}

	@Override
	public Object addIssue(IssueModel issueModel) {
		
		logger.info("IssueServiceImpl addIssue() starts ");
		Issue issue = null;
		Session session = null;
		Transaction tx = null;
		
		try {
			session = sessionFactory.openSession();
			tx = session.beginTransaction();
			issue = new Issue();
			issue = setIssueValues(issueModel, session, issue);
			issueDao.saveIssue(issue, session);
			tx.commit();
		} catch (Exception e) {
			if(tx != null){
				tx.rollback();
			}
			logger.info("Exception inside IssueServiceImpl addIssue() :" + e.getMessage());
			return createFailedObject(po_unable_to_add_message);

		} finally {
			if(session != null){
				session.close();
			}
		}

		logger.info("IssueServiceImpl addIssue() ends ");
		return createSuccessObject(po_added_message);
	}

	private Issue setIssueValues(IssueModel issueModel, Session session, Issue issue) {

		Driver reportedBy = (Driver) session.get(Driver.class, issueModel.getReportedById());
		VehicleMaintainanceCategory vmc = (VehicleMaintainanceCategory) session.get(VehicleMaintainanceCategory.class, issueModel.getVmcId());
		Category unitType = (Category) session.get(Category.class, issueModel.getUnitTypeId());
		Type status = (Type) session.get(Type.class, issueModel.getStatusId());
		
		issue.setReportedBy(reportedBy);
		issue.setVmc(vmc);
		//issue.setUnitType(unitType);
		issue.setStatus(status);
		issue.setIssueName(issueModel.getTitle());
		issue.setUnitNo(issueModel.getUnitNo());
		return issue;
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
			poDao.addPurchaseOrder(po, poIssues, session);
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

	

}
