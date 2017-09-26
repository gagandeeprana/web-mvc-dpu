package com.dpu.service.impl;

import java.util.ArrayList;
import java.util.Iterator;
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

import com.dpu.common.AllList;
import com.dpu.constants.Iconstants;
import com.dpu.dao.CategoryDao;
import com.dpu.dao.DivisionDao;
import com.dpu.dao.TerminalDao;
import com.dpu.dao.TrailerDao;
import com.dpu.entity.Category;
import com.dpu.entity.Division;
import com.dpu.entity.Status;
import com.dpu.entity.Terminal;
import com.dpu.entity.Trailer;
import com.dpu.entity.Type;
import com.dpu.model.CategoryModel;
import com.dpu.model.DivisionReq;
import com.dpu.model.Failed;
import com.dpu.model.Success;
import com.dpu.model.TerminalResponse;
import com.dpu.model.TrailerRequest;
import com.dpu.model.TypeResponse;
import com.dpu.service.CategoryService;
import com.dpu.service.DivisionService;
import com.dpu.service.StatusService;
import com.dpu.service.TerminalService;
import com.dpu.service.TrailerService;
import com.dpu.service.TypeService;

@Component
public class TrailerServiceImpl implements TrailerService{
	
	Logger logger = Logger.getLogger(TrailerServiceImpl.class);
	
	@Autowired
	TrailerDao trailerdao;
	
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
	
	@Value("${trailer_added_message}")
	private String trailer_added_message;
	
	@Value("${trailer_unable_to_add_message}")
	private String trailer_unable_to_add_message;
	
	@Value("${trailer_deleted_message}")
	private String trailer_deleted_message;
	
	@Value("${trailer_unable_to_delete_message}")
	private String trailer_unable_to_delete_message;
	
	@Value("${trailer_updated_message}")
	private String trailer_updated_message;
	
	@Value("${trailer_unable_to_update_message}")
	private String trailer_unable_to_update_message;
	
	@Value("${trailer_unit_no_already_exists}")
	private String trailer_unit_no_already_exists;
	
	@Override
	public Object add(TrailerRequest trailerRequest) {
		
		logger.info("Inside TrailerServiceImpl add() starts");
		Session session = null;
		Transaction tx = null;
		
		try{
			session = sessionFactory.openSession();
			tx = session.beginTransaction();
			
			Trailer trailer = new Trailer();
			BeanUtils.copyProperties(trailerRequest, trailer);
			
			Status status = (Status) session.get(Status.class, trailerRequest.getStatusId());
			trailer.setStatus(status);

			Division division = (Division) session.get(Division.class, trailerRequest.getDivisionId());
			trailer.setDivision(division);

			Category category = (Category) session.get(Category.class, trailerRequest.getCategoryId());
			trailer.setCategory(category);

			Terminal terminal = (Terminal) session.get(Terminal.class, trailerRequest.getTerminalId());
			trailer.setTerminal(terminal);

			Type type = (Type) session.get(Type.class, trailerRequest.getTrailerTypeId());
			trailer.setType(type);

			trailerdao.save(trailer, session);
			tx.commit();
		} catch (Exception e) {
			if(tx != null){
				tx.rollback();
			}
			if(e instanceof ConstraintViolationException){
				ConstraintViolationException c = (ConstraintViolationException) e;
				String constraintName = c.getConstraintName();
				if(Iconstants.UNIQUE_TRAILER_UNIT_NO.equals(constraintName)) {
					return createFailedObject(trailer_unit_no_already_exists);
				}
			}
			logger.error("Exception inside TrailerServiceImpl add() :"+e.getMessage());
			return createFailedObject(trailer_unable_to_add_message);
		} finally {
			if(session != null) {
				session.close();
			}
		}

		return createSuccessObject(trailer_added_message);
	}

	private Object createSuccessObject(String message) {
		Success success = new Success();
		success.setMessage(message);
		success.setResultList(getAll());
		return success;
	}
	
	private Object createFailedObject(String errorMessage) {
		Failed failed = new Failed();
		failed.setMessage(errorMessage);
		return failed;
	}
	
