package com.dpu.service;

import java.util.List;

import com.dpu.model.CountryStateCityModel;
import com.dpu.model.HandlingModel;

public interface CountryStateCityService {
	/*Object update(Long id, HandlingModel handlingModel);

	Object delete(Long id);*/

	List<CountryStateCityModel> getAll();

	/*HandlingModel getOpenAdd();

	HandlingModel get(Long id);
	
	List<HandlingModel> getSpecificData();

	Object addHandling(HandlingModel handlingModel);

	List<HandlingModel> getHandlingByHandlingName(String handlingName);*/

}
