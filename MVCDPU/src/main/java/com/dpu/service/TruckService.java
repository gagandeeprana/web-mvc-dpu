package com.dpu.service;

import java.util.List;

import com.dpu.model.TruckResponse;

public interface TruckService {

	Object update(Long id, TruckResponse truckResponse);

	Object delete(Long id);

	TruckResponse get(Long id);

	List<TruckResponse> getAllTrucks(String owner);

	Object add(TruckResponse truckResponse);
	
	TruckResponse getOpenAdd();
	
	List<TruckResponse> getSpecificData();

}
