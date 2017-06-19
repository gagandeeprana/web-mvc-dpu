package com.dpu.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.dpu.common.AllList;
import com.dpu.dao.CategoryDao;
import com.dpu.dao.DivisionDao;
import com.dpu.dao.DriverDao;
import com.dpu.dao.TerminalDao;
import com.dpu.entity.Driver;
import com.dpu.entity.Status;
import com.dpu.model.CategoryReq;
import com.dpu.model.DivisionReq;
import com.dpu.model.DriverReq;
import com.dpu.model.Failed;
import com.dpu.model.Success;
import com.dpu.model.TerminalResponse;
import com.dpu.model.TypeResponse;
import com.dpu.service.CategoryService;
import com.dpu.service.DivisionService;
import com.dpu.service.DriverService;
import com.dpu.service.StatusService;
import com.dpu.service.TerminalService;
import com.dpu.service.TypeService;

@Component
public class DriverServiceImpl implements DriverService {

	@Autowired
	DriverDao driverDao;

	@Autowired
	StatusService statusService;

	@Autowired
	TypeService typeService;

	@Autowired
	CategoryService categoryService;

	@Autowired
	DivisionService divisionService;

	@Autowired
	TerminalService terminalService;

	@Autowired
	CategoryDao categoryDao;

	@Autowired
	DivisionDao divisionDao;

	@Autowired
	TerminalDao terminalDao;

	@Autowired
	SessionFactory sessionFactory;

	Logger logger = Logger.getLogger(DriverServiceImpl.class);
	

	@Value("${Driver_added_message}")
	private String Driver_added_message;
	
	@Value("${Driver_unable_to_add_message}")
	private String Driver_unable_to_add_message;
	
	@Value("${Driver_deleted_message}")
	private String Driver_deleted_message;
	
	@Value("${Driver_unable_to_delete_message}")
	private String Driver_unable_to_delete_message;
	
	@Value("${Driver_updated_message}")
	private String Driver_updated_message;
	
	@Value("${Driver_unable_to_update_message}")
	private String Driver_unable_to_update_message;
	
	@Value("${Drive_dependent_message}")
	private String Drive_dependent_message;

	@Override
	public Object addDriver(DriverReq driverReq) {

		logger.info("Inside DriverServiceImpl addDriver() starts");
		Object obj = null;
		try {
		
			Driver driver = new Driver();
			BeanUtils.copyProperties(driverReq, driver);
			driver.setCategory(categoryDao.findById(driverReq.getCategoryId()));
			driver.setDivision(divisionDao.findById(driverReq.getDivisionId()));
			driver.setTerminal(terminalDao.findById(driverReq.getTerminalId()));
			driver.setRole(typeService.get(driverReq.getRoleId()));
			driver.setDriverClass(typeService.get(driverReq.getDriverClassId()));
			driver.setStatus(statusService.get(driverReq.getStatusId()));
			driverDao.save(driver);
			obj = createSuccessObject(Driver_added_message);
		} catch (Exception e) {
			logger.error("Exception inside DriverServiceImpl addDriver() :"+ e.getMessage());
			obj = createFailedObject(Driver_unable_to_add_message);
		}

		logger.info("Inside DriverServiceImpl addDriver() Ends");
		return obj;
	}

	private Object createFailedObject(String errorMessage) {
		Failed failed = new Failed();
		failed.setMessage(errorMessage);
		return failed;
	}

	private Object createSuccessObject(String message) {
		Success success = new Success();
		success.setMessage(message);
		success.setResultList(getAllDriver());
		return success;
	}

	@SuppressWarnings("unused")
	private Driver setDriverValues(DriverReq driverReq) {
		Driver driver = new Driver();
		driver.setDriverCode(driverReq.getDriverCode());
		driver.setFirstName(driverReq.getFirstName());
		driver.setLastName(driverReq.getLastName());
		driver.setAddress(driverReq.getAddress());
		driver.setUnit(driverReq.getUnit());
		driver.setCity(driverReq.getCity());
		driver.setPostalCode(driverReq.getPostalCode());
		driver.setEmail(driverReq.getEmail());
		driver.setHome(driverReq.getHome());
		driver.setFaxNo(driverReq.getFaxNo());
		driver.setCellular(driverReq.getCellular());
		driver.setPager(driverReq.getPager());
		/*
		 * driver.setDivision(driverReq.getDivision());
		 * driver.setTerminalId(driverReq.getTerminalId());
		 * driver.setCatogoryId(driverReq.getCatogoryId());
		 * driver.setRoleId(driverReq.getRoleId());
		 * driver.setStatusId(driverReq.getStatusId());
		 * driver.setDriverClassId(driverReq.getDriverClassId());
		 */
		driver.setCreatedOn(new Date());
		return driver;
	}

