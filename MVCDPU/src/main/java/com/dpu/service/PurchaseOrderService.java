package com.dpu.service;

import java.util.List;

import com.dpu.model.IssueModel;
import com.dpu.model.PurchaseOrderModel;

public interface PurchaseOrderService {

	Object delete(Long id);

	List<PurchaseOrderModel> getAll();

	PurchaseOrderModel getOpenAdd();

	PurchaseOrderModel get(Long id);
	
	Object addPO(PurchaseOrderModel poModel);

	List<IssueModel> getCategoryAndUnitTypeIssues(Long categoryId, Long unitTypeId);

	Object update(Long poId, PurchaseOrderModel poModel);

	List<PurchaseOrderModel> getPoByPoNo(Long poNo);

	Object updateStatus(Long poId, Long statusId);

}