	@Override
	public Object update(Long trailerId, TrailerRequest trailerRequest) {
		
		logger.info("Inside TrailerServiceImpl update() Starts, trailerId :"+ trailerId);
		Session session =null;
		Transaction tx = null;
		
		try{
			
			session = sessionFactory.openSession();
			
			Trailer trailer = (Trailer) session.get(Trailer.class, trailerId);
			
			if(trailer != null){
				tx = session.beginTransaction();
				String[] ignoreProp = new String[1];
				ignoreProp[0] = "trailerId";
				BeanUtils.copyProperties(trailerRequest, trailer, ignoreProp);
				Status status = (Status) session.get(Status.class, trailerRequest.getStatusId());
				trailer.setStatus(status);

				Division division = (Division) session.get(Division.class, trailerRequest.getDivisionId());
				trailer.setDivision(division);

				Category category = (Category) session.get(Category.class, trailerRequest.getCategoryId());
				trailer.setCategory(category);

				Terminal terminal = (Terminal) session.get(Terminal.class, trailerRequest.getTerminalId());
				trailer.setTerminal(terminal);

				Type type = (Type) session.get(Type.class, trailerRequest.getTrailerTypeId());
				trailer.setType(type);
				
				trailerdao.update(trailer, session);
				tx.commit();
			} else{
				return createFailedObject(trailer_unable_to_update_message);
			}
			 
		} catch (Exception e) {
			logger.error("Exception inside TrailerServiceImpl update() :"+ e.getMessage());
			if(tx != null){
				tx.rollback();
			}
			if(e instanceof ConstraintViolationException){
				ConstraintViolationException c = (ConstraintViolationException) e;
				String constraintName = c.getConstraintName();
				if(Iconstants.UNIQUE_TRAILER_UNIT_NO.equals(constraintName)) {
					return createFailedObject(trailer_unit_no_already_exists);
				}
			}
			return createFailedObject(trailer_unable_to_update_message);
		} finally {
			if(session != null){
				session.close();
			}
		}
		
		logger.info("Inside TrailerServiceImpl update() Ends, trailerId :"+ trailerId);
		return createSuccessObject(trailer_updated_message);
	}

	@Override
	public Object delete(Long trailerId) {
		
		logger.info("Inside TrailerServiceImpl delete() starts, trailerId :"+ trailerId);
		Session session = null;
		Transaction tx = null;
		Object obj = null;
		try {
			session = sessionFactory.openSession();
			tx = session.beginTransaction();
			Trailer trailer = (Trailer) session.get(Trailer.class, trailerId);
			if(trailer != null){
				trailerdao.delete(trailer, session);
				tx.commit();
				obj = createSuccessObject(trailer_deleted_message);
			} else{
				obj = createFailedObject(trailer_unable_to_delete_message);
			}
			
		}catch (Exception e) {
			if (tx != null) {
				tx.rollback();
			}
			logger.error("Exceptiom inside TrailerServiceImpl delete() :"+ e.getMessage());
			obj = createFailedObject(trailer_unable_to_delete_message);
		}
		
		logger.info("Inside TrailerServiceImpl delete() ends, trailerId :"+ trailerId);
		return obj;
	}

	@Override
	public List<TrailerRequest> getAll() {
		
		logger.info("Inside TrailerServiceImpl getAll() starts "); 
		Session session = null;
		List<TrailerRequest> returnResponse = new ArrayList<TrailerRequest>();
		
		try{
			session = sessionFactory.openSession();
			List<Trailer> trailerList = trailerdao.findAll(session);
			if(trailerList !=  null && !trailerList.isEmpty()){
				
				for (Trailer trailer : trailerList) {
					TrailerRequest response = new TrailerRequest();
					BeanUtils.copyProperties(trailer, response);
					response.setCategory(trailer.getCategory().getName());
					response.setDivision(trailer.getDivision().getDivisionName());
					response.setTerminal(trailer.getTerminal().getTerminalName());
					response.setStatus(trailer.getStatus().getStatus());
					response.setTrailerType(trailer.getType().getTypeName());
					
					returnResponse.add(response);
				}
			}
		} catch (Exception e) {
			logger.error("Exception inside TrailerServiceImpl getAll():"+ e.getMessage());
		} finally{
			if(session != null){
				session.close();
			}
		}
		
		logger.info("Inside TrailerServiceImpl getAll() ends "); 
		return returnResponse;
	}