	@Override
	public Object updateDriver(Long driverId, DriverReq driverReq) {

		logger.info("Inside DriverServiceImpl updateDriver() Starts, driverId :"+ driverId);
		Object obj = null;

		try {
			Driver driver = driverDao.findById(driverId);

			if (driver != null) {
				String[] ignoreProp = new String[1];
				ignoreProp[0] = "driverId";
				BeanUtils.copyProperties(driverReq, driver, ignoreProp);
				driver.setCategory(categoryDao.findById(driverReq.getCategoryId()));
				driver.setDivision(divisionDao.findById(driverReq.getDivisionId()));
				driver.setTerminal(terminalDao.findById(driverReq.getTerminalId()));
				driver.setRole(typeService.get(driverReq.getRoleId()));
				driver.setDriverClass(typeService.get(driverReq.getDriverClassId()));
				driver.setStatus(statusService.get(driverReq.getStatusId()));
				driverDao.update(driver);
				obj = createSuccessObject(Driver_updated_message);
			} else {
				obj = createFailedObject(Driver_unable_to_update_message);
			}

		} catch (Exception e) {
			logger.error("Exception inside DriverServiceImpl updateDriver() :"+ e.getMessage());
			obj = createFailedObject(Driver_unable_to_update_message);
		}

		logger.info("Inside DriverServiceImpl updateDriver() ends, driverId :"+ driverId);
		return obj;
	}

	@Override
	public Object deleteDriver(Long driverId) {

		logger.info("Inside DriverServiceImpl deleteDriver() starts, driverId :"+ driverId);
		Session session = null;
		Transaction tx = null;

		try {
			session = sessionFactory.openSession();
			tx = session.beginTransaction();
			
			Driver driver = driverDao.findById(driverId);

			if (driver != null) {
				session.delete(driver);
			} else {
				return createFailedObject(Driver_unable_to_delete_message);
			}
		} catch (Exception e) {
			logger.error("Exceptiom inside DriverServiceImpl deleteDriver() :"+ e.getMessage());
			if(tx != null){
				tx.rollback();
			}
			if(e instanceof ConstraintViolationException){
				return createFailedObject(Drive_dependent_message);
			}
			return createFailedObject(Driver_unable_to_delete_message);
		} finally{
			if(tx != null){
				tx.commit();
			} 
			if(session != null){
				session.close();
			}
		}

		logger.info("Inside DriverServiceImpl deleteDriver() ends, driverId :"+ driverId);
		return createSuccessObject(Driver_deleted_message);

	}

	@Override
	public List<DriverReq> getAllDriver() {

		logger.info("Inside DriverServiceImpl getAllDriver() starts ");
		Session session = null;
		List<DriverReq> drivers = null;

		try {
			session = sessionFactory.openSession();
			List<Driver> listOfDriver = driverDao.findAll(session);
			drivers = setDriverData(listOfDriver);

		} catch (Exception e) {
			logger.error("Exception inside DriverServiceImpl getAllDriver():"
					+ e.getMessage());
		} finally {
			if (session != null) {
				session.close();
			}
		}

		logger.info("Inside DriverServiceImpl getAllDriver() ends ");
		return drivers;
	}

	private List<DriverReq> setDriverData(List<Driver> listOfDriver) {

		List<DriverReq> drivers = new ArrayList<DriverReq>();
		if (listOfDriver != null && !listOfDriver.isEmpty()) {
			for (Driver driver : listOfDriver) {
				DriverReq driverReq = new DriverReq();
				BeanUtils.copyProperties(driver, driverReq);
				driverReq.setCategoryName(driver.getCategory().getName());
				driverReq.setTerminalName(driver.getTerminal()
						.getTerminalName());
				driverReq.setStatusName(driver.getStatus().getStatus());
				driverReq.setDivisionName(driver.getDivision()
						.getDivisionName());
				driverReq.setDriverClassName(driver.getDriverClass()
						.getTypeName());
				driverReq.setRoleName(driver.getRole().getTypeName());
				drivers.add(driverReq);
			}
		}

		return drivers;
	}

