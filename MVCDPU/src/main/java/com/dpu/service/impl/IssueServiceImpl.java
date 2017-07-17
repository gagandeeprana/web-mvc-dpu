package com.dpu.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.dpu.dao.HandlingDao;
import com.dpu.dao.IssueDao;
import com.dpu.entity.Company;
import com.dpu.entity.CompanyAdditionalContacts;
import com.dpu.entity.CompanyBillingLocation;
import com.dpu.entity.Driver;
import com.dpu.entity.Handling;
import com.dpu.entity.Issue;
import com.dpu.entity.Order;
import com.dpu.entity.Status;
import com.dpu.entity.Type;
import com.dpu.model.CategoryReq;
import com.dpu.model.DriverReq;
import com.dpu.model.Failed;
import com.dpu.model.HandlingModel;
import com.dpu.model.IssueModel;
import com.dpu.model.Success;
import com.dpu.model.TypeResponse;
import com.dpu.model.VehicleMaintainanceCategoryModel;
import com.dpu.service.CategoryService;
import com.dpu.service.DriverService;
import com.dpu.service.IssueService;
import com.dpu.service.StatusService;
import com.dpu.service.TypeService;
import com.dpu.service.VehicleMaintainanceCategoryService;

@Component
public class IssueServiceImpl implements IssueService  {

	Logger logger = Logger.getLogger(IssueServiceImpl.class);

	@Autowired
	HandlingDao handlingDao;
	
	@Autowired
	IssueDao issueDao;

	@Autowired
	StatusService statusService;

	@Autowired
	VehicleMaintainanceCategoryService vehicleMaintainanceCategoryService;
	
	@Autowired
	DriverService driverService;
	
	@Autowired
	CategoryService categoryService;
	
	@Autowired
	SessionFactory sessionFactory;
	
	@Autowired
	TypeService typeService;

	@Value("${issue_added_message}")
	private String issue_added_message;

	@Value("${issue_unable_to_add_message}")
	private String issue_unable_to_add_message;

	@Value("${issue_deleted_message}")
	private String issue_deleted_message;

	@Value("${issue_unable_to_delete_message}")
	private String issue_unable_to_delete_message;

	@Value("${issue_updated_message}")
	private String issue_updated_message;

	@Value("${issue_unable_to_update_message}")
	private String issue_unable_to_update_message;

	@Value("${issue_already_used_message}")
	private String issue_already_used_message;