	@Override
	public TrailerRequest get(Long trailerId) {
		
		logger.info("Inside TrailerServiceImpl get() starts "); 
		Session session = null;
		TrailerRequest response = new TrailerRequest();
		
		try{
			session = sessionFactory.openSession();
			Trailer trailer = trailerdao.findById(trailerId, session);
			if(trailer != null){
				BeanUtils.copyProperties(trailer, response);
				response.setCategoryId(trailer.getCategory().getCategoryId());
				response.setDivisionId(trailer.getDivision().getDivisionId());
				response.setTerminalId(trailer.getTerminal().getTerminalId());
				response.setStatusId(trailer.getStatus().getId());
				response.setTrailerTypeId(trailer.getType().getTypeId());
				
				List<Status> statusList = AllList.getStatusList(session);
				response.setStatusList(statusList);
				
				List<TypeResponse> trailerTypeList = AllList.getTypeResponse(session, 7l);
				response.setTrailerTypeList(trailerTypeList);
				
				List<CategoryModel> categoryList = AllList.getCategoryList(session, "Category", "categoryId", "name");
				response.setCategoryList(categoryList);
				
				List<DivisionReq> divisionList = AllList.getDivisionList(session, "Division", "divisionId", "divisionName");
				response.setDivisionList(divisionList);
				
				List<TerminalResponse> terminalList = AllList.getTerminalList(session, "Terminal", "terminalId", "terminalName");
				response.setTerminalList(terminalList);
			}
			
		} finally{
			if(session != null){
				session.close();
			}
		}
		
		logger.info("Inside TrailerServiceImpl get() ends "); 
		return response;
	}

	@Override
	public TrailerRequest getOpenAdd() {

		Session session = sessionFactory.openSession();
		TrailerRequest trailer = new TrailerRequest();
		
		try{
			List<Status> statusList = AllList.getStatusList(session);
			trailer.setStatusList(statusList);
		
			List<TypeResponse> trailerTypeList = AllList.getTypeResponse(session, 7l);
			trailer.setTrailerTypeList(trailerTypeList);
				
			List<Object[]> categoryListObj = categoryDao.getSpecificData(session,"Category", "categoryId", "name");
			List<CategoryModel> categoryList = new ArrayList<CategoryModel>();
			Iterator<Object[]> operationIt = categoryListObj.iterator();
	
			while(operationIt.hasNext())
			{
				Object o[] = (Object[])operationIt.next();
				CategoryModel type = new CategoryModel();
				type.setCategoryId(Long.parseLong(String.valueOf(o[0])));
				type.setName(String.valueOf(o[1]));
				categoryList.add(type);
			}
			trailer.setCategoryList(categoryList);
		
		
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
			trailer.setDivisionList(divisionList);
			
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
			trailer.setTerminalList(terminalList);
		
			}catch(Exception e){
			
			}finally{
				if(session != null){
					session.close();
				}
			}
		
			return trailer;
	}

	@Override
	public List<TrailerRequest> getSpecificData() {
		
		Session session = sessionFactory.openSession();
		List<TrailerRequest> trailerData = new ArrayList<TrailerRequest>();
		
		try{
			List<Object[]> trailerIdAndNameList = trailerdao.getSpecificData(session,"Trailer", "trailerId", "owner");
		
			if(trailerIdAndNameList != null && !trailerIdAndNameList.isEmpty()){
				for (Object[] row : trailerIdAndNameList) {
					TrailerRequest trailerRequest =  new TrailerRequest();
					trailerRequest.setTrailerId(Long.parseLong(String.valueOf(row[0])));
					trailerRequest.setOwner(String.valueOf(row[1]));
					trailerData.add(trailerRequest);
			}
			
		}}catch(Exception e){
			
		}finally{
			if(session != null){
				session.close();
			}
		}
		
		return trailerData;
	}
}
