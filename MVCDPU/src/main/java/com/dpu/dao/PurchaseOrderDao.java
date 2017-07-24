package com.dpu.dao;

import java.util.List;

import org.hibernate.Session;

import com.dpu.entity.Issue;
import com.dpu.entity.PurchaseOrder;
import com.dpu.entity.PurchaseOrderIssue;

public interface PurchaseOrderDao extends GenericDao<PurchaseOrder> {

	List<PurchaseOrder> findAll(Session session);

	PurchaseOrder findById(Long id, Session session);

	List<Object> getUnitNos(Long categoryId, Session session);

	List<Issue> getIssueByIssueName(Session session, String issueName);

	void saveIssue(Issue issue, Session session);

	void update(Issue issue, Session session);

	void addPurchaseOrder(PurchaseOrder po, List<PurchaseOrderIssue> poIssues, Session session);

	Long getMaxPoNO(Session session);

	void update(PurchaseOrder po, List<PurchaseOrderIssue> poIssues, Session session);

}