	@Override
	public Object getDriverByDriverId(Long driverId) {

		logger.info("Inside DriverServiceImpl getDriverByDriverId() starts, driverId :"
				+ driverId);
		Session session = null;
		Object obj = null;
		String message = "Driver data get Successfully";

		try {
			session = sessionFactory.openSession();
			Driver driver = driverDao.findById(driverId, session);
			DriverReq response = new DriverReq();

			if (driver != null) {
				BeanUtils.copyProperties(driver, response);
				response.setCategoryId(driver.getCategory().getCategoryId());
				response.setStatusId(driver.getStatus().getId());
				response.setDivisionId(driver.getDivision().getDivisionId());
				response.setDriverClassId(driver.getDriverClass().getTypeId());
				response.setRoleId(driver.getRole().getTypeId());
				response.setTerminalId(driver.getTerminal().getTerminalId());
				
				List<Status> statusList = AllList.getStatusList(session);
				response.setStatusList(statusList);

				List<TypeResponse> roleList = AllList.getTypeResponse(session, 6l);
				response.setRoleList(roleList);

				List<TypeResponse> driverClassList = AllList.getTypeResponse(session, 5l);
				response.setDriverClassList(driverClassList);

				List<CategoryReq> categoryList = AllList.getCategoryList(session, "Category", "categoryId", "name");
				response.setCategoryList(categoryList);

				List<DivisionReq> divisionList = AllList.getDivisionList(session, "Division", "divisionId", "divisionName");
				response.setDivisionList(divisionList);

				List<TerminalResponse> terminalList = AllList.getTerminalList(session, "Terminal", "terminalId", "terminalName");
				response.setTerminalList(terminalList);
				
				obj = createSuccessObjectForParRecord(message, response);
			} else {
				message = "Error while getting record";
				obj = createFailedObject(message);
			}
		} catch (Exception e) {
			message = "Error while getting record";
			obj = createFailedObject(message);
		} finally {
			if (session != null) {
				session.close();
			}
		}
		return obj;
	}

	private Object createSuccessObjectForParRecord(String message,
			DriverReq response) {
		Success success = new Success();
		success.setMessage(message);
		success.setResultList(response);
		return success;
	}

	public boolean isDriverExist(String driverCode) {
		boolean isDriverExist = false;

		Criterion driverCriteria = Restrictions.eqOrIsNull("driverCode",
				driverCode);
		List<Driver> drivers = driverDao.find(driverCriteria);

		if (drivers.size() == 0) {

			return isDriverExist;
		}

		isDriverExist = true;
		return isDriverExist;

	}

	@Override
	public DriverReq getOpenAdd() {

		DriverReq driver = new DriverReq();
		Session session = sessionFactory.openSession();
		
		try{
			List<Status> statusList = AllList.getStatusList(session);
			driver.setStatusList(statusList);

			List<TypeResponse> roleList = AllList.getTypeResponse(session, 6l);
			driver.setRoleList(roleList);

			List<TypeResponse> driverClassList = AllList.getTypeResponse(session, 5l);
			driver.setDriverClassList(driverClassList);

			List<CategoryReq> categoryList = AllList.getCategoryList(session,"Category", "categoryId", "name");
			driver.setCategoryList(categoryList);
	
	 
			List<DivisionReq> divisionList = AllList.getDivisionList(session,"Division", "divisionId", "divisionId");
			driver.setDivisionList(divisionList);
		
		 
			List<TerminalResponse> terminalList = AllList.getTerminalList(session, "Terminal", "terminalId", "terminalName");
			driver.setTerminalList(terminalList);
	
		}catch(Exception e){
			
		}finally{
			if(session != null){
				session.close();
			}
		}

		return driver;
	}

	@Override
	public List<DriverReq> getDriverByDriverCodeOrName(String driverCodeOrName) {

		List<DriverReq> driverReqList = new ArrayList<DriverReq>();
		List<Driver> driverList = driverDao
				.searchDriverByDriverCodeOrName(driverCodeOrName);
		driverReqList = setDriverData(driverList);
		return driverReqList;
	}

	@Override
	public List<DriverReq> getSpecificData() {
		
		List<Object[]> driverIdNameList = driverDao.getDriverIdAndName();
		List<DriverReq> driverList = new ArrayList<DriverReq>();
		
		if(driverIdNameList != null && ! driverIdNameList.isEmpty()){
			for (Object[] row : driverIdNameList) {
				DriverReq driver = new DriverReq();
				driver.setDriverId(Long.parseLong(String.valueOf(row[0])));
				driver.setFullName(String.valueOf(row[1]) +" "+String.valueOf(row[2]));
				driverList.add(driver);
			}
		}
		
		return driverList;
	}

}
