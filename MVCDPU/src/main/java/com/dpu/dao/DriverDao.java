package com.dpu.dao;

import java.util.List;

import org.hibernate.Session;

import com.dpu.entity.Driver;

/**
 * @author sumit
 *
 */

public interface DriverDao extends GenericDao<Driver> {

	List<Driver> searchDriverByDriverCodeOrName(String driverCodeOrName);

	List<Driver> findAll(Session session);

	Driver findById(Long driverId, Session session);

	List<Object[]> getDriverIdAndName();

}
