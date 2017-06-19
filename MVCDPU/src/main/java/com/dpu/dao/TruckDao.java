package com.dpu.dao;

import org.hibernate.Session;

import com.dpu.entity.Truck;
import com.dpu.model.TruckResponse;

/**
 * @author sumit
 *
 */
public interface TruckDao extends GenericDao<Truck> {

	Truck add(Session session, TruckResponse truckResponse);
	Truck findById(Session session,Long id);
	
}
