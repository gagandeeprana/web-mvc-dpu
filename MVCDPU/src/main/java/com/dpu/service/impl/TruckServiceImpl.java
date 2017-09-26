package com.dpu.service.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Restrictions;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.dpu.common.AllList;
import com.dpu.common.CommonProperties;
import com.dpu.constants.Iconstants;
import com.dpu.dao.CategoryDao;
import com.dpu.dao.DivisionDao;
import com.dpu.dao.TerminalDao;
import com.dpu.dao.TruckDao;
import com.dpu.dao.TypeDao;
import com.dpu.entity.Category;
import com.dpu.entity.Division;
import com.dpu.entity.Handling;
import com.dpu.entity.Status;
import com.dpu.entity.Terminal;
import com.dpu.entity.Truck;
import com.dpu.entity.Type;
import com.dpu.model.CategoryModel;
import com.dpu.model.DivisionReq;
import com.dpu.model.Failed;
import com.dpu.model.Success;
import com.dpu.model.TerminalResponse;
import com.dpu.model.TruckResponse;
import com.dpu.model.TypeResponse;
import com.dpu.service.CategoryService;
import com.dpu.service.DivisionService;
import com.dpu.service.StatusService;
import com.dpu.service.TerminalService;
import com.dpu.service.TruckService;
import com.dpu.service.TypeService;

@Component
public class TruckServiceImpl implements TruckService {

	@Autowired
	TruckDao truckDao;
	@Autowired
	CategoryDao categoryDao;

	@Autowired
	StatusService statusService;

	@Autowired
	SessionFactory sessionFactory;

	@Autowired
	CategoryService categoryService;

	@Autowired
	DivisionService divisionService;

	@Autowired
	TerminalService terminalService;

	@Autowired
	TypeService typeService;

	@Autowired
	DivisionDao divisionDao;

	@Autowired
	TerminalDao terminalDao;

	@Autowired
	TypeDao typeDao;

	@Value("${Truck_unit_No_already_exist}")
	private String Truck_unit_No_already_exist;
	
	@Value("${truck_dependent_message}")
	private String truck_dependent_message;
	
	Logger logger = Logger.getLogger(TruckServiceImpl.class);

	private Object createSuccessObject(String msg, long code) {
		Success success = new Success();
		success.setCode(code);
		success.setMessage(msg);
		success.setResultList(getAllTrucks(""));
		return success;
	}

	private Object createFailedObject(String msg, long code) {
		Failed failed = new Failed();
		failed.setCode(code);
		failed.setMessage(msg);
		//failed.setResultList(getAllTrucks(""));
		return failed;
	}

	@Override
	public Object update(Long id, TruckResponse truckResponse) {
	
		logger.info("TruckServiceImpl update() starts, truckId :"+id);
		Truck truck = null;
		Session session = null;
		Transaction tx = null;
		
		try {
			session = sessionFactory.openSession();
			
			truck = (Truck) session.get(Truck.class, id);	
			
			if (truck != null) {
				tx = session.beginTransaction();
				truck.setUnitNo(truckResponse.getUnitNo());
				truck.setOwner(truckResponse.getOwner());
				truck.setoOName(truckResponse.getoOName());
				truck.setUsage(truckResponse.getTruchUsage());
				truck.setFinance(truckResponse.getFinance());
				
				Category category = (Category) session.get(Category.class, truckResponse.getCategoryId());
				truck.setCategory(category);
				
				Division division = (Division) session.get(Division.class, truckResponse.getDivisionId());
				truck.setDivision(division);
				
				Terminal terminal = (Terminal) session.get(Terminal.class, truckResponse.getTerminalId());
				truck.setTerminal(terminal);
				
				Status status = (Status) session.get(Status.class, truckResponse.getStatusId());
				truck.setStatus(status);
				
				Type type = (Type) session.get(Type.class, truckResponse.getTruckTypeId());
				truck.setType(type);
				
				truckDao.update(truck, session);
				tx.commit();
			} else{
				return createFailedObject(CommonProperties.Truck_unable_to_update_message, Long.parseLong(CommonProperties.Truck_unable_to_update_code));
			}
			
		} catch (Exception e) {
			logger.info("Exception inside TruckServiceImpl update() :" + e.getMessage());
			if(tx != null){
				tx.rollback();
			}
			if(e instanceof ConstraintViolationException){
				ConstraintViolationException c = (ConstraintViolationException) e;
				String constraintName = c.getConstraintName();
				if(Iconstants.UNIQUE_TRUCK_UNIT_NO.equals(constraintName)) {
					return createFailedObject(Truck_unit_No_already_exist,0);
				}
			}
			return createFailedObject(CommonProperties.Truck_unable_to_update_message,Long.parseLong(CommonProperties.Truck_unable_to_update_code));
		} finally{
			if(session != null){
				session.close();
			}
		}

		logger.info("TruckServiceImpl update() ends, truckId :"+id);
		return createSuccessObject(CommonProperties.Truck_updated_message,Long.parseLong(CommonProperties.Equipment_updated_code));
	}

