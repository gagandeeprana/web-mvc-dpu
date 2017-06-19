package com.dpu.service;

import java.util.List;

import com.dpu.entity.Driver;
import com.dpu.model.DriverReq;

/**
 * @author sumit
 *
 */

public interface DriverService {

	Object updateDriver(Long driverId, DriverReq driverReq);
	
	List<DriverReq> getAllDriver();
	
	Object deleteDriver(Long driverId);

	Object getDriverByDriverId(Long driverId);

	DriverReq getOpenAdd();

	Object addDriver(DriverReq driverReq);

	List<DriverReq> getDriverByDriverCodeOrName(String driverCodeOrName);
	
	List<DriverReq> getSpecificData();
	
}

