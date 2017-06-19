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
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.dpu.common.AllList;
import com.dpu.common.CommonProperties;
import com.dpu.dao.CategoryDao;
import com.dpu.dao.DivisionDao;
import com.dpu.dao.TerminalDao;
import com.dpu.dao.TruckDao;
import com.dpu.dao.TypeDao;
import com.dpu.entity.Status;
import com.dpu.entity.Truck;
import com.dpu.model.CategoryReq;
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
		failed.setResultList(getAllTrucks(""));
		return failed;
	}

	@Override
	public Object update(Long id, TruckResponse truckResponse) {
		logger.info("[TruckServiceImpl] [update] : Enter ");
		Truck truck = null;
		try {
			truck = truckDao.findById(id);
			// if (truck != null) {
			truck.setUnitNo(truckResponse.getUnitNo());
			truck.setOwner(truckResponse.getOwner());
			truck.setoOName(truckResponse.getoOName());
			truck.setCategory(categoryService.getCategory(truckResponse
					.getCategoryId()));
			truck.setDivision(divisionDao.findById(truckResponse
					.getDivisionId()));
			truck.setTerminal(terminalDao.findById(truckResponse
					.getTerminalId()));
			truck.setStatus(statusService.get(truckResponse.getStatusId()));
			truck.setUsage(truckResponse.getTruchUsage());

			truck.setType(typeService.get(truckResponse.getTruckTypeId()));

			truck.setType(typeDao.findById(truckResponse.getTruckTypeId()));

			truck.setFinance(truckResponse.getFinance());

			truckDao.update(truck);
			// }
		} catch (Exception e) {
			logger.info("Exception inside TruckServiceImpl update() :"
					+ e.getMessage());
			return createFailedObject(
					CommonProperties.Truck_unable_to_update_message,
					Long.parseLong(CommonProperties.Truck_unable_to_update_code));
		}

		logger.info("[TruckServiceImpl] [get] : Exit ");
		return createSuccessObject(CommonProperties.Truck_updated_message,
				Long.parseLong(CommonProperties.Equipment_updated_code));
	}

	@Override
	public Object delete(Long id) {
		logger.info("[TruckServiceImpl] [delete] : Enter ");
		Truck truck = null;
		try {
			truck = truckDao.findById(id);
			truckDao.delete(truck);
		} catch (Exception e) {
			logger.error("[TruckServiceImpl] [delete] : ", e);
			return createFailedObject(
					CommonProperties.Truck_unable_to_delete_message,
					Long.parseLong(CommonProperties.Truck_unable_to_delete_code));
		}
		logger.info("[TruckServiceImpl] [get] : Exit ");
		return createSuccessObject(CommonProperties.Truck_deleted_message,
				Long.parseLong(CommonProperties.Truck_deleted_code));
	}

	@Override
	public TruckResponse get(Long id) {
		logger.info("[TruckServiceImpl] [get] : Enter ");
		
		Session session = sessionFactory.openSession();
		TruckResponse truckResponse = new TruckResponse();
		
		try{
			//Truck truck = truckDao.findById(id);
			Truck truck = truckDao.findById(session, id);
			if (truck != null) {
				BeanUtils.copyProperties(truck, truckResponse);
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
				truckResponse.setTypeName(truck.getType().getTypeName());
				truckResponse.setTruckType(truck.getType().getTypeName());
				truckResponse.setFinance(truck.getFinance());

				List<Status> lstStatus = AllList.getStatusList(session);
				truckResponse.setStatusList(lstStatus);

				List<CategoryReq> lstCategories = AllList.getCategoryList(session, "Category", "categoryId", "name");
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
					truckResponse.setTypeName(truck.getType().getTypeName());

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
			List<CategoryReq> operationList = new ArrayList<CategoryReq>();
			Iterator<Object[]> operationIt = categoryListObj.iterator();
		
			while(operationIt.hasNext())
			{
				Object o[] = (Object[])operationIt.next();
				CategoryReq type = new CategoryReq();
				type.setCategoryId(Long.parseLong(String.valueOf(o[0])));
				type.setName(String.valueOf(o[1]));
				operationList.add(type);
			}
		
			truckResponse.setCategoryList(operationList);

			List<Object[]> divisionListObj =  divisionDao.getSpecificData(session,"Division", "divisionId", "divisionId");
		
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