	@Override
	public Object delete(Long id) {

		logger.info("TruckServiceImpl delete() starts.");
		Session session = null;
		Transaction tx = null;

		try {
			session = sessionFactory.openSession();
			tx = session.beginTransaction();
			Truck truck = (Truck) session.get(Truck.class, id);
			if (truck != null) {
				session.delete(truck);
				tx.commit();
			} else {
				return createFailedObject(CommonProperties.Truck_unable_to_delete_message,0);
			}

		} catch (Exception e) {
			logger.info("Exception inside TruckServiceImpl delete() : " + e.getMessage());
			if (tx != null) {
				tx.rollback();
			}
			if (e instanceof ConstraintViolationException) {
				return createFailedObject(truck_dependent_message,0);
			}
			return createFailedObject(CommonProperties.Truck_unable_to_delete_message,0);
		} finally {
			if (session != null) {
				session.close();
			}
		}

		logger.info("TruckServiceImpl delete() ends.");
		return createSuccessObject(CommonProperties.Truck_deleted_message, 0);
	}

	@Override
	public TruckResponse get(Long id) {
		logger.info("[TruckServiceImpl] [get] : Enter ");
		
		Session session = sessionFactory.openSession();
		TruckResponse truckResponse = new TruckResponse();
		
		try{
			Truck truck = truckDao.findById(session, id);
			if (truck != null) {
				truckResponse.setTruckId(truck.getTruckId());
				truckResponse.setUnitNo(truck.getUnitNo());
				truckResponse.setOwner(truck.getOwner());
				truckResponse.setoOName(truck.getoOName());
				truckResponse.setStatusName(truck.getStatus().getStatus());
				truckResponse.setTruchUsage(truck.getUsage());
				truckResponse.setDivisionId(truck.getDivision().getDivisionId());
				truckResponse.setCategoryId(truck.getCategory().getCategoryId());
				truckResponse.setTerminalId(truck.getTerminal().getTerminalId());
				truckResponse.setStatusId(truck.getStatus().getId());
				truckResponse.setTruckTypeId(truck.getType().getTypeId());
				//truckResponse.setTypeName(truck.getType().getTypeName());
				truckResponse.setTruckType(truck.getType().getTypeName());
				truckResponse.setFinance(truck.getFinance());
				List<Status> lstStatus = AllList.getStatusList(session);
				truckResponse.setStatusList(lstStatus);

				List<CategoryModel> lstCategories = AllList.getCategoryList(session, "Category", "categoryId", "name");
				truckResponse.setCategoryList(lstCategories);

				List<TerminalResponse> lstTerminalResponses = AllList.getTerminalList(session, "Terminal", "terminalId", "terminalName");
				truckResponse.setTerminalList(lstTerminalResponses);

				List<DivisionReq> lstDivision = AllList.getDivisionList(session, "Division", "divisionId", "divisionName");
				truckResponse.setDivisionList(lstDivision);

				List<TypeResponse> truckTypeList = AllList.getTypeResponse(session, 8l);
				truckResponse.setTruckTypeList(truckTypeList);

		}
			}catch(Exception e){
			
		}finally{
			if(session != null){
				session.close();
			}
		}
		logger.info("[TruckServiceImpl] [get] : Exit ");
		return truckResponse;
	}

