package com.dpu.service;

import java.util.List;

import com.dpu.model.HandlingModel;
import com.dpu.model.IssueModel;

public interface IssueService {
	Object update(Long id, HandlingModel handlingModel);

	Object delete(Long id);

	List<IssueModel> getAll();

	IssueModel getOpenAdd();

	HandlingModel get(Long id);
	
	List<IssueModel> getSpecificData();

	/*Object addHandling(HandlingModel handlingModel);*/

	/*List<HandlingModel> getHandlingByHandlingName(String handlingName);*/

	IssueModel getUnitNo(Long categoryId);

	Object addIssue(IssueModel issueModel);

	List<IssueModel> getIssueByIssueName(String issueName);

}
