package com.dpu.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;

import com.dpu.dao.PurchaseOrderDao;
import com.dpu.entity.Issue;
import com.dpu.entity.PurchaseOrder;
import com.dpu.entity.PurchaseOrderInvoice;
import com.dpu.entity.PurchaseOrderIssue;
import com.dpu.entity.Type;

@Repository
public class PurchaseOrderDaoImpl extends GenericDaoImpl<PurchaseOrder> implements PurchaseOrderDao{

	@SuppressWarnings("unchecked")

	@Override
	public List<PurchaseOrder> findAll(Session session) {
		StringBuilder sb = new StringBuilder(" select i from PurchaseOrder i join fetch i.vendor join fetch i.category join fetch i.unitType join fetch i.status ");
		Query query = session.createQuery(sb.toString());
		return query.list();
	}
	
	@Override
	public PurchaseOrder findById(Long id, Session session) {
		StringBuilder sb = new StringBuilder(" select i from PurchaseOrder i join fetch i.vendor join fetch i.category join fetch i.unitType join fetch i.status where i.id =:poId ");
		Query query = session.createQuery(sb.toString());
		query.setParameter("poId", id);
		return (PurchaseOrder) query.uniqueResult();
	}

	@Override
	public void addPurchaseOrder(PurchaseOrder po, List<PurchaseOrderIssue> poIssues, Type assignStatus, Session session) {
	
		session.save(po);
		
		for (PurchaseOrderIssue purchaseOrderIssue : poIssues) {
			Issue issue = purchaseOrderIssue.getIssue();
			issue.setStatus(assignStatus);
			session.update(issue);
			purchaseOrderIssue.setPurchaseOrder(po);
			session.save(purchaseOrderIssue);
		}
		
	}

	@Override
	public Long getMaxPoNO(Session session) {
		Long returnVal = 999l; // PO number starts from 100
		Long maxVal = (Long) session.createQuery(" select max(poNo) from PurchaseOrder ").uniqueResult();
		if(maxVal != null){
			returnVal = maxVal;
		}
		return returnVal;
	}

	@Override
	public void update(PurchaseOrder po, List<PurchaseOrderIssue> poIssues,  Type assignStatus, Type openStatus, Session session) {

		session.update(po);
		
		// existing issues
		List<PurchaseOrderIssue> existingPoIssues = po.getPoIssues();
		if(existingPoIssues != null && ! existingPoIssues.isEmpty()) {
			for (PurchaseOrderIssue purchaseOrderIssue : existingPoIssues) {
				Issue issue = purchaseOrderIssue.getIssue();
				issue.setStatus(openStatus);
				session.update(issue);
				session.delete(purchaseOrderIssue);
			}
		}
		
		//insert updated issues
		for (PurchaseOrderIssue purchaseOrderIssue : poIssues) {
			Issue issue = purchaseOrderIssue.getIssue();
			issue.setStatus(assignStatus);
			session.update(issue);
			purchaseOrderIssue.setPurchaseOrder(po);
			session.save(purchaseOrderIssue);
		}
		
	}

	@Override
	public void updateStatus(PurchaseOrder po, Type status, Session session) {
		po.setStatus(status);
		session.update(po);
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<PurchaseOrder> getStatusPOs(Session session, String statusVal) {
		StringBuilder sb = new StringBuilder(" select i from PurchaseOrder i left join fetch i.vendor left join fetch i.category left join fetch i.unitType join fetch i.status ")
		.append(" where i.status.typeName = :statusVal ");
		Query query = session.createQuery(sb.toString());
		query.setParameter("statusVal", statusVal);
		return query.list();
	}

	@Override
	public void createInvoice(PurchaseOrderInvoice invoice, Session session) {
		session.save(invoice);
	}

}
