package com.dpu.service;

import java.util.List;

import org.hibernate.Session;

import com.dpu.model.ShipperResponse;

public interface ShipperService {

	Object add(ShipperResponse shipperResponse);

	Object delete(Long id);

	List<ShipperResponse> getAll();

	ShipperResponse get(Long id);

	ShipperResponse getMasterData();

	List<ShipperResponse> getShipperByCompanyName(String companyName);

	Object update(Long id, ShipperResponse shipperResponse);
	
	List<ShipperResponse> getSpecificData(Session session);

	ShipperResponse getParticularData(Long id);
}