	@Override
	public List<TruckResponse> getAllTrucks(String owner) {
		
		logger.info("[TruckServiceImpl] [getAllTrucks] : Enter ");
		List<Truck> lstTruck = null;
		List<TruckResponse> lstTruckResponse = new ArrayList<TruckResponse>();
		try {

			if (owner != null && owner.length() > 0) {
				Criterion criterion = Restrictions.like("owner", owner,
						MatchMode.ANYWHERE);
				lstTruck = truckDao.find(criterion);
			} else {
				lstTruck = truckDao.findAll();
			}
			if (lstTruck != null && lstTruck.size() > 0) {
				for (Truck truck : lstTruck) {
					TruckResponse truckResponse = new TruckResponse();
					truckResponse.setTruckId(truck.getTruckId());
					truckResponse.setUnitNo(truck.getUnitNo());
					truckResponse.setOwner(truck.getOwner());
					truckResponse.setoOName(truck.getoOName());
					truckResponse
							.setCatogoryName(truck.getCategory().getName());
					truckResponse.setTruchUsage(truck.getUsage());

					truckResponse.setDivisionName(truck.getDivision()
							.getDivisionName());
					truckResponse.setTerminalName(truck.getTerminal()
							.getTerminalName());
					//truckResponse.setTypeName(truck.getType().getTypeName());

					truckResponse.setDivisionName(truck.getDivision()
							.getDivisionName());
					truckResponse.setTerminalName(truck.getTerminal()
							.getTerminalName());
					truckResponse.setTruckType(truck.getType().getTypeName());

					truckResponse.setFinance(truck.getFinance());
					truckResponse.setStatusName(truck.getStatus().getStatus());
					lstTruckResponse.add(truckResponse);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		logger.info("[TruckServiceImpl] [getAllTrucks] : Exit ");
		return lstTruckResponse;
	}

	@Override
	public Object add(TruckResponse truckResponse) {
		logger.info("TruckServiceImpl: add():  STARTS");
		Session session = null;
		Transaction tx = null;
		try {
			session = sessionFactory.openSession();
			tx = session.beginTransaction();
			truckDao.add(session, truckResponse);
			if (tx != null) {
				tx.commit();
			}
		} catch (Exception e) {
			logger.error("TruckServiceImpl: add(): Exception: ", e);
			if (tx != null) {
				tx.rollback();
			}
			if(e instanceof ConstraintViolationException){
				ConstraintViolationException c = (ConstraintViolationException) e;
				String constraintName = c.getConstraintName();
				if(Iconstants.UNIQUE_TRUCK_UNIT_NO.equals(constraintName)) {
					return createFailedObject(Truck_unit_No_already_exist,0);
				}
			}
			return createFailedObject(
					CommonProperties.Truck_unable_to_add_message,
					Long.parseLong(CommonProperties.Truck_unable_to_add_code));
		} finally {
			logger.info("TruckServiceImpl: add():  finally block");
			if (session != null) {
				session.close();
			}
		}

		logger.info("TruckServiceImpl: add():  ENDS");

		return createSuccessObject(CommonProperties.Truck_added_message,
				Long.parseLong(CommonProperties.Truck_added_code));

	}

	@Override
	public TruckResponse getOpenAdd() {
		
		TruckResponse truckResponse = new TruckResponse();
		Session session = sessionFactory.openSession();
		
		try{
			List<Status> lstStatus = AllList.getStatusList(session);
			truckResponse.setStatusList(lstStatus);

			List<Object[]> categoryListObj = categoryDao.getSpecificData(session,"Category", "categoryId", "name");
			List<CategoryModel> operationList = new ArrayList<CategoryModel>();
			Iterator<Object[]> operationIt = categoryListObj.iterator();
		
			while(operationIt.hasNext())
			{
				Object o[] = (Object[])operationIt.next();
				CategoryModel type = new CategoryModel();
				type.setCategoryId(Long.parseLong(String.valueOf(o[0])));
				type.setName(String.valueOf(o[1]));
				operationList.add(type);
			}
		
			truckResponse.setCategoryList(operationList);

			List<Object[]> divisionListObj =  divisionDao.getSpecificData(session,"Division", "divisionId", "divisionName");
		
			List<DivisionReq> divisionList = new ArrayList<DivisionReq>();
			Iterator<Object[]> divisionIt = divisionListObj.iterator();
		
			while(divisionIt.hasNext())
			{
				Object o[] = (Object[])divisionIt.next();
				DivisionReq type = new DivisionReq();
				type.setDivisionId(Long.parseLong(String.valueOf(o[0])));
				type.setDivisionName(String.valueOf(o[1]));
				divisionList.add(type);
			}
			truckResponse.setDivisionList(divisionList);

			//List<TerminalResponse> terminalList = terminalService.getAllTerminals();
			List<Object[]> terminalListObj = terminalDao.getSpecificData(session,"Terminal", "terminalId", "terminalName");
			List<TerminalResponse> terminalList = new ArrayList<TerminalResponse>();
			Iterator<Object[]> terminalIt = terminalListObj.iterator();
		
			while(terminalIt.hasNext())
			{
				Object o[] = (Object[])terminalIt.next();
				TerminalResponse type = new TerminalResponse();
				type.setTerminalId(Long.parseLong(String.valueOf(o[0])));
				type.setTerminalName(String.valueOf(o[1]));
				terminalList.add(type);
			}
			truckResponse.setTerminalList(terminalList);

			List<TypeResponse> truckTypeList = AllList.getTypeResponse(session, 8l);
			truckResponse.setTruckTypeList(truckTypeList);
		
			} catch(Exception e){
				e.printStackTrace();
			}finally{
				if(session != null){
					session.close();
				}
			}
			return truckResponse;

	}

	@Override
	public List<TruckResponse> getSpecificData() {

		Session session = sessionFactory.openSession();
		List<TruckResponse> truckData = new ArrayList<TruckResponse>();
		
		try{
			List<Object[]> truckIdAndNameList = truckDao.getSpecificData(session,"Truck", "truckId", "owner");
			if(truckIdAndNameList != null && !truckIdAndNameList.isEmpty()){
				for (Object[] row : truckIdAndNameList) {
					TruckResponse truckResponse =  new TruckResponse();
					truckResponse.setTruckId(Long.parseLong(String.valueOf(row[0])));
					truckResponse.setOwner(String.valueOf(row[1]));
					truckData.add(truckResponse);
				}
			
			}
		}catch(Exception e){
			
		}finally{
			if(session != null){
				session.close();
			}
		}
		return truckData;
	}

}
