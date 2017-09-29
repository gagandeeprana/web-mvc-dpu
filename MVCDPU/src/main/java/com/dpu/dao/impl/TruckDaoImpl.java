package com.dpu.dao.impl;

import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.dpu.dao.TruckDao;
import com.dpu.entity.Category;
import com.dpu.entity.Division;
import com.dpu.entity.Status;
import com.dpu.entity.Terminal;
import com.dpu.entity.Truck;
import com.dpu.entity.Type;
import com.dpu.model.TruckModel;
import com.dpu.service.StatusService;

@Repository
@Transactional
public class TruckDaoImpl extends GenericDaoImpl<Truck> implements TruckDao {

	@Autowired
	StatusService statusService;

	@Override
	public Truck add(Session session, TruckModel truckResponse) {
		logger.info("TruckDaoImpl: add(): STARTS");
		Truck truck = null;

		truck = setTruckValues(truckResponse);
		Status status = (Status) session.get(Status.class, truckResponse.getStatusId());
		truck.setStatus(status);

		Division division = (Division) session.get(Division.class, truckResponse.getDivisionId());
		truck.setDivision(division);

		Category category = (Category) session.get(Category.class, truckResponse.getCategoryId());
		truck.setCategory(category);

		Terminal terminal = (Terminal) session.get(Terminal.class, truckResponse.getTerminalId());
		truck.setTerminal(terminal);

		Type type = (Type) session.get(Type.class, truckResponse.getTruckTypeId());
		truck.setType(type);

		Long truckId = (Long) session.save(truck);

		truck.setTruckId(truckId);

		logger.info("TruckDaoImpl: add(): ENDS");

		return truck;

	}

	private Truck setTruckValues(TruckModel truckResponse) {

		logger.info("TruckDaoImpl: setTruckValues(): STARTS");

		Truck truck = new Truck();
		truck.setUnitNo(truckResponse.getUnitNo());
		truck.setOwner(truckResponse.getOwner());
		truck.setoOName(truckResponse.getoOName());
		truck.setUsage(truckResponse.getTruchUsage());
		truck.setFinance(truckResponse.getFinance());
		truck.setCreatedBy("jagvir");
		truck.setCreatedOn(new Date());
		truck.setModifiedBy("jagvir");
		truck.setModifiedOn(new Date());

		logger.info("TruckDaoImpl: setTruckValues(): ENDS");

		return truck;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Truck findById(Session session,Long id) {

		 Query query = session.createQuery("from Truck where truckId = "+id);
		 List<Truck> truck = query.list();
		 return truck.get(0);
		  
	}

	@Override
	public void update(Truck truck, Session session) {
		session.update(truck);
		
	}
}
