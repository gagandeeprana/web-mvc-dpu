package com.dpu.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;

import com.dpu.dao.PurchaseOrderDao;
import com.dpu.entity.Issue;
import com.dpu.entity.PurchaseOrder;
import com.dpu.entity.PurchaseOrderIssue;

@Repository
public class PurchaseOrderDaoImpl extends GenericDaoImpl<PurchaseOrder> implements PurchaseOrderDao{

	@SuppressWarnings("unchecked")

	@Override
	public List<PurchaseOrder> findAll(Session session) {
		StringBuilder sb = new StringBuilder(" select i from PurchaseOrder i join fetch i.vendor join fetch i.category join fetch i.unitType join fetch i.status ");
		Query query = session.createQuery(sb.toString());
		return query.list();
	}
	
//	@Override
//	public Issue findById(Long id, Session session) {
//		StringBuilder sb = new StringBuilder(" select i from Issue i join fetch i.vmc join fetch i.unitType join fetch i.reportedBy join fetch i.status where i.id = :issueId ");
//		Query query = session.createQuery(sb.toString());
//		query.setParameter("issueId", id);
//		return (Issue) query.uniqueResult();
//	}

	@Override
	public PurchaseOrder findById(Long id, Session session) {
		StringBuilder sb = new StringBuilder(" select i from PurchaseOrder i join fetch i.vendor join fetch i.category join fetch i.unitType join fetch i.status where i.id =:poId ");
		Query query = session.createQuery(sb.toString());
		query.setParameter("poId", id);
		return (PurchaseOrder) query.uniqueResult();
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<Object> getUnitNos(Long categoryId, Session session) {
		StringBuilder sb = new StringBuilder(" SELECT unit_no FROM `newtruckmaster` truck WHERE category_id = :categoryId ")
		.append(" UNION ")
		.append(" SELECT unit_no FROM `trailer` WHERE category_id = :categoryId ");
		
		Query query = session.createSQLQuery(sb.toString());
		query.setParameter("categoryId", categoryId);
		return query.list();
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Issue> getIssueByIssueName(Session session, String issueName) {
		StringBuilder sb = new StringBuilder(" select i from Issue i join fetch i.vmc join fetch i.unitType join fetch i.reportedBy join fetch i.status where i.issueName like :issueName ");
		Query query = session.createQuery(sb.toString());
		query.setParameter("issueName", "%"+issueName+"%");
		return query.list();
	}

	@Override
	public void saveIssue(Issue issue, Session session) {
		session.save(issue);
	}

	@Override
	public void update(Issue issue, Session session) {
		session.update(issue);
		
	}

	@Override
	public void addPurchaseOrder(PurchaseOrder po, List<PurchaseOrderIssue> poIssues, Session session) {
	
		session.save(po);
		
		for (PurchaseOrderIssue purchaseOrderIssue : poIssues) {
			purchaseOrderIssue.setPurchaseOrder(po);
			session.save(purchaseOrderIssue);
		}
		
	}

	@Override
	public Long getMaxPoNO(Session session) {
		Long returnVal = 999l;
		Long maxVal = (Long) session.createQuery(" select max(poNo) from PurchaseOrder ").uniqueResult();
		if(maxVal != null){
			returnVal = maxVal;
		}
		return returnVal;
	}

	@Override
	public void update(PurchaseOrder po, List<PurchaseOrderIssue> poIssues, Session session) {

		session.update(po);
		
		// existing issues
		List<PurchaseOrderIssue> existingPoIssues = po.getPoIssues();
		if(existingPoIssues != null && ! existingPoIssues.isEmpty()) {
			for (PurchaseOrderIssue purchaseOrderIssue : existingPoIssues) {
				session.delete(purchaseOrderIssue);
			}
		}
		
		//insert updated issues
		for (PurchaseOrderIssue purchaseOrderIssue : poIssues) {
			purchaseOrderIssue.setPurchaseOrder(po);
			session.save(purchaseOrderIssue);
		}
		
	}

}
