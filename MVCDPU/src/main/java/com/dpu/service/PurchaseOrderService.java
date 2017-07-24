package com.dpu.service;

import java.util.List;

import com.dpu.model.IssueModel;
import com.dpu.model.PurchaseOrderModel;

public interface PurchaseOrderService {
	/*Object update(Long id, IssueModel issueModel);*/

	Object delete(Long id);

	List<PurchaseOrderModel> getAll();

	PurchaseOrderModel getOpenAdd();

	PurchaseOrderModel get(Long id);
	
	List<IssueModel> getSpecificData();

	IssueModel getUnitNo(Long categoryId);

	Object addIssue(IssueModel issueModel);

	List<IssueModel> getIssueByIssueName(String issueName);

	Object addPO(PurchaseOrderModel poModel);

	List<IssueModel> getCategoryAndUnitTypeIssues(Long categoryId, Long unitTypeId);

	Object update(Long poId, PurchaseOrderModel poModel);

}
