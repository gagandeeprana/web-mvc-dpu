package com.dpu.service;

import java.util.List;

import com.dpu.model.VehicleMaintainanceCategoryModel;

public interface VehicleMaintainanceCategoryService {
	/*Object update(Long id, HandlingModel handlingModel);

	Object delete(Long id);

	List<HandlingModel> getAll();

	HandlingModel getOpenAdd();

	HandlingModel get(Long id);
	
	List<HandlingModel> getSpecificData();

	List<HandlingModel> getHandlingByHandlingName(String handlingName);*/

	Object addVMC(VehicleMaintainanceCategoryModel vehicleMaintainanceCategoryModel);

	List<VehicleMaintainanceCategoryModel> getAll();

	VehicleMaintainanceCategoryModel get(Long vmcId);

	Object update(Long vmcId, VehicleMaintainanceCategoryModel vehicleMaintainanceCategoryModel);

	List<VehicleMaintainanceCategoryModel> getVmcByVmcName(String vmcName);

	Object delete(Long vmcId);

}