	@Override
	public List<IssueModel> getAll() {

		logger.info("IssueServiceImpl getAll() starts ");
		Session session = null;
		List<IssueModel> issueList = new ArrayList<IssueModel>();

		try {
			session = sessionFactory.openSession();
			List<Issue> issues = issueDao.findAll(session);

			if (issues != null && !issues.isEmpty()) {
				for (Issue issue : issues) {
					IssueModel issueObj = new IssueModel();
					issueObj.setId(issue.getId());
//					issueObj.setName(issueObj.getName());
//					issueObj.setStatusName(issueObj.getStatus().getStatus());
					issueList.add(issueObj);
				}
			}
		} finally {
			if (session != null) {
				session.close();
			}
		}

		logger.info("IssueServiceImpl getAll() ends ");
		return issueList;
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

	/*@Override
	public Object addHandling(HandlingModel handlingModel) {

		logger.info("HandlingServiceImpl addHandling() starts ");
		Handling handling = null;
		try {
			handling = setHandlingValues(handlingModel);
			handlingDao.save(handling);

		} catch (Exception e) {
			logger.info("Exception inside HandlingServiceImpl addHandling() :"
					+ e.getMessage());
			return createFailedObject(issue_unable_to_add_message);

		}

		logger.info("HandlingServiceImpl addHandling() ends ");
		return createSuccessObject(issue_added_message);
	}*/

	private Handling setHandlingValues(HandlingModel handlingModel) {

		Handling handling = new Handling();
		handling.setName(handlingModel.getName());
		Status status = statusService.get(handlingModel.getStatusId());
		handling.setStatus(status);
		return handling;
	}

	@Override
	public Object update(Long id, HandlingModel handlingModel) {

		logger.info("IssueServiceImpl update() starts.");
		try {
			Handling handling = handlingDao.findById(id);

			if (handling != null) {
				handling.setName(handlingModel.getName());
				Status status = statusService.get(handlingModel.getStatusId());
				handling.setStatus(status);
				handlingDao.update(handling);
			} else {
				return createFailedObject(issue_unable_to_update_message);
			}

		} catch (Exception e) {
			logger.info("Exception inside IssueServiceImpl update() :"+ e.getMessage());
			return createFailedObject(issue_unable_to_update_message);
		}

		logger.info("IssueServiceImpl update() ends.");
		return createSuccessObject(issue_updated_message);
	}

	@Override
	public Object delete(Long id) {

		logger.info("IssueServiceImpl delete() starts.");
		Session session = null;
		Transaction tx = null;

		try {
			session = sessionFactory.openSession();
			tx = session.beginTransaction();
			Handling handling = (Handling) session.get(Handling.class, id);
			if (handling != null) {
				session.delete(handling);
				tx.commit();
			} else {
				return createFailedObject(issue_unable_to_delete_message);
			}

		} catch (Exception e) {
			logger.info("Exception inside IssueServiceImpl delete() : " + e.getMessage());
			if (tx != null) {
				tx.rollback();
			}
			if (e instanceof ConstraintViolationException) {
				return createFailedObject(issue_already_used_message);
			}
			return createFailedObject(issue_unable_to_delete_message);
		} finally {
			if (session != null) {
				session.close();
			}
		}

		logger.info("IssueServiceImpl delete() ends.");
		return createSuccessObject(issue_deleted_message);
	}

	@Override
	public HandlingModel get(Long id) {

		logger.info("IssueServiceImpl get() starts.");
		Session session = null;
		HandlingModel handlingModel = new HandlingModel();

		try {

			session = sessionFactory.openSession();
			Handling handling = handlingDao.findById(id, session);

			if (handling != null) {

				handlingModel.setId(handling.getId());
				handlingModel.setName(handling.getName());
				handlingModel.setStatusId(handling.getStatus().getId());

				List<Status> statusList = statusService.getAll();
				handlingModel.setStatusList(statusList);
			}
		} finally {
			if (session != null) {
				session.close();
			}
		}

		logger.info("IssueServiceImpl get() ends.");
		return handlingModel;
	}

	@Override
	public IssueModel getOpenAdd() {

		logger.info("IssueServiceImpl getOpenAdd() starts ");
		IssueModel issueModel = new IssueModel();

		List<VehicleMaintainanceCategoryModel> vmcList = vehicleMaintainanceCategoryService.getSpecificData();
		issueModel.setVmcList(vmcList);
		
		List<DriverReq> driverList = driverService.getSpecificData();
		issueModel.setReportedByList(driverList);
		
		List<TypeResponse> statusList = typeService.getAll(23l);
		issueModel.setStatusList(statusList);
		
		List<CategoryReq> unitTypeList = categoryService.getSpecificData();
		issueModel.setUnitTypeList(unitTypeList);
		
		logger.info("IssueServiceImpl getOpenAdd() ends ");
		return issueModel;
	}

	/*@Override
	public List<HandlingModel> getHandlingByHandlingName(String handlingName) {

		logger.info("IssueServiceImpl getHandlingByHandlingName() starts ");
		Session session = null;
		List<HandlingModel> handlings = new ArrayList<HandlingModel>();

		try {
			session = sessionFactory.openSession();
			List<Handling> handlingList = handlingDao.getHandlingByHandlingName(session, handlingName);
			if (handlingList != null && !handlingList.isEmpty()) {
				for (Handling handling : handlingList) {
					HandlingModel handlingObj = new HandlingModel();
					handlingObj.setId(handling.getId());
					handlingObj.setName(handling.getName());
					handlingObj.setStatusName(handling.getStatus().getStatus());
					handlings.add(handlingObj);
				}
			}
		} finally {
			if (session != null) {
				session.close();
			}
		}

		logger.info("IssueServiceImpl getHandlingByHandlingName() ends ");
		return handlings;
	}*/

	@Override
	public List<IssueModel> getIssueByIssueName(String issueName) {

		logger.info("IssueServiceImpl getIssueByIssueName() starts ");
		Session session = null;
		List<IssueModel> issues = new ArrayList<IssueModel>();

		try {
			session = sessionFactory.openSession();
			List<Issue> issueList = issueDao.getIssueByIssueName(session, issueName);
			if (issueList != null && !issueList.isEmpty()) {
				for (Issue issue : issueList) {
					IssueModel issueObj = new IssueModel();
					issueObj.setId(issue.getId());
					/*issueObj.setName(issue.getName());
					issueObj.setStatusName(issue.getStatus().getStatus());*/
					issues.add(issueObj);
				}
			}
		} finally {
			if (session != null) {
				session.close();
			}
		}

		logger.info("IssueServiceImpl getHandlingByHandlingName() ends ");
		return issues;
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
			List<Object> unitNos = issueDao.getUnitNos(categoryId, session);
			if(unitNos != null){
				List<String> unitNo = iterateUnitNos(unitNos);
				issueModel.setUnitNos(unitNo);
			}
		} finally {
			if(session != null){
				session.close();
			}
		}
		
		return issueModel;
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
		
		logger.info("HandlingServiceImpl addHandling() starts ");
		Issue issue = null;
		Session session = null;
		Transaction tx = null;
		
		try {
			issue = setIssueValues(issueModel, session, issue);
			issueDao.save(issue);

		} catch (Exception e) {
			logger.info("Exception inside HandlingServiceImpl addHandling() :"
					+ e.getMessage());
			return createFailedObject(issue_unable_to_add_message);

		}

		logger.info("HandlingServiceImpl addHandling() ends ");
		return createSuccessObject(issue_added_message);
	}

	private Issue setIssueValues(IssueModel issueModel, Session session, Issue issue) {

		Driver reportedBy = (Driver) session.get(Driver.class, issueModel.getReportedById());
		/*CompanyBillingLocation billingLocation = (CompanyBillingLocation) session.get(CompanyBillingLocation.class, orderModel.getBillingLocationId());
		CompanyAdditionalContacts additionalContacts = (CompanyAdditionalContacts) session.get(CompanyAdditionalContacts.class, orderModel.getContactId());
		Type temp = (Type) session.get(Type.class, orderModel.getTemperatureId());
		Type tempType = (Type) session.get(Type.class, orderModel.getTemperatureTypeId());
		Type currency = (Type) session.get(Type.class, orderModel.getCurrencyId());
		
		Order order = new Order();
		BeanUtils.copyProperties(orderModel, order);
		order.setCompany(company);
		order.setBillingLocation(billingLocation);
		order.setContact(additionalContacts);
		order.setTemperature(temp);
		order.setTemperatureType(tempType);
		order.setCurrency(currency);
		orderDao.saveOrder(session, order);*/
		return issue;
	}

	

}
